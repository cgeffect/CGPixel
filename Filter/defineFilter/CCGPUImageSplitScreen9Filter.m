//
//  CCGPUImageSplitScreen9Filter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2019/6/20.
//  Copyright © 2019年 Selfie. All rights reserved.
//

#import "CCGPUImageSplitScreen9Filter.h"
NSString * const kCCGPUImageSplitScreen9FilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform float time;
 
 void main() {
     vec2 uv = textureCoordinate.xy;
     if (uv.x < 1.0 / 3.0) {
         uv.x = uv.x * 3.0;
     } else if (uv.x < 2.0 / 3.0) {
         uv.x = (uv.x - 1.0 / 3.0) * 3.0;
     } else {
         uv.x = (uv.x - 2.0 / 3.0) * 3.0;
     }
     if (uv.y <= 1.0 / 3.0) {
         uv.y = uv.y * 3.0;
     } else if (uv.y < 2.0 / 3.0) {
         uv.y = (uv.y - 1.0 / 3.0) * 3.0;
     } else {
         uv.y = (uv.y - 2.0 / 3.0) * 3.0;
     }
     gl_FragColor = texture2D(inputImageTexture, uv);
 }
 
 );


@implementation CCGPUImageSplitScreen9Filter

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageSplitScreen9FilterShaderString];
    return self;
}
@end
