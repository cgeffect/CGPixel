//
//  CGPixelRawDataOutput.h
//  CGPixel
//
//  Created by CGPixel on 2021/5/13.
//

#import <Foundation/Foundation.h>
#import "CGPixelTargetOutput.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPixelRawDataOutput : CGPixelTargetOutput
//仅支持RGBA格式
@property(nonatomic, copy)void(^outputCallback)(NSData *data);

@end

NS_ASSUME_NONNULL_END
