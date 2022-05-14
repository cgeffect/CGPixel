//
//  CCGPUImageMosaicFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2019/6/20.
//  Copyright © 2019年 Selfie. All rights reserved.
//

#import "CCGPUImageMosaicFilter.h"

NSString * const kCCGPUImageMosaicFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 const vec2 TexSize = vec2(400.0, 400.0);
 const vec2 mosaicSize = vec2(8.0, 8.0);

 
 void main()
{
    vec2 intXY = vec2(textureCoordinate.x*TexSize.x, textureCoordinate.y*TexSize.y);
    
    vec2 XYMosaic = vec2(floor(intXY.x/mosaicSize.x)*mosaicSize.x, floor(intXY.y/mosaicSize.y)*mosaicSize.y);
    
    vec2 UVMosaic = vec2(XYMosaic.x/TexSize.x, XYMosaic.y/TexSize.y);
    
    vec4 color = texture2D(inputImageTexture, UVMosaic);
    
    gl_FragColor = color;
}
 
 );


@implementation CCGPUImageMosaicFilter

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageMosaicFilterShaderString];
    return self;
}

@end
