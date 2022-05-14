//
//  CCGPUImageInOutFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2020/4/20.
//  Copyright © 2020 Selfie. All rights reserved.
//

#import "CCGPUImageInOutFilter.h"
//
//NSString *const kGPUImageInOutShaderString = SHADER_STRING
//(
// varying highp vec2 textureCoordinate;
// 
// uniform sampler2D inputImageTexture;
// uniform highp float stepValue;
// const int KernelSize = 9;
//
// highp vec4 blur(highp vec2 rsCoordinate, sampler2D inputImageTexture) {
//    highp vec4 sum = vec4(0.0);
//    highp float Kernel[9];
//    Kernel[6] = 1.0; Kernel[7] = 2.0; Kernel[8] = 1.0;
//    Kernel[3] = 2.0; Kernel[4] = 4.0; Kernel[5] = 2.0;
//    Kernel[0] = 1.0; Kernel[1] = 2.0; Kernel[2] = 1.0;
//    
//    highp float fStep = stepValue;
//    highp vec2 Offset[9];
//    Offset[0] = vec2(-fStep,-fStep); Offset[1] = vec2(0.0,-fStep); Offset[2] = vec2(fStep,-fStep);
//    Offset[3] = vec2(-fStep,0.0);    Offset[4] = vec2(0.0,0.0);    Offset[5] = vec2(fStep,0.0);
//    Offset[6] = vec2(-fStep, fStep); Offset[7] = vec2(0.0, fStep); Offset[8] = vec2(fStep, fStep);
//    
//    for (int i = 0; i < KernelSize; i++)
//    {
//        highp vec4 tmp = texture2D(inputImageTexture, rsCoordinate.xy + Offset[i]);
//        sum += tmp * Kernel[i];
//    }
//    return sum / 16.0;
//}
// 
// highp vec2 blowUp(highp vec2 textureCoordinate) {
//    highp float t = 0.5;
//    highp float xOffset = 0.5;
//    highp float yOffset = 0.5;
//    
//    lowp vec2 uv = textureCoordinate;
//    uv.x = uv.x - xOffset;
//    uv.y = uv.y - yOffset;
//    uv = uv * t;
//    highp vec2 rsCoordinate = uv + vec2(xOffset, yOffset);
//    return rsCoordinate;
// }
// 
// void main()
// {
//   
//    highp vec4 result = vec4(0.0);
//    if (textureCoordinate.y > 0.25 && textureCoordinate.y < 0.75) {
//        result = texture2D(inputImageTexture, textureCoordinate);
//    }else {
//        
//       highp vec2 rsCoordinate = blowUp(textureCoordinate);
//        
//       result = blur(rsCoordinate, inputImageTexture);
//        
//    }
//    gl_FragColor = vec4(result.rgb, 1.0);
// }
//);

@implementation CCGPUImageInOutFilter

- (id)init;
{
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"CCGPUImageInOutFilter" ofType:@"fsh"];
    NSString* source = [NSString stringWithContentsOfFile:fragFile encoding:NSUTF8StringEncoding error:nil];
    if (!(self = [super initWithFragmentShaderFromString:source]))
    {
        return nil;
    }
    
    blurUniform = [filterProgram uniformIndex:@"stepValue"];
    self.blurValue = 0.005;
    
    return self;
}
#pragma mark -
#pragma mark Accessors

- (void)setBlurValue:(CGFloat)blurValue
{
    _blurValue = blurValue;
    
    [self setFloat:blurValue forUniform:blurUniform program:filterProgram];
}

@end
