//
//  CGPixelFramebufferCache.h
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//

#import <Foundation/Foundation.h>
#import "CGPixelFramebuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPixelFramebufferCache : NSObject

+ (CGPixelFramebufferCache *)sharedFramebufferCache;

- (CGPixelFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize
                                    onlyTexture:(BOOL)onlyTexture;

- (CGPixelFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize
                                 textureOptions:(CGTextureOptions)textureOptions
                                    onlyTexture:(BOOL)onlyTexture;

- (void)recycleFramebufferToCache:(CGPixelFramebuffer *)framebuffer;

- (void)deleteAllUnassignedFramebuffers;

@end

NS_ASSUME_NONNULL_END
