//
//  CGPixelYuvOutput.m
//  CGPixel
//
//  Created by Jason on 2022/5/14.
//

#import "CGPixelYuvOutput.h"

@implementation CGPixelYuvOutput
{
    CGPixelFramebuffer *_finallyFramebuffer;
}

#pragma mark -
#pragma mark CGPaintInput
- (void)newFrameReadyAtTime:(CMTime)frameTime framebuffer:(CGPixelFramebuffer *)framebuffer {
    _finallyFramebuffer = framebuffer;

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
}

- (void)dealloc {

}

@end
