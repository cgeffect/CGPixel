//
//  CGPaintFramebufferCache.h
//  CGPaint
//
//  Created by CGPaint on 2021/5/13.
//

#import <Foundation/Foundation.h>
#import "CGPaintFramebuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPaintFramebufferCache : NSObject

+ (CGPaintFramebufferCache *)sharedFramebufferCache;

- (CGPaintFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize
                                    onlyTexture:(BOOL)onlyTexture;

- (CGPaintFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize
                                 textureOptions:(CGTextureOptions)textureOptions
                                    onlyTexture:(BOOL)onlyTexture;

- (void)recycleFramebufferToCache:(CGPaintFramebuffer *)framebuffer;

- (void)deleteAllUnassignedFramebuffers;

@end

NS_ASSUME_NONNULL_END
