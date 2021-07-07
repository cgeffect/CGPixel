//
//  CGPaintFinally.h
//  CGPaint
//
//  Created by Jason on 2021/5/22.
//

#import <Foundation/Foundation.h>
#import "CGPaintFramebuffer.h"
#import "CGPaintInput.h"
#import "CGPaintContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPaintTargetOutput : NSObject<CGPaintInput>
{
@protected
    CGPaintFramebuffer *_finallyFramebuffer;
}

/**
 是否输出
  
 @property enableOutput 启用输出, 默认为NO
 @discussion 可动态配置, YES输出, NO禁用
 */
@property(nonatomic, assign)BOOL enableOutput;

/**
 输出到目标
  
 @method captureFramebufferToOutput
 @discussion 子类各自实现自己的渲染业务逻辑
 */
- (void)captureFramebufferToOutput;

@end

NS_ASSUME_NONNULL_END
