//
//  CGPixelTextureInput.h
//  CGPixel
//
//  Created by CGPaint on 2021/5/13.
//  Copyright © 2021 CGPaint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGPaintOutput.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPaintTextureInput : CGPaintOutput

- (instancetype)initWithTexture:(GLuint)newInputTexture size:(CGSize)newTextureSize;

@end

NS_ASSUME_NONNULL_END
