//
//  CGPixelTextureInput.h
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//  Copyright © 2021 CGPixel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGPixelOutput.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPixelTextureInput : CGPixelOutput

- (instancetype)initWithTexture:(GLuint)newInputTexture size:(CGSize)newTextureSize;

@end

NS_ASSUME_NONNULL_END
