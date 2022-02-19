//
//  CGPixelOutput.m
//  CGPixel
//
//  Created by Jason on 21/3/3.
//

#import "CGPixelOutput.h"

@implementation CGPixelOutput

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

- (void)addTarget:(id<CGPixelInput>)newTarget;
{
    [_targets addObject:newTarget];
}

- (void)removeTarget:(id<CGPixelInput>)targetToRemove;
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

- (CGPixelFramebuffer *)outFrameBuffer {
    return _outputFramebuffer;
}

- (void)requestRender {
    
}

- (void)dealloc
{
    [self removeAllTargets];
    [[CGPixelFramebufferCache sharedFramebufferCache] deleteAllUnassignedFramebuffers];
}

@end
