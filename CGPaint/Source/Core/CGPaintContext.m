//
//  CGPaintContext.m
//  CGPaint
//
//  Created by Jason on 21/3/3.
//
#import "CGPaintContext.h"
#import <mach/mach.h>
#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark 队列
dispatch_queue_attr_t CGPaintDefaultQueueAttribute(void)
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)
    {
        return dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, 0);
    }
    return nil;
}

void runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

void runSyncOnSerialQueue(void (^block)(void))
{
    dispatch_queue_t videoProcessingQueue = [[CGPaintContext sharedRenderContext] sharedContextQueue];

    if (dispatch_get_specific([CGPaintContext contextKey]))
    {
        block();
    } else {
        dispatch_sync(videoProcessingQueue, block);
    }
}

void runAsyncOnSerialQueue(void (^block)(void))
{
    dispatch_queue_t videoProcessingQueue = [[CGPaintContext sharedRenderContext]sharedContextQueue];
    
    if (dispatch_get_specific([CGPaintContext contextKey]))
    {
        block();
    }else
    {
        dispatch_async(videoProcessingQueue, block);
    }
}

void runSyncOnContextSerialQueue(CGPaintContext *context, void (^block)(void))
{
    dispatch_queue_t videoProcessingQueue = [context contextQueue];
    if (dispatch_get_specific([CGPaintContext contextKey]))
    {
        block();
    }else
    {
        dispatch_sync(videoProcessingQueue, block);
    }
}

void runAsyncOnContextSerialQueue(CGPaintContext *context, void (^block)(void))
{
    dispatch_queue_t videoProcessingQueue = [context contextQueue];
 
    if (dispatch_get_specific([CGPaintContext contextKey]))
    {
        block();
    }else
    {
        dispatch_async(videoProcessingQueue, block);
    }
}

void reportAvailableMemoryForGPUImage(NSString *tag)
{
    if (!tag)
        tag = @"Default";
    
    struct task_basic_info info;
    
    mach_msg_type_number_t size = sizeof(info);
    
    kern_return_t kerr = task_info(mach_task_self(),
                                   
                                   TASK_BASIC_INFO,
                                   
                                   (task_info_t)&info,
                                   
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@"%@ - Memory used: %u", tag, (unsigned int)info.resident_size); //in bytes
    } else {
        NSLog(@"%@ - Error: %s", tag, mach_error_string(kerr));
    }
}

@interface CGPaintContext()
{
    EAGLSharegroup *_sharegroup;
}

@end

@implementation CGPaintContext

@synthesize context = _context;
@synthesize contextQueue = _contextQueue;
@synthesize coreVideoTextureCache = _coreVideoTextureCache;

static void *openGLESContextQueueKey;

+ (CGPaintContext *)sharedRenderContext;
{
    static dispatch_once_t pred;
    static CGPaintContext *sharedRenderContext = nil;
    
    dispatch_once(&pred, ^{
        sharedRenderContext = [[[self class] alloc] init];
    });
    return sharedRenderContext;
}

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    openGLESContextQueueKey = &openGLESContextQueueKey;
    _contextQueue = dispatch_queue_create("com.CGRender.openGLESContextQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_set_specific(_contextQueue, openGLESContextQueueKey, (__bridge void *)self, NULL);
    
    _context = [self createContext];
    return self;
}

+ (void *)contextKey {
    return openGLESContextQueueKey;
}

- (dispatch_queue_t)sharedContextQueue
{
    return [[CGPaintContext sharedRenderContext] contextQueue];
}

- (void)useAsCurrentContext;
{
    EAGLContext *imageProcessingContext = [self context];
    if ([EAGLContext currentContext] != imageProcessingContext)
    {
        [EAGLContext setCurrentContext:imageProcessingContext];
    }
}

- (void)useSharegroup:(EAGLSharegroup *)sharegroup;
{
    _sharegroup = sharegroup;
}

- (EAGLContext *)createContext;
{
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (context) {
        NSLog(@"eagl context set success");
    }
    return context;
}

#pragma mark -
#pragma mark Manage fast texture upload
+ (BOOL)supportsFastTextureUpload;
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return YES;
#endif
}

- (EAGLContext *)context;
{
    if (_context == nil)
    {
        _context = [self createContext];
        [EAGLContext setCurrentContext:_context];
        
        // Set up a few global settings for the image processing pipeline
        glDisable(GL_DEPTH_TEST);
    }
    
    return _context;
}

- (CVOpenGLESTextureCacheRef)coreVideoTextureCache;
{
    if (_coreVideoTextureCache == NULL)
    {
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, [self context], NULL, &_coreVideoTextureCache);        
        if (err)
        {
            NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreate %d", err);
        }
        
    }
    
    return _coreVideoTextureCache;
}

#pragma mark -
#pragma mark Device

+ (CGSize)sizeThatFitsWithinATextureForSize:(CGSize)inputSize
{
    GLint maxTextureSize = [self maximumTextureSizeForThisDevice];
    if ( (inputSize.width < maxTextureSize) && (inputSize.height < maxTextureSize) )
    {
        return inputSize;
    }
    
    CGSize adjustedSize;
    if (inputSize.width > inputSize.height)
    {
        adjustedSize.width = (CGFloat)maxTextureSize;
        adjustedSize.height = ((CGFloat)maxTextureSize / inputSize.width) * inputSize.height;
    }
    else
    {
        adjustedSize.height = (CGFloat)maxTextureSize;
        adjustedSize.width = ((CGFloat)maxTextureSize / inputSize.height) * inputSize.width;
    }

    return adjustedSize;
}

+ (GLint)maximumTextureSizeForThisDevice;
{
    static dispatch_once_t pred;
    static GLint maxTextureSize = 0;
    
    dispatch_once(&pred, ^{
        [[CGPaintContext sharedRenderContext] useAsCurrentContext];
        glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize);
    });

    return maxTextureSize;
}

+ (GLint)maximumTextureUnitsForThisDevice;
{
    static dispatch_once_t pred;
    static GLint maxTextureUnits = 0;

    dispatch_once(&pred, ^{
        [[CGPaintContext sharedRenderContext] useAsCurrentContext];
        glGetIntegerv(GL_MAX_TEXTURE_IMAGE_UNITS, &maxTextureUnits);
    });
    
    return maxTextureUnits;
}

-(void) dealloc {
    if (_coreVideoTextureCache) {
        CFRelease(_coreVideoTextureCache);
        NSLog(@"Realese _coreVideoTextureCache...");
    }
}
@end
