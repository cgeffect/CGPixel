//
//  CGPaintRawDataOutput.h
//  CGPaint
//
//  Created by CGPaint on 2021/5/13.
//

#import <Foundation/Foundation.h>
#import "CGPaintTargetOutput.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPaintRawDataOutput : CGPaintTargetOutput
//仅支持RGBA格式
@property(nonatomic, copy)void(^outputCallback)(NSData *data);

@end

NS_ASSUME_NONNULL_END
