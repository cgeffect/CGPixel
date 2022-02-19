//
//  CGPixelFramebufferCache.m
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//

#import "CGPixelFramebufferCache.h"
#import "CGPixelOutput.h"
#import "CGPixelContext.h"

@interface CGPixelFramebufferCache ()
{
    id _memoryWarningObserver;
    NSMutableDictionary <NSString *, NSMutableArray <CGPixelFramebuffer *>*>*_framebufferCache;
//    dispatch_queue_t _framebufferCacheQueue;
}
@end

@implementation CGPixelFramebufferCache

+ (CGPixelFramebufferCache *)sharedFramebufferCache;
{
    static dispatch_once_t pred;
    static CGPixelFramebufferCache *sharedRenderContext = nil;
    
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
    
    __unsafe_unretained __typeof__ (self) weakSelf = self;
    _memoryWarningObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        __typeof__ (self) strongSelf = weakSelf;
        if (strongSelf) {
            NSLog(@"received memory warning");
            [strongSelf deleteAllUnassignedFramebuffers];
        }
    }];

    _framebufferCache = [[NSMutableDictionary alloc] init];
//    _framebufferCacheQueue = dispatch_queue_create("com.CGPaint.framebufferCacheQueue", CGPaintDefaultQueueAttribute());
    
    return self;
}

- (CGPixelFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize
                                 textureOptions:(CGTextureOptions)textureOptions
                                    onlyTexture:(BOOL)onlyTexture
{
    CGPixelFramebuffer *framebuffer = nil;
    
    NSString *lookupHash = [self hashForSize:framebufferSize textureOptions:textureOptions onlyTexture:onlyTexture];
    NSMutableArray *framebufferList = [self->_framebufferCache objectForKey:lookupHash];
    if (framebufferList == nil) {
        NSMutableArray *fbList = [NSMutableArray array];
        [self->_framebufferCache setValue:fbList forKey:lookupHash];
    } else {
        for (CGPixelFramebuffer *fbCache in framebufferList) {
            if (fbCache.isActivite == NO) {
                framebuffer = fbCache;
            }
        }
    }
    if (framebuffer == nil) {
        framebuffer = [[CGPixelFramebuffer alloc] initWithSize:framebufferSize textureOptions:textureOptions onlyTexture:onlyTexture];
        framebuffer.hashKey = lookupHash;
        NSLog(@"use framebuffer from create: key: %@, value: %@", lookupHash, framebuffer);
    }
    framebuffer.isActivite = YES;
    return framebuffer;
}

- (CGPixelFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize
                                    onlyTexture:(BOOL)onlyTexture
{
    CGPixelFramebuffer *framebuffer = [self fetchFramebufferForSize:framebufferSize textureOptions:[CGPixelFramebuffer defaultTextureOption] onlyTexture:onlyTexture];
    return framebuffer;
}

- (void)deleteAllUnassignedFramebuffers {
    [self->_framebufferCache removeAllObjects];
    CVOpenGLESTextureCacheFlush([[CGPixelContext sharedRenderContext] coreVideoTextureCache], 0);
}

- (NSString *)hashForSize:(CGSize)size textureOptions:(CGTextureOptions)textureOptions onlyTexture:(BOOL)onlyTexture {
    if (onlyTexture) {
        return [NSString stringWithFormat:@"%.1fx%.1f-%d:%d:%d:%d:%d:%d:%d-NOFBO", size.width, size.height, textureOptions.minFilter, textureOptions.magFilter, textureOptions.wrapS, textureOptions.wrapT, textureOptions.internalFormat, textureOptions.format, textureOptions.type];
    } else {
        return [NSString stringWithFormat:@"%.1fx%.1f-%d:%d:%d:%d:%d:%d:%d", size.width, size.height, textureOptions.minFilter, textureOptions.magFilter, textureOptions.wrapS, textureOptions.wrapT, textureOptions.internalFormat, textureOptions.format, textureOptions.type];
    }
}

- (void)recycleFramebufferToCache:(CGPixelFramebuffer *)framebuffer {
    NSMutableArray *framebufferList = [_framebufferCache objectForKey:framebuffer.hashKey];
    [framebufferList addObject:framebuffer];
    framebuffer.isActivite = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self deleteAllUnassignedFramebuffers];
}

@end
