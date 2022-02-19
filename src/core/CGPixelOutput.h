//
//  CGPixelOutput.h
//  CGPixel
//
//  Created by Jason on 21/3/3.
//

#import "CGPaintFramebuffer.h"
#import "CGPixelContext.h"
#import "CGPixelInput.h"
#import "CGPixelUtils.h"
#import "CGPaintFramebufferCache.h"

@interface CGPixelOutput : NSObject
{
@protected
    CGPaintFramebuffer *_outputFramebuffer;
@protected
    NSMutableArray <id<CGPixelInput>>*_targets;
}

@property(nonatomic, strong, readonly)CGPaintFramebuffer *outFrameBuffer;

- (void)addTarget:(id<CGPixelInput>)newTarget;

- (void)removeTarget:(id<CGPixelInput>)targetToRemove;

- (void)removeAllTargets;

- (NSArray*)targets;

- (void)requestRender;

@end
