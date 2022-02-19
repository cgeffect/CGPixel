//
//  CGPixelRawDataOutput.m
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//

#import "CGPixelRawDataOutput.h"

@implementation CGPixelRawDataOutput

#pragma mark -
#pragma mark Image capture
- (void)captureFramebufferToOutput {
    if (_outputCallback == nil || self.enableOutput == NO) {
        return;
    }

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
    NSData *data = [NSData dataWithBytes:rawImagePixels length:totalBytesForImage];
    self.outputCallback(data);
    free(rawImagePixels);
}

@end
