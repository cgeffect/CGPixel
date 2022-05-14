//
//  CGPixelPixelbufferOutput.h
//  CGPixel
//
//  Created by CGPixel on 2021/5/14.
//

#import <Foundation/Foundation.h>
#import "CGPixelFramebuffer.h"
#import "CGPixelInput.h"
#import "CGPixelContext.h"

@import CoreVideo;
NS_ASSUME_NONNULL_BEGIN

@interface CGPixelPixelbufferOutput : NSObject<CGPixelInput>

@property(nonatomic, copy)void(^outputCallback)(CVPixelBufferRef pixelbuffer);

/**
 是否输出
  
 @property enableOutput 启用输出, 默认为NO
 @discussion 可动态配置, YES输出, NO禁用
 */
@property(nonatomic, assign)BOOL enableOutput;

@end

NS_ASSUME_NONNULL_END
