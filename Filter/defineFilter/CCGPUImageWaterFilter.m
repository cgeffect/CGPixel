//
//  CCGPUImageWaterFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2020/4/13.
//  Copyright © 2020 Selfie. All rights reserved.
//

#import "CCGPUImageWaterFilter.h"

NSString * const kCCGPUImageWaterFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform float time;

 void main() {
    
    float u_speed = 3.0;
    float u_strength = 5.0;
    float u_frequency = 10.0;
    
    // bring both speed and strength into the kinds of ranges we need for this effect
    float speed = time * u_speed * 0.05;
    float strength = u_strength / 100.0;

    // take a copy of the current texture coordinate so we can modify it
    vec2 coord = textureCoordinate;

    // offset the coordinate by a small amount in each direction, based on wave frequency and wave strength
    coord.x += sin((coord.x + speed) * u_frequency) * strength;
    coord.y += cos((coord.y + speed) * u_frequency) * strength;

    // use the color at the offset location for our new pixel color
    gl_FragColor = texture2D(inputImageTexture, coord);
}
);

@implementation CCGPUImageWaterFilter
- (id)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageWaterFilterShaderString];
    return self;
}
@end
