//
//  CGPixelImageOutput.h
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//

#import <Foundation/Foundation.h>
#import "CGPixelTargetOutput.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPixelImageOutput : CGPixelTargetOutput

@property(nonatomic, copy)void(^outputCallback)(CGImageRef imageRef);

@end

NS_ASSUME_NONNULL_END
