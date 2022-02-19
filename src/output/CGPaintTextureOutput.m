//
//  CGPixelTextureOutput.m
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//  Copyright © 2021 CGPixel. All rights reserved.
//

#import "CGPaintTextureOutput.h"

@implementation CGPaintTextureOutput
{
    GLuint _texture;
    CGSize _textureSize;
}
- (GLuint)texture {
    return _texture;
}

- (CGSize)textureSize {
    return _textureSize;
}

- (void)newFrameReadyAtTime:(CMTime)frameTime timimgInfo:(CMSampleTimingInfo)timimgInfo {
    
}

- (void)setInputFramebuffer:(CGPaintFramebuffer *)framebuffer {
    _texture = framebuffer.texture;
    _textureSize = framebuffer.fboSize;
}

@end
