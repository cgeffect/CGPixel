//
//  CCGPUImageSymmetryFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2020/4/13.
//  Copyright © 2020 Selfie. All rights reserved.
//

#import "CCGPUImageHMirrorFilter.h"


NSString * const kCCGPUImageHMirrorFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform float time;

 void main() {
    
    vec2 st = textureCoordinate;
    vec3 color;

    if (st.x < 0.5) {
        st = vec2(st.x, st.y);
        vec3 thisrgb = texture2D(inputImageTexture, vec2(1.0 - st.x, st.y)).rgb;;
        color = thisrgb;
    }else {
        st = vec2(st.x, st.y);
        vec3 thisrgb = texture2D(inputImageTexture, vec2(st.x, st.y)).rgb;;
        color = thisrgb;
    }
    

    gl_FragColor = vec4(color, 1. );
}
);

@implementation CCGPUImageHMirrorFilter
- (id)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageHMirrorFilterShaderString];
    return self;
}
@end
