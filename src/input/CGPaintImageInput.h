//
//  CGPixelImageInput.h
//  CGPixel
//
//  Created by CGPaint on 2021/5/13.
//  Copyright © 2021 CGPaint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGPixelOutput.h"
#import "CGPaintFramebuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPaintImageInput : CGPixelOutput

- (instancetype)initWithImage:(UIImage *)newImageSource;

@end

NS_ASSUME_NONNULL_END
