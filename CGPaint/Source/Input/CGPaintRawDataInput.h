//
//  CGPaintRawDataInput.h
//  CGPaint
//
//  Created by CGPaint on 2021/5/13.
//

#import <UIKit/UIKit.h>
#import "CGPaintOutput.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CGDataFormat) {
    CGDataFormatRGBA,
    CGDataFormatBGRA,
    CGDataFormatNV21,
    CGDataFormatNV12,
    CGDataFormatI420,
};

@interface CGPaintRawDataInput : CGPaintOutput

- (instancetype)initWithByte:(UInt8 *)byte byteSize:(CGSize)byteSize format:(CGDataFormat)format;

- (void)uploadByte:(UInt8 *)byte byteSize:(CGSize)byteSize format:(CGDataFormat)format;

@end

NS_ASSUME_NONNULL_END
