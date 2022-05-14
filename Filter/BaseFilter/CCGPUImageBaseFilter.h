//
//  CCGPUImageBaseFilter.h
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2019/6/18.
//  Copyright © 2019年 Selfie. All rights reserved.
//

#import "GPUImageFilter.h"

@interface CCGPUImageBaseFilter : GPUImageFilter

@property (nonatomic, assign) GLint timeUniform;
@property (nonatomic, assign) CGFloat time;

@property (nonatomic, assign) CGFloat beginTime;  // 滤镜开始应用的时间
- (void)setTimeValue:(CGFloat)time;

@end
