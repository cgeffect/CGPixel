//
//  CCGPUImageHexagonMosaicFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2019/6/20.
//  Copyright © 2019年 Selfie. All rights reserved.
//

#import "CCGPUImageHexagonMosaicFilter.h"

NSString * const kCCGPUImageHexagonMosaicFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 const float mosaicSize = 0.03;

 
 void main (void)
{
    float length = mosaicSize;
    float TR = 0.866025;
    
    float x = textureCoordinate.x;
    float y = textureCoordinate.y;
    
    int wx = int(x / 1.5 / length);
    int wy = int(y / TR / length);
   
    vec2 v1 = vec2(0,0);
    vec2 v2 = vec2(0,0);
    vec2 vn = vec2(0,0);
    
    if (wx/2 * 2 == wx) {
        if (wy/2 * 2 == wy) {
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy + 1));
        } else {
            
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy + 1));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy));
        }
    }else {
        if (wy/2 * 2 == wy) {
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy + 1));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy));
        } else {
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy + 1));
        }
    }
    
    float s1 = sqrt(pow(v1.x - x, 2.0) + pow(v1.y - y, 2.0));
    float s2 = sqrt(pow(v2.x - x, 2.0) + pow(v2.y - y, 2.0));
    if (s1 < s2) {
        vn = v1;
    } else {
        vn = v2;
    }
    vec4 color = texture2D(inputImageTexture, vn);
    
    gl_FragColor = color;
    
}

 
 );


@implementation CCGPUImageHexagonMosaicFilter

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageHexagonMosaicFilterShaderString];
    return self;
}

@end
