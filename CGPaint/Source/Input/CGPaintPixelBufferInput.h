//
//  CGPaintPixelBufferInput.h
//  CGPaint
//
//  Created by CGPaint on 2021/5/14.
//  Copyright © 2021 CGPaint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGPaintOutput.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CGPixelFormat) {
    CGPixelFormatBGRA,
    CGPixelFormatNV12
};

@interface CGPaintPixelBufferInput : CGPaintOutput

- (instancetype)initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer format:(CGPixelFormat)format;

- (void)updatePixelBuffer:(CVPixelBufferRef)pixelBuffer format:(CGPixelFormat)format;

@end

NS_ASSUME_NONNULL_END
