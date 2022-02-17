//
//  CGPaintImageOutput.m
//  CGPaint
//
//  Created by CGPaint on 2021/5/13.
//  Copyright © 2021 CGPaint. All rights reserved.
//

#import "CGPaintImageOutput.h"

@interface CGPaintImageOutput ()
{
}
@end

@implementation CGPaintImageOutput

#pragma mark -
#pragma mark Image capture
void dataProviderReleaseCallbackForImage (void *info, const void *data, size_t size)
{
    free((void *)data);
}
void dataProviderCallbackForImage (void *info, const void *data, size_t size)
{
//    CGPaintFramebuffer *framebuffer = (__bridge_transfer CGPaintFramebuffer*)info;
    
}

- (void)captureFramebufferToOutput {
    if (_outputCallback == nil || self.enableOutput == NO) {
        return;
    }
    [_finallyFramebuffer bindFramebuffer];
    NSAssert(_finallyFramebuffer.textureOptions.internalFormat == GL_RGBA, @"For conversion to a CGImage the output texture format for this filter must be GL_RGBA.");
    NSAssert(_finallyFramebuffer.textureOptions.type == GL_UNSIGNED_BYTE, @"For conversion to a CGImage the type of the output texture of this filter must be GL_UNSIGNED_BYTE.");
    CGSize size = self->_finallyFramebuffer.fboSize;
    __block CGImageRef cgImageFromBytes;
    runSyncOnSerialQueue(^{
        [[CGPaintContext sharedRenderContext] useAsCurrentContext];
        glFinish();
        if ([CGPaintContext supportsFastTextureUpload]) {
            CVPixelBufferRef renderTarget = self->_finallyFramebuffer.renderTarget;
            NSUInteger paddedWidthOfImage = CVPixelBufferGetBytesPerRow(renderTarget) / 4.0;
            NSUInteger paddedBytesForImage = paddedWidthOfImage * (int)size.height * 4;
            CGColorSpaceRef defaultRGBColorSpace = CGColorSpaceCreateDeviceRGB();
            CVPixelBufferLockBaseAddress(renderTarget, kCVPixelBufferLock_ReadOnly);
            GLubyte *rawImagePixels = (GLubyte *)CVPixelBufferGetBaseAddress(renderTarget);
            CGDataProviderRef dataProvider = CGDataProviderCreateWithData((__bridge_retained void*)self, rawImagePixels, paddedBytesForImage, dataProviderCallbackForImage);
            //Little-Endian ARGB
            cgImageFromBytes = CGImageCreate((int)size.width, (int)size.height, 8, 32, CVPixelBufferGetBytesPerRow(renderTarget), defaultRGBColorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst, dataProvider, NULL, NO, kCGRenderingIntentDefault);
            CVPixelBufferUnlockBaseAddress(renderTarget, kCVPixelBufferLock_ReadOnly);
            CGDataProviderRelease(dataProvider);
            CGColorSpaceRelease(defaultRGBColorSpace);
        } else {
            CGColorSpaceRef defaultRGBColorSpace = CGColorSpaceCreateDeviceRGB();
            NSUInteger totalBytesForImage = (int)size.width * (int)size.height * 4;
            [self->_finallyFramebuffer bindFramebuffer];
            GLubyte *rawImagePixels = (GLubyte *)malloc(totalBytesForImage);
            glReadPixels(0, 0, (int)size.width, (int)size.height, GL_RGBA, GL_UNSIGNED_BYTE, rawImagePixels);
            CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rawImagePixels, totalBytesForImage, dataProviderReleaseCallbackForImage);
            cgImageFromBytes = CGImageCreate((int)size.width, (int)size.height, 8, 32, 4 * (int)size.width, defaultRGBColorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaLast, dataProvider, NULL, NO, kCGRenderingIntentDefault);
            CGDataProviderRelease(dataProvider);
            CGColorSpaceRelease(defaultRGBColorSpace);
        }
    });
    self.outputCallback(cgImageFromBytes);
    CGImageRelease(cgImageFromBytes);
}

- (void)dealloc
{
}
@end
