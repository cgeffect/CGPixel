//
//  CGRImageCoder.h
//  CGPaint
//
//  Created by Jason on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGImageCoder : NSObject
UInt8 * CGRDecodeImage32LittleARGB1(CGImageRef imageRef, int width, int height);

//大端模式RGBA
UInt8 * CGRDecodeImage32BigRGBA1(CGImageRef imageRef, int width, int height);
@end

NS_ASSUME_NONNULL_END
