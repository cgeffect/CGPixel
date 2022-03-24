//
//  CCGPUImageInOutFilter.h
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2020/4/20.
//  Copyright © 2020 Selfie. All rights reserved.
//

#import "CCGPUImageBaseFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCGPUImageInOutFilter : CCGPUImageBaseFilter
{
    GLint blurUniform;
}

@property(readwrite, nonatomic) CGFloat blurValue;

@end

NS_ASSUME_NONNULL_END
