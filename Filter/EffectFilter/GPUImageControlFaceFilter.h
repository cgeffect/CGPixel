//
//  GPUImageControlFaceFilter.h
//  1-初探GPUImage
//
//  Created by 王腾飞 on 2020/4/16.
//  Copyright © 2020 CC老师. All rights reserved.
//

#import "GPUImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPUImageControlFaceFilter : GPUImageFilter
{
    GLint faceUniform;
}

@property(readwrite, nonatomic) CGFloat faceValue;

@end

NS_ASSUME_NONNULL_END
