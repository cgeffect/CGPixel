//
//  CCGPUImageBaseTwoFilter.h
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2020/4/13.
//  Copyright © 2020 Selfie. All rights reserved.
//

#import "GPUImageTwoInputFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCGPUImageBaseTwoFilter : GPUImageTwoInputFilter
@property (nonatomic, assign) GLint timeUniform;
@property (nonatomic, assign) CGFloat time;

@property (nonatomic, assign) CGFloat beginTime;  // 滤镜开始应用的时间
- (void)setTimeValue:(CGFloat)time;

@property (nonatomic, strong)UIImage *image;
- (GLubyte *)getImageDataWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
