//
//  CGPixelInput.h
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//  Copyright © 2021 CGPixel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "CGPixelFramebuffer.h"
#import "CGPixelUtils.h"

NS_ASSUME_NONNULL_BEGIN
//处理事件的发起者都是输入源
@protocol CGPixelInput <NSObject>
@required
//渲染操作, 这是上一级节点(实际上是一个Output节点)处理完毕之后会调用的方法，在这个方法的实现中可完成渲染操作。
- (void)newFrameReadyAtTime:(CMTime)frameTime timimgInfo:(CMSampleTimingInfo)timimgInfo;

//设置输入纹理对象
- (void)setInputFramebuffer:(CGPixelFramebuffer *)framebuffer;

@end

NS_ASSUME_NONNULL_END
