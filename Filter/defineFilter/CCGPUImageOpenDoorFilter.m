//
//  CCGPUImageOpenDoorFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2020/4/13.
//  Copyright © 2020 Selfie. All rights reserved.
//

#import "CCGPUImageOpenDoorFilter.h"

NSString * const kCCGPUImageOpenDoorFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform float time;

 void main() {
    
    vec2 st = textureCoordinate;

    if (time > 3.0) {
        gl_FragColor = vec4(1.0, 0.0, 0.0 , 1.);
    }else {
        if(st.y < 0.5 - time || st.y > 0.5 + time) {
               st = vec2(st.x, st.y);
               gl_FragColor = vec4(vec3(0.0, 0.0, 0.0) , 1.);
           } else {
               st = vec2(st.x, st.y);
               vec3 color = texture2D(inputImageTexture, st).rgb;;
               gl_FragColor = vec4(color , 1.);
           }
    }
   
}
);

@implementation CCGPUImageOpenDoorFilter
- (id)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageOpenDoorFilterShaderString];
    _duration = 3;
    return self;
}

- (void)setTime:(CGFloat)time {
    [self setTimeValue:time];
    NSLog(@"time = %f", time);

    if (time <= _duration) {
      [self setFloat:0.5 * (time / _duration) forUniform:self.timeUniform program:filterProgram];

    } else {

    }
    
}
@end
