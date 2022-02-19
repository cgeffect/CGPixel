//
//  CGPixelImageInput.m
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//  Copyright © 2021 CGPixel. All rights reserved.
//

#import "CGPixelImageInput.h"
#import "CGPixelContext.h"
#import "CGPixelFramebufferCache.h"

#define MAX_SIZE UIScreen.mainScreen.bounds.size.width

@interface CGPixelImageInput ()
{
    BOOL removePremultiplication;
    BOOL shouldSmoothlyScaleOutput;
}
@end

@implementation CGPixelImageInput

- (instancetype)initWithImage:(UIImage *)newImageSource {
    self = [super init];
    if (self) {
        if (!(self = [super init]))
        {
            return nil;
        }
        
        CGFloat widthOfImage = CGImageGetWidth(newImageSource.CGImage);
        CGFloat heightOfImage = CGImageGetHeight(newImageSource.CGImage);

        // If passed an empty image reference, CGContextDrawImage will fail in future versions of the SDK.
        NSAssert( widthOfImage > 0 && heightOfImage > 0, @"Passed image must not be empty - it should be at least 1px tall and wide");
        
        CGSize pixelSizeOfImage = CGSizeMake(widthOfImage, heightOfImage);
        CGSize pixelSizeToUseForTexture = pixelSizeOfImage;
        
        //是否重画
        BOOL shouldRedrawUsingCoreGraphics = NO;
        CGSize scaledImageSizeToFitOnGPU = [CGPixelContext sizeThatFitsWithinATextureForSize:pixelSizeOfImage];
        if (!CGSizeEqualToSize(scaledImageSizeToFitOnGPU, pixelSizeOfImage)) {
            pixelSizeOfImage = scaledImageSizeToFitOnGPU;
            pixelSizeToUseForTexture = pixelSizeOfImage;
            shouldRedrawUsingCoreGraphics = YES;
        }
        
        GLubyte *imageData = NULL;
        CFDataRef dataFromImageDataProvider = NULL;
        GLenum format = GL_BGRA;
        BOOL isLitteEndian = YES;
        BOOL alphaFirst = NO;
        BOOL premultiplied = NO;
        
        int BytesPerRow = (int)CGImageGetBytesPerRow(newImageSource.CGImage);
        int BitsPerPixel = (int)CGImageGetBitsPerPixel(newImageSource.CGImage);
        int BitsPerComponent = (int)CGImageGetBitsPerComponent(newImageSource.CGImage);
        NSLog(@"BytesPerRow = %d, BitsPerPixel = %d, BitsPerComponent = %d", BytesPerRow, BitsPerPixel, BitsPerComponent);
        if (!shouldRedrawUsingCoreGraphics) {
            /* Check that the memory layout is compatible with GL, as we cannot use glPixelStore to
             * tell GL about the memory layout with GLES.
             */
            if (CGImageGetBytesPerRow(newImageSource.CGImage) != CGImageGetWidth(newImageSource.CGImage) * 4 ||
                CGImageGetBitsPerPixel(newImageSource.CGImage) != 32 ||
                CGImageGetBitsPerComponent(newImageSource.CGImage) != 8)
            {
                shouldRedrawUsingCoreGraphics = YES;
            } else {
                /* Check that the bitmap pixel format is compatible with GL */
                CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(newImageSource.CGImage);
                if ((bitmapInfo & kCGBitmapFloatComponents) != 0) {
                    /* We don't support float components for use directly in GL */
                    shouldRedrawUsingCoreGraphics = YES;
                } else {
                    CGBitmapInfo byteOrderInfo = bitmapInfo & kCGBitmapByteOrderMask;
                    if (byteOrderInfo == kCGBitmapByteOrder32Little) {
                        /* Little endian, for alpha-first we can use this bitmap directly in GL */
                        CGImageAlphaInfo alphaInfo = bitmapInfo & kCGBitmapAlphaInfoMask;
                        if (alphaInfo != kCGImageAlphaPremultipliedFirst && alphaInfo != kCGImageAlphaFirst &&
                            alphaInfo != kCGImageAlphaNoneSkipFirst) {
                            shouldRedrawUsingCoreGraphics = YES;
                        }
                    } else if (byteOrderInfo == kCGBitmapByteOrderDefault || byteOrderInfo == kCGBitmapByteOrder32Big) {
                        isLitteEndian = NO;
                        /* Big endian, for alpha-last we can use this bitmap directly in GL */
                        CGImageAlphaInfo alphaInfo = bitmapInfo & kCGBitmapAlphaInfoMask;
                        if (alphaInfo != kCGImageAlphaPremultipliedLast && alphaInfo != kCGImageAlphaLast &&
                            alphaInfo != kCGImageAlphaNoneSkipLast) {
                            shouldRedrawUsingCoreGraphics = YES;
                        } else {
                            /* Can access directly using GL_RGBA pixel format */
                            premultiplied = alphaInfo == kCGImageAlphaPremultipliedLast || alphaInfo == kCGImageAlphaPremultipliedLast;
                            alphaFirst = alphaInfo == kCGImageAlphaFirst || alphaInfo == kCGImageAlphaPremultipliedFirst;
                            format = GL_RGBA;
                        }
                    }
                }
            }
        }
        
        BOOL is32Little = YES;
        if (shouldRedrawUsingCoreGraphics) {
            int width = pixelSizeToUseForTexture.width;
            int height = pixelSizeToUseForTexture.height;
            CGRResizeWithMaxSize(width, height, &width, &height, MAX_SIZE * 3);
            if (is32Little) {
                imageData = CGRDecodeImage32LittleARGB(newImageSource.CGImage, width, height);
            } else {
                imageData = CGRDecodeImage32BigRGBA(newImageSource.CGImage, width, height);
            }
            pixelSizeToUseForTexture = CGSizeMake(width, height);
            isLitteEndian = YES;
            alphaFirst = YES;
            premultiplied = YES;
        } else {
            dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(newImageSource.CGImage));
            imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
        }
        
        //如果使用CGRDecodeImage32L解码, 则format格式为GL_BGRA
        //如果使用CGRDecodeImage32B解码, 则format格式为GL_RGBA
        if (is32Little) {
            [self genTexture:format gl_format:GL_RGBA fboSize:pixelSizeToUseForTexture imageData:imageData];
        } else {
            [self genTexture:GL_RGBA gl_format:GL_RGBA fboSize:pixelSizeToUseForTexture imageData:imageData];
        }
        if (shouldRedrawUsingCoreGraphics) {
            free(imageData);
            imageData = NULL;
        } else {
            if (dataFromImageDataProvider) {
                CFRelease(dataFromImageDataProvider);
                dataFromImageDataProvider = NULL;
            }
        }
    }
    return self;
}

