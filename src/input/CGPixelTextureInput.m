//
//  CGPixelTextureInput.m
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//  Copyright © 2021 CGPixel. All rights reserved.
//

#import "CGPixelTextureInput.h"
#import "CGPixelFramebufferCache.h"

@implementation CGPixelTextureInput

- (instancetype)initWithTexture:(GLuint)newInputTexture size:(CGSize)newTextureSize {
    self = [super init];
    if (self) {
        _outputFramebuffer = [[CGPixelFramebuffer alloc] initWithSize:newTextureSize texture:newInputTexture];
    }

    return self;
}

- (void)requestRender {
    runSyncOnSerialQueue(^{
        [[CGPixelContext sharedRenderContext] useAsCurrentContext];
        for (id<CGPixelInput> currentTarget in self->_targets){
            [currentTarget newFrameReadyAtTime:kCMTimeZero framebuffer:self->_outputFramebuffer];
        }
    });
}
@end
