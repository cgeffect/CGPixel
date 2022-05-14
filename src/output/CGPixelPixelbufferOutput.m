//
//  CGPixelPixelbufferOutput.m
//  CGPixel
//
//  Created by CGPixel on 2021/5/14.
//

#import "CGPixelPixelbufferOutput.h"
#import <Accelerate/Accelerate.h>

@implementation CGPixelPixelbufferOutput
{
    CGPixelFramebuffer *_finallyFramebuffer;
}

#pragma mark -
#pragma mark CGPaintInput

- (void)newFrameReadyAtTime:(CMTime)frameTime framebuffer:(CGPixelFramebuffer *)framebuffer {
    _finallyFramebuffer = framebuffer;
    if (_outputCallback == nil || self.enableOutput == NO) {
        return;
    }

    if ([CGPixelContext supportsFastTextureUpload]) {
        self.outputCallback(_finallyFramebuffer.renderTarget);
    } else {
        [_finallyFramebuffer bindFramebuffer];
        NSAssert(_finallyFramebuffer.textureOptions.internalFormat == GL_RGBA, @"For conversion to a CGImage the output texture format for this filter must be GL_RGBA.");
        NSAssert(_finallyFramebuffer.textureOptions.type == GL_UNSIGNED_BYTE, @"For conversion to a CGImage the type of the output texture of this filter must be GL_UNSIGNED_BYTE.");
        
        __block GLubyte *rgba;
        CGSize size = self->_finallyFramebuffer.fboSize;
        NSUInteger totalBytesForImage = (int)size.width * (int)size.height * 4;
        runSyncOnSerialQueue(^{
            [[CGPixelContext sharedRenderContext] useAsCurrentContext];
            [self->_finallyFramebuffer bindFramebuffer];
            rgba = (GLubyte *)malloc(totalBytesForImage);
            glReadPixels(0, 0, (int)size.width, (int)size.height, GL_RGBA, GL_UNSIGNED_BYTE, rgba);
        });
        
//        CGColorSpaceRef defaultRGBColorSpace = CGColorSpaceCreateDeviceRGB();
//        CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rawImagePixels, totalBytesForImage, NULL);
//        CGImageRef cgImageFromBytes = CGImageCreate((int)size.width, (int)size.height, 8, 32, 4 * (int)size.width, defaultRGBColorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaLast, dataProvider, NULL, NO, kCGRenderingIntentDefault);
//        CGDataProviderRelease(dataProvider);
//        CGColorSpaceRelease(defaultRGBColorSpace);

//        uint8_t *bgra = (uint8_t *)malloc(size.width * size.height * 4);
//        int index = 0;
//        for (int i = 0; i < size.width; i++) {
//            for (int j = 0; j < size.height; j++) {
//                //BGRA -> RGBA
//                memcpy(*(bgra + index + 0), *(rgba + index + 2), 1);
//                memcpy(*(bgra + index + 1), *(rgba + index + 1), 1);
//                memcpy(*(bgra + index + 2), *(rgba + index + 0), 1);
//                memcpy(*(bgra + index + 3), *(rgba + index + 3), 1);
//                index += 4;
//            }
//        }
//        CVPixelBufferRef dstBuffer = [self pixelBufferCreate:kCVPixelFormatType_32BGRA width:size.width height:size.height];
//        CVPixelBufferLockBaseAddress(dstBuffer, kCVPixelBufferLock_ReadOnly);
//        void * dst = CVPixelBufferGetBaseAddress(dstBuffer);
//        memcpy(dst, bgra, totalBytesForImage);
//        CVPixelBufferUnlockBaseAddress(dstBuffer, kCVPixelBufferLock_ReadOnly);
//        self.outputCallback(dstBuffer);
//        free(rgba);
//        free(bgra);
//        CVPixelBufferRelease(dstBuffer);
    }
}

- (CVPixelBufferRef)pixelBufferCreate:(OSType)pixelFormatType width:(NSUInteger)width height:(NSUInteger)height {
    CVPixelBufferRef _pixelBuffer;
    CFDictionaryRef pixelAttributes = (__bridge CFDictionaryRef)
    (@{
        (id)kCVPixelBufferIOSurfacePropertiesKey : @{},
        (id)kCVPixelBufferOpenGLESCompatibilityKey:@(YES)
     });
    CVPixelBufferCreate(kCFAllocatorDefault, (size_t) width, (size_t) height, pixelFormatType, pixelAttributes, &_pixelBuffer);
    return _pixelBuffer;
}

@end
