//
//  GPUImageControlFaceFilter.m
//  1-初探GPUImage
//
//  Created by 王腾飞 on 2020/4/16.
//  Copyright © 2020 CC老师. All rights reserved.
//

#import "GPUImageControlFaceFilter.h"


NSString *const kGPUImageFaceShaderString = SHADER_STRING
(
 varying lowp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform highp float stepValue;

 highp vec2 blowUp(highp vec2 textureCoordinate) {
    
    highp float t = stepValue;
    highp float xOffset = 0.5;
    highp float yOffset = 0.5;
    
    lowp vec2 uv = textureCoordinate;
    uv.x = uv.x - xOffset;
    uv.y = uv.y - yOffset;
    uv = uv * t;
    lowp vec2 rsCoordinate = uv + vec2(xOffset, yOffset);
    return rsCoordinate;
 }
 
 void main()
 {
   
    lowp vec2 rsCoordinate = blowUp(textureCoordinate);
    lowp vec4 result = texture2D(inputImageTexture, rsCoordinate);

    gl_FragColor = vec4(result.rgb, 1.0);
 }
);

@implementation GPUImageControlFaceFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageFaceShaderString]))
    {
        return nil;
    }
        
    faceUniform = [filterProgram uniformIndex:@"stepValue"];
    self.faceValue = 1.0;
    
    return self;
}

#pragma mark -
#pragma mark Accessors
//小于1是放大, 大于是缩小
- (void)setFaceValue:(CGFloat)faceValue {
    if (faceValue >= 1) {
        faceValue = 1;
    }
    _faceValue = faceValue;
    [self setFloat:faceValue forUniform:faceUniform program:filterProgram];
}
@end
