//
//  CGPaintOutput.h
//  CGPaint
//
//  Created by Jason on 21/3/3.
//

#import "CGPaintFramebuffer.h"
#import "CGPaintContext.h"
#import "CGPaintInput.h"
#import "CGPaintUtils.h"
#import "CGPaintFramebufferCache.h"

@interface CGPaintOutput : NSObject
{
@protected
    CGPaintFramebuffer *_outputFramebuffer;
@protected
    NSMutableArray <id<CGPaintInput>>*_targets;
}

@property(nonatomic, strong, readonly)CGPaintFramebuffer *outFrameBuffer;

- (void)addTarget:(id<CGPaintInput>)newTarget;

- (void)removeTarget:(id<CGPaintInput>)targetToRemove;

- (void)removeAllTargets;

- (NSArray*)targets;

- (void)requestRender;

@end
