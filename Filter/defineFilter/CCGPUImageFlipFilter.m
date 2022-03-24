//
//  CCGPUImageFlipFilter.m
//  CCBeautifulCamera
//
//  Created by admin on 2020/5/23.
//  Copyright © 2020 Selfie. All rights reserved.
//

#import "CCGPUImageFlipFilter.h"

NSString * const kCCGPUImageFilpFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 void main (void) {
     
    vec4 color = texture2D(inputImageTexture, vec2(1.0 - textureCoordinate.x, textureCoordinate.y));
     
     gl_FragColor = color;
 }
 
 );


@implementation CCGPUImageFlipFilter

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageFilpFilterShaderString];
    return self;
}

@end
