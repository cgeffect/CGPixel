//
//  CCGPUImageSplitScreen2Filter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2019/6/20.
//  Copyright © 2019年 Selfie. All rights reserved.
//

#import "CCGPUImageSplitScreen2Filter.h"
NSString * const kCCGPUImageSplitScreen2FilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform float time;
 
 void main() {
     vec2 uv = textureCoordinate.xy;
     float y;
     if (uv.y >= 0.0 && uv.y <= 0.5) {
         y = uv.y + 0.25;
     } else {
         y = uv.y - 0.25;
     }
     gl_FragColor = texture2D(inputImageTexture, vec2(uv.x, y));
 }

 );
@implementation CCGPUImageSplitScreen2Filter

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageSplitScreen2FilterShaderString];
    return self;
}
@end
