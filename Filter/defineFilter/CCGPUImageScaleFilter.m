//
//  CCGPUImageScaleFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2019/6/18.
//  Copyright © 2019年 Selfie. All rights reserved.
//

#import "CCGPUImageScaleFilter.h"

NSString * const kCCGPUImageScaleFilterShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 
 varying vec2 textureCoordinate;
 
 uniform float time;
 
 const float PI = 3.1415926;
 
 void main (void) {
     float duration = 0.6;
     float maxAmplitude = 0.4;

     float currentTime = mod(time, duration);
     float amplitude = 1.0 + maxAmplitude * abs(sin(currentTime * (PI / duration)));
     
     gl_Position = vec4(position.x * amplitude, position.y * amplitude, position.zw);
     textureCoordinate = inputTextureCoordinate.xy;
 }
);

@implementation CCGPUImageScaleFilter

- (id)init {
    self = [super initWithVertexShaderFromString:kCCGPUImageScaleFilterShaderString fragmentShaderFromString:kGPUImagePassthroughFragmentShaderString];
    return self;
}

@end
