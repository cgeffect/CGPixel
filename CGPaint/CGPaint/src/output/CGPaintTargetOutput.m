//
//  CGPaintFinally.m
//  CGPaint
//
//  Created by Jason on 2021/5/22.
//

#import "CGPaintTargetOutput.h"

@implementation CGPaintTargetOutput

#pragma mark -
#pragma mark CGPaintInput
- (void)newFrameReadyAtTime:(CMTime)frameTime timimgInfo:(CMSampleTimingInfo)timimgInfo {
    [self captureFramebufferToOutput];
}

- (void)setInputFramebuffer:(CGPaintFramebuffer *)framebuffer {
    _finallyFramebuffer = framebuffer;
}

- (void)captureFramebufferToOutput {

}

@end
