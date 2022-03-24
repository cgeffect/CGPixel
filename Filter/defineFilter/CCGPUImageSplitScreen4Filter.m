//
//  CCGPUImageSplitScreen4Filter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2019/6/20.
//  Copyright © 2019年 Selfie. All rights reserved.
//

#import "CCGPUImageSplitScreen4Filter.h"
NSString * const kCCGPUImageSplitScreen4FilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform float time;
 
 void main() {
     vec2 uv = textureCoordinate.xy;
     if(uv.x <= 0.5){
         uv.x = uv.x * 2.0;
     }else{
         uv.x = (uv.x - 0.5) * 2.0;
     }
     
     if (uv.y<= 0.5) {
         uv.y = uv.y * 2.0;
     }else{
         uv.y = (uv.y - 0.5) * 2.0;
     }
     
     gl_FragColor = texture2D(inputImageTexture, uv);
 }

 
 );

@implementation CCGPUImageSplitScreen4Filter

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageSplitScreen4FilterShaderString];
    return self;
}
@end
