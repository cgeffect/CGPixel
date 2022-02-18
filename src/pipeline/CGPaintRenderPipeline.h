//
//  CGPaintRenderPipeline.h
//  CGPaint
//
//  Created by Jason on 21/3/1.
//

#import <Foundation/Foundation.h>
#import "CGPaintFramebuffer.h"
#import "CGPaintUtils.h"

@class CAEAGLLayer;

//绘制到屏幕
@interface CGPaintRenderPipeline : NSObject

- (void)glDraw:(int)inputTex width:(int)width height:(int)height;

- (BOOL)glPrepareDrawToGLLayer:(CAEAGLLayer *)glLayer;

@end
