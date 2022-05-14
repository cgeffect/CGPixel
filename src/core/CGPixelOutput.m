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
        //这里不用加递归删除, 滤镜链的结构为数组里面套数组, 最外层数组被删除, 内部的数组也会被删除
        for (CGPixelOutput *output in self->_targets) {
            
            //最后一个输出节点是没有输出的, 所以也就没有removeAllTargets
            if ([output respondsToSelector:@selector(removeAllTargets)]) {
                [output removeAllTargets];
            }
        }
        
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
//    [self removeAllTargets];
    [[CGPixelFramebufferCache sharedFramebufferCache] deleteAllUnassignedFramebuffers];
}

@end
