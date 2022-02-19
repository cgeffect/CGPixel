//
//  CGPixelPixelbufferOutput.m
//  CGPixel
//
//  Created by CGPixel on 2021/5/14.
//

#import "CGPixelPixelbufferOutput.h"
#import <Accelerate/Accelerate.h>

@implementation CGPixelPixelbufferOutput

#pragma mark -
#pragma mark Image capture
- (void)captureFramebufferToOutput {
    if (_outputCallback == nil || self.enableOutput == NO) {
        return;
    }

    if ([CGPixelContext supportsFastTextureUpload]) {
        self.outputCallback(_finallyFramebuffer.renderTarget);
    } else {
        [_finallyFramebuffer bindFramebuffer];
        NSAssert(_finallyFramebuffer.textureOptions.internalFormat == GL_RGBA, @"For conversion to a CGImage the output texture format for this filter must be GL_RGBA.");
        NSAssert(_finallyFramebuffer.textureOptions.type == GL_UNSIGNED_BYTE, @"For conversion to a CGImage the type of the output texture of this filter must be GL_UNSIGNED_BYTE.");
        
        __block GLubyte *rawImagePixels;
        CGSize _size = self->_finallyFramebuffer.fboSize;
        NSUInteger totalBytesForImage = (int)_size.width * (int)_size.height * 4;
        runSyncOnSerialQueue(^{
            [[CGPixelContext sharedRenderContext] useAsCurrentContext];
            [self->_finallyFramebuffer bindFramebuffer];
            rawImagePixels = (GLubyte *)malloc(totalBytesForImage);
            glReadPixels(0, 0, (int)_size.width, (int)_size.height, GL_RGBA, GL_UNSIGNED_BYTE, rawImagePixels);
        });
        CVPixelBufferRef dstBuffer = [self pixelBufferCreate:kCVPixelFormatType_32BGRA width:_size.width height:_size.height];
        CVPixelBufferLockBaseAddress(dstBuffer, kCVPixelBufferLock_ReadOnly);
        void * dst = CVPixelBufferGetBaseAddress(dstBuffer);
        memcpy(dst, rawImagePixels, totalBytesForImage);
        CVPixelBufferUnlockBaseAddress(dstBuffer, kCVPixelBufferLock_ReadOnly);
        self.outputCallback(dstBuffer);
        free(rawImagePixels);
        CVPixelBufferRelease(dstBuffer);
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
