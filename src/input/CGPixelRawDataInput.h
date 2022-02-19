//
//  CGPixelRawDataInput.h
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//

#import <UIKit/UIKit.h>
#import "CGPixelOutput.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CGPixelDataFormat) {
    CGPixelDataFormatRGBA,
    CGPixelDataFormatBGRA,
    CGPixelDataFormatNV21,
    CGPixelDataFormatNV12,
    CGPixelDataFormatI420,
};

@interface CGPixelRawDataInput : CGPixelOutput

- (instancetype)initWithByte:(UInt8 *)byte byteSize:(CGSize)byteSize format:(CGPixelDataFormat)format;

- (void)uploadByte:(UInt8 *)byte byteSize:(CGSize)byteSize format:(CGPixelDataFormat)format;

@end

NS_ASSUME_NONNULL_END
