//
//  CGPixelSource.m
//  CGPixel
//
//  Created by Jason on 2021/11/5.
//

#import "CGPixelSource.h"
#import <Accelerate/Accelerate.h>

CGColorSpaceRef YYCGColorSpaceGetDeviceRGB(void) {
    static CGColorSpaceRef space;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        space = CGColorSpaceCreateDeviceRGB();
    });
    return space;
}

@implementation CGPixelSource

/*
 kCGImageAlphaPremultipliedFirst所表示的信息
 是否包含 alpha
 如果包含 alpha ，那么 alpha 信息所处的位置，在像素的最低有效位，比如 RGBA ，还是最高有效位，比如 ARGB ；
 如果包含 alpha ，那么每个颜色分量是否已经乘以 alpha 的值，这种做法可以加速图片的渲染时间，因为它避免了渲染时的额外乘法运算。比如，对于 RGB 颜色空间，用已经乘以 alpha 的数据来渲染图片，每个像素都可以避免 3 次乘法运算，红色乘以 alpha ，绿色乘以 alpha 和蓝色乘以 alpha 。
 */
//小端模式ARGB
UInt8 * CGRDecodeImage32LittleARGB1(CGImageRef imageRef, int width, int height) {
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
UInt8 * CGRDecodeImage32BigRGBA1(CGImageRef imageRef, int width, int height) {
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

CGImageRef YYCGImageCreateDecodedCopy(CGImageRef imageRef, BOOL decodeForDisplay) {
    if (!imageRef) return NULL;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    if (width == 0 || height == 0) return NULL;
    
    if (decodeForDisplay) { //decode with redraw (may lose some precision)
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, YYCGColorSpaceGetDeviceRGB(), bitmapInfo);
        if (!context) return NULL;
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef newImage = CGBitmapContextCreateImage(context);
        CFRelease(context);
        return newImage;
        
    } else {
        CGColorSpaceRef space = CGImageGetColorSpace(imageRef);
        size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
        size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        if (bytesPerRow == 0 || width == 0 || height == 0) return NULL;
        
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        if (!dataProvider) return NULL;
        CFDataRef data = CGDataProviderCopyData(dataProvider); // decode
        if (!data) return NULL;
        
        CGDataProviderRef newProvider = CGDataProviderCreateWithCFData(data);
        CFRelease(data);
        if (!newProvider) return NULL;
        
        CGImageRef newImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, space, bitmapInfo, newProvider, NULL, false, kCGRenderingIntentDefault);
        CFRelease(newProvider);
        return newImage;
    }
}
/*
 int width = (int)CGImageGetWidth(image.CGImage);
 int height = (int)CGImageGetHeight(image.CGImage);
 UInt8 *bgra = CGRDecodeImage32LittleARGB(image.CGImage, width, height);
 NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"bgra8_1125x1125.bgra"];
 FILE *file = fopen([path UTF8String], "wb++");
 int buffersize = width * height * 4;
 fwrite((uint8_t *)bgra, 1, buffersize, file);
 fclose(file);
 */


+ (CVPixelBufferRef)pixelBufferCreate:(OSType)pixelFormatType width:(NSUInteger)width height:(NSUInteger)height {
    CVPixelBufferRef _pixelBuffer;
    CFDictionaryRef pixelAttributes = (__bridge CFDictionaryRef)
    (@{
        (id)kCVPixelBufferIOSurfacePropertiesKey : @{},
        (id)kCVPixelBufferOpenGLESCompatibilityKey:@(YES)
     });
    CVPixelBufferCreate(kCFAllocatorDefault, (size_t) width, (size_t) height, pixelFormatType, pixelAttributes, &_pixelBuffer);
    return _pixelBuffer;
}
+ (BOOL)create32BGRAPixelBufferWithNV12:(nonnull UInt8 *)nv12 width:(NSUInteger)width height:(NSUInteger)height dstBuffer:(nonnull CVPixelBufferRef)dstBuffer {
    @autoreleasepool {
        vImage_YpCbCrToARGB outInfo;
        vImage_YpCbCrPixelRange pixelRange = (vImage_YpCbCrPixelRange){ 0, 128, 255, 255, 255, 1, 255, 0 };
        vImageConvert_YpCbCrToARGB_GenerateConversion(kvImage_YpCbCrToARGBMatrix_ITU_R_601_4, &pixelRange, &outInfo, kvImage420Yp8_CbCr8, kvImageARGB8888, kvImageNoFlags);
        vImage_Error error = kvImageNoError;
        
        vImage_Buffer srcYp = {.data = nv12, .width = width, .height = height, .rowBytes = width};
        vImage_Buffer srcCbCr = {.data = nv12 + width * height, .width = width, .height = height / 2, .rowBytes = width};

        CVPixelBufferLockBaseAddress(dstBuffer, kCVPixelBufferLock_ReadOnly);
        vImage_Buffer dest;
        dest.data = CVPixelBufferGetBaseAddress(dstBuffer);
        dest.width = CVPixelBufferGetWidth(dstBuffer);
        dest.height = CVPixelBufferGetHeight(dstBuffer);
        dest.rowBytes = CVPixelBufferGetBytesPerRow(dstBuffer);
        
        uint8_t permuteMap[4] = {3, 2, 1, 0}; // BGRA
        vImageConvert_420Yp8_CbCr8ToARGB8888(&srcYp, &srcCbCr, &dest, &outInfo, permuteMap, 255, kvImageNoFlags);
        CVPixelBufferUnlockBaseAddress(dstBuffer, kCVPixelBufferLock_ReadOnly);
        return error == kvImageNoError;
    }
}

+ (nullable CVPixelBufferRef)create420Yp8_CbCr8PixelBufferWithNV12:(UInt8 *)data width:(NSInteger)width height:(NSInteger)height {

    NSDictionary *pixelAttributes = @{
            (NSString *) kCVPixelBufferIOSurfacePropertiesKey: @{},
            (NSString *) kCVPixelBufferOpenGLESCompatibilityKey: @(YES)
    };
    CVPixelBufferRef pixelBuffer = NULL;

    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
            (size_t) width, (size_t) height,
            kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
            (__bridge CFDictionaryRef) (pixelAttributes), &pixelBuffer);

    if (status != kCVReturnSuccess) {
        NSLog(@"Unable to create CVPixelBuffer %d", status);
        return NULL;
    }
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);

    uint8_t *y_src = data;
    uint8_t *y_dest = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    size_t y_src_bytesPerRow = (size_t) width;
    size_t y_dest_bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);

    for (int i = 0; i < height; i++) {
        bzero(y_dest, y_dest_bytesPerRow);
        memcpy(y_dest, y_src, MIN(y_src_bytesPerRow, y_dest_bytesPerRow));
        y_src += y_src_bytesPerRow;
        y_dest += y_dest_bytesPerRow;
    }

    uint8_t *uv_src = data + width * height;
    uint8_t *uv_dest = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    size_t uv_src_bytesPerRow = (size_t) width;
    size_t uv_dest_bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);

    for (int i = 0; i < height / 2; i++) {
        bzero(uv_dest, uv_dest_bytesPerRow);
        memcpy(uv_dest, uv_src, MIN(uv_src_bytesPerRow, uv_dest_bytesPerRow));
        uv_src += uv_src_bytesPerRow;
        uv_dest += uv_dest_bytesPerRow;
    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    return pixelBuffer;
}
@end
