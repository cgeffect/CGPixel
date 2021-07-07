//
//  CGPaintPipelineInput.h
//  CGPaint
//
//  Created by Jason on 2021/5/16.
//  Copyright © 2021 CGPaint. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CGPaintPipelineInput <NSObject>

- (void)glDraw:(int)inputTex width:(int)width height:(int)height;

@end

NS_ASSUME_NONNULL_END
