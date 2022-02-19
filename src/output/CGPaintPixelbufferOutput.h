//
//  CGPixelPixelbufferOutput.h
//  CGPixel
//
//  Created by CGPixel on 2021/5/14.
//

#import <Foundation/Foundation.h>
#import "CGPaintTargetOutput.h"
@import CoreVideo;
NS_ASSUME_NONNULL_BEGIN

@interface CGPaintPixelbufferOutput : CGPaintTargetOutput

@property(nonatomic, copy)void(^outputCallback)(CVPixelBufferRef pixelbuffer);

@end

NS_ASSUME_NONNULL_END
