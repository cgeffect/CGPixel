//
//  CGPixelRenderPipeline.h
//  CGPixel
//
//  Created by Jason on 21/3/1.
//

#import <Foundation/Foundation.h>
#import "CGPixelFramebuffer.h"
#import "CGPixelUtils.h"

@class CAEAGLLayer;

//绘制到屏幕
@interface CGPixelRenderPipeline : NSObject

- (void)glDraw:(int)inputTex width:(int)width height:(int)height;

- (BOOL)glPrepareDrawToGLLayer:(CAEAGLLayer *)glLayer;

@end
