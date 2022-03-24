//
//  CCGPUImageBaseFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2019/6/18.
//  Copyright © 2019年 Selfie. All rights reserved.
//

#import "CCGPUImageBaseFilter.h"

@implementation CCGPUImageBaseFilter

- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString
            fragmentShaderFromString:(NSString *)fragmentShaderString {
    self = [super initWithVertexShaderFromString:vertexShaderString
                        fragmentShaderFromString:fragmentShaderString];
   
    self.timeUniform = [filterProgram uniformIndex:@"time"];
    self.time = 0.0f;
    
    return self;
}

- (void)setTime:(CGFloat)time {
    _time = time;
    
    [self setFloat:time forUniform:self.timeUniform program:filterProgram];
}

- (void)setTimeValue:(CGFloat)time {
    _time = time;
}
@end