- (void)genTexture:(GLenum)format gl_format:(GLenum)gl_foramt fboSize:(CGSize)fboSize imageData:(GLubyte *)imageData {
    runSyncOnSerialQueue(^{
        [[CGPixelContext sharedRenderContext] useAsCurrentContext];
        
        //申请FBO, 关联TextureGL_BGRA
        self->_outputFramebuffer = [[CGPixelFramebuffer alloc] initWithSize:fboSize onlyTexture:YES];
        [self->_outputFramebuffer bindTexture];

        if (self->shouldSmoothlyScaleOutput) {
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        }
       
        //第三个参数GL_RGBA是纹理的颜色空间, 第七个参数的颜色是数据源的颜色
        int width = fboSize.width;
        int height = fboSize.height;
            
        [self->_outputFramebuffer upload:imageData size:CGSizeMake(width, height) internalformat:gl_foramt format:format isOverride:NO];

        if (self->shouldSmoothlyScaleOutput) {
            glGenerateMipmap(GL_TEXTURE_2D);
        }
        [self->_outputFramebuffer unbindTexture];
    });
}

- (void)requestRender {
    [super requestRender];
    runSyncOnSerialQueue(^{
        [[CGPixelContext sharedRenderContext] useAsCurrentContext];
        for (id<CGPixelInput> currentTarget in self->_targets){
            [currentTarget setInputFramebuffer:self->_outputFramebuffer];
            CMSampleTimingInfo info = {0};
            [currentTarget newFrameReadyAtTime:kCMTimeZero timimgInfo:info];
        }
    });
}

- (void)dealloc
{
}

#pragma mark -
#pragma mark 解码图片
void CGRResizeWithMaxSize(int oriImgW, int oriImgH, int *width, int *height, int maxSize) {
    if (oriImgW > maxSize && oriImgH > maxSize) {
        CGFloat aspect = oriImgW / oriImgH;
        if (aspect > 1) {
            oriImgH = maxSize;
            oriImgW = oriImgH * aspect;
        } else {
            oriImgW = maxSize;
            oriImgH = oriImgW / aspect;
        }
    } else if (oriImgW > maxSize && oriImgH < maxSize) {
        CGFloat aspect = oriImgW / oriImgH;
        oriImgW = maxSize;
        oriImgH = oriImgW / aspect;
    } else if (oriImgW < maxSize && oriImgH > maxSize) {
        CGFloat aspect = oriImgW / oriImgH;
        oriImgH = maxSize;
        oriImgW = oriImgH * aspect;
    }
    
    *width = (int) oriImgW;
    *height = (int) oriImgH;
}

/*
 kCGImageAlphaPremultipliedFirst所表示的信息
 是否包含 alpha
 如果包含 alpha ，那么 alpha 信息所处的位置，在像素的最低有效位，比如 RGBA ，还是最高有效位，比如 ARGB ；
 如果包含 alpha ，那么每个颜色分量是否已经乘以 alpha 的值，这种做法可以加速图片的渲染时间，因为它避免了渲染时的额外乘法运算。比如，对于 RGB 颜色空间，用已经乘以 alpha 的数据来渲染图片，每个像素都可以避免 3 次乘法运算，红色乘以 alpha ，绿色乘以 alpha 和蓝色乘以 alpha 。
 */
//小端模式ARGB
UInt8 * CGRDecodeImage32LittleARGB(CGImageRef imageRef, int width, int height) {
    UInt8 * imageData = (UInt8 *) calloc(1, width * height * 4);
    CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
    BOOL hasAlpha = NO;
    if (alphaInfo == kCGImageAlphaPremultipliedLast ||
        alphaInfo == kCGImageAlphaPremultipliedFirst ||
        alphaInfo == kCGImageAlphaLast ||
        alphaInfo == kCGImageAlphaFirst) {
        hasAlpha = YES;
    }
    // BGRA8888 (premultiplied) or BGRX8888
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
    bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, genericRGBColorspace, bitmapInfo);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
    CGContextRelease(context);
    CGColorSpaceRelease(genericRGBColorspace);
    return imageData;
}

//大端模式RGBA
UInt8 * CGRDecodeImage32BigRGBA(CGImageRef imageRef, int width, int height) {
    UInt8 * imageData = (UInt8 *) calloc(1, width * height * 4);
    CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
//    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
    //颜色格式和存储方式 kCGBitmapByteOrderDefault = kCGBitmapByteOrder32Big
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, genericRGBColorspace, bitmapInfo);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(genericRGBColorspace);
    return imageData;
}

@end
