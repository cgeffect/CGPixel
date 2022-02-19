//
//  CGPixelImageOutput.h
//  CGPixel
//
//  Created by CGPaint on 2021/5/13.
//

#import <Foundation/Foundation.h>
#import "CGPaintTargetOutput.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPaintImageOutput : CGPaintTargetOutput

@property(nonatomic, copy)void(^outputCallback)(CGImageRef imageRef);

@end

NS_ASSUME_NONNULL_END
