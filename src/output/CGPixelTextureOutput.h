//
//  CGPixelTextureOutput.h
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//  Copyright © 2021 CGPixel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGPixelInput.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPixelTextureOutput : NSObject<CGPixelInput>

@property(nonatomic, assign, readonly) GLuint texture;

@property(nonatomic, assign, readonly) CGSize textureSize;

@end

NS_ASSUME_NONNULL_END
