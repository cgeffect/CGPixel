//
//  CCGPUImageGrayFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2019/6/20.
//  Copyright © 2019年 Selfie. All rights reserved.
//

#import "CCGPUImageGrayFilter.h"
NSString * const kCCGPUImageGrayFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main (void) {
     
     vec4 mask = texture2D(inputImageTexture, textureCoordinate);
     float luminance = dot(mask.rgb, W);
     gl_FragColor = vec4(vec3(luminance), 1.0);
 }

 );


@implementation CCGPUImageGrayFilter

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageGrayFilterShaderString];
    return self;
}

@end
