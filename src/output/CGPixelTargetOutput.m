//
//  CGPixelFinally.m
//  CGPixel
//
//  Created by Jason on 2021/5/22.
//

#import "CGPixelTargetOutput.h"

@implementation CGPixelTargetOutput

#pragma mark -
#pragma mark CGPaintInput
- (void)newFrameReadyAtTime:(CMTime)frameTime timimgInfo:(CMSampleTimingInfo)timimgInfo {
    [self captureFramebufferToOutput];
}

- (void)setInputFramebuffer:(CGPixelFramebuffer *)framebuffer {
    _finallyFramebuffer = framebuffer;
}

- (void)captureFramebufferToOutput {

}

@end
