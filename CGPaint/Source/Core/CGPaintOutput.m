//
//  CGPaintOutput.m
//  CGPaint
//
//  Created by Jason on 21/3/3.
//

#import "CGPaintOutput.h"

@implementation CGPaintOutput

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    _targets = [[NSMutableArray alloc] init];
    return self;
}

- (NSArray*)targets;
{
    return [NSArray arrayWithArray:_targets];
}

- (void)addTarget:(id<CGPaintInput>)newTarget;
{
    [_targets addObject:newTarget];
}

- (void)removeTarget:(id<CGPaintInput>)targetToRemove;
{
    if(![_targets containsObject:targetToRemove])
    {
        return;
    }
    
    runSyncOnSerialQueue(^{
        [self->_targets removeObject:targetToRemove];
    });
}

- (void)removeAllTargets
{
    runSyncOnSerialQueue(^{
        [self->_targets removeAllObjects];
    });
}

- (CGPaintFramebuffer *)outFrameBuffer {
    return _outputFramebuffer;
}

- (void)requestRender {
    
}

- (void)dealloc
{
    [self removeAllTargets];
    [[CGPaintFramebufferCache sharedFramebufferCache] deleteAllUnassignedFramebuffers];
}

@end
