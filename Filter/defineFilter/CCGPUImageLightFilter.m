//
//  CCGPUImageLightFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2019/6/25.
//  Copyright © 2019年 Selfie. All rights reserved.
//

#import "CCGPUImageLightFilter.h"

NSString * const kCCGPUImageLightFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform float time;
 const vec2 TexSize = vec2(400.0, 400.0);
 const vec2 mosaicSize = vec2(16.0, 16.0);
 
 void main (void) {
    
     vec2 intXY = vec2(TextureCoordsVarying.x*TexSize.x, TextureCoordsVarying.y*TexSize.y);
     
     vec2 XYMosaic = vec2(floor(intXY.x/mosaicSize.x)*mosaicSize.x,floor(intXY.y/mosaicSize.y)*mosaicSize.y) + 0.5*mosaicSize;
     
     vec2 delXY = XYMosaic - intXY;
     float delL = length(delXY);
     vec2 UVMosaic = vec2(XYMosaic.x/TexSize.x,XYMosaic.y/TexSize.y);
     
     vec4 _finalColor;
     if(delL< 0.5*mosaicSize.x)
        _finalColor = texture2D(Texture,UVMosaic);
     else
        _finalColor = texture2D(Texture,TextureCoordsVarying);
     
     gl_FragColor = _finalColor;
 }
 
 );
@implementation CCGPUImageLightFilter
- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageLightFilterShaderString];
    return self;
}
@end
