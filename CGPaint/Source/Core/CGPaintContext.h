//
//  CGPaintContext.h
//  CGPaint
//
//  Created by Jason on 21/3/3.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "CGPaintProgram.h"

@class CGPaintContext;
//往调度队列中提交有一个block,并且与它的调度组关联起来
dispatch_queue_attr_t CGPaintDefaultQueueAttribute(void);
//在主线程执行,并且不死锁
void runOnMainQueueWithoutDeadlocking(void (^block)(void));
//在默认的CGRenderContext中执行
void runSyncOnSerialQueue(void (^block)(void));
void runAsyncOnSerialQueue(void (^block)(void));
//在指定的CGRenderContext中执行
void runSyncOnContextSerialQueue(CGPaintContext *context, void (^block)(void));
void runAsyncOnContextSerialQueue(CGPaintContext *context, void (^block)(void));
//
void reportAvailableMemoryForGPUImage(NSString *tag);

#define GPUImageRotationSwapsWidthAndHeight(rotation) ((rotation) == kGPUImageRotateLeft || (rotation) == kGPUImageRotateRight || (rotation) == kGPUImageRotateRightFlipVertical || (rotation) == kGPUImageRotateRightFlipHorizontal)

typedef NS_ENUM(NSUInteger, CGImageRotationMode) {
    CGImageNoRotation,
    CGImageRotateLeft,
    CGImageRotateRight,
    CGImageFlipVertical,
    CGImageFlipHorizonal,
    CGImageRotateRightFlipVertical,
    CGImageRotateRightFlipHorizontal,
    CGImageRotate180
};

//给OpenGL ES基本环境
@interface CGPaintContext : NSObject

@property(readonly, nonatomic) dispatch_queue_t contextQueue;
@property(readonly, strong, nonatomic) EAGLContext *context;
@property(readonly) CVOpenGLESTextureCacheRef coreVideoTextureCache;

+ (void *)contextKey;

+ (CGPaintContext *)sharedRenderContext;

+ (BOOL)supportsFastTextureUpload;

- (dispatch_queue_t)sharedContextQueue;

- (CVOpenGLESTextureCacheRef)coreVideoTextureCache;

- (void)useSharegroup:(EAGLSharegroup *)sharegroup;

- (void)useAsCurrentContext;

+ (CGSize)sizeThatFitsWithinATextureForSize:(CGSize)inputSize;

@end
