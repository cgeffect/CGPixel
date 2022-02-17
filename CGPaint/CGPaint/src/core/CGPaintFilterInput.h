//
//  CGPaintFilterInput.h
//  CGPaint
//
//  Created by Jason on 2021/6/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CGPaintFilterInput <NSObject>
@optional
#pragma mark -
#pragma mark 子类实现, 处理自己的数据
//下面的函数按顺序执行
/**
 * setp1
 * program链接完成,通过此接口获取uniform索引的操作
 */
- (void)glProgramLinked;
/**
 * setp2
 * 通过此接口获取纹理, 纹理size, framebuffer
 */
- (void)glReceivedInput:(CGPaintFramebuffer *)framebuffer;
/**
 * setp3
 * program use完成, 可以进行参数传递了
 */
- (void)glProgramUsed;
/**
 * setp4
 * 参数准备完毕, 准备渲染
 */
- (void)glPrepareRender;
/**
 * setp5
 * 渲染完成
 */
- (void)glRenderFinished;

@end

NS_ASSUME_NONNULL_END
