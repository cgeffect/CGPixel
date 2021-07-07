//
//  CGPaintRenderPipeline.h
//  CGPaint
//
//  Created by Jason on 21/3/1.
//

#import <Foundation/Foundation.h>
#import "CGPaintFramebuffer.h"
#import "CGPaintUtils.h"
#import "CGPaintPipelineInput.h"

@class CAEAGLLayer;

//绘制到屏幕
@interface CGPaintRenderPipeline : NSObject<CGPaintPipelineInput>

- (BOOL)glPrepareDrawToGLLayer:(CAEAGLLayer *)glLayer;

@end
