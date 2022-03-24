//
//  CCGPUImageSplitScreen6Filter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2019/6/20.
//  Copyright © 2019年 Selfie. All rights reserved.
//

#import "CCGPUImageSplitScreen6Filter.h"
NSString * const kCCGPUImageSplitScreen6FilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform float time;
 
 void main() {
     vec2 uv = textureCoordinate.xy;
     
     if(uv.x <= 1.0 / 3.0){
         uv.x = uv.x + 1.0/3.0;
     }else if(uv.x >= 2.0/3.0){
         uv.x = uv.x - 1.0/3.0;
     }
     
     if(uv.y <= 0.5){
         uv.y = uv.y + 0.25;
     }else {
         uv.y = uv.y - 0.25;
     }
     
     
     gl_FragColor = texture2D(inputImageTexture, uv);
 }
 
 
 );


@implementation CCGPUImageSplitScreen6Filter
- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageSplitScreen6FilterShaderString];
    return self;
}
@end
