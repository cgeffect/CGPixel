//
//  CGPaintVideoInput.h
//  CGPaint
//
//  Created by Jason on 2021/5/31.
//

#import "CGPaintOutput.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CGPaintVideoInput;
@protocol CGPaintVideoInputDelegate <NSObject>

- (void)output:(CGPaintVideoInput *)output pixelbuffer:(CVPixelBufferRef)pixelbuffer;

@end

@interface CGPaintVideoInput : CGPaintOutput
@property (readonly, strong) AVAsset *asset;
@property (readonly, strong) AVPlayerItem *playerItem;
@property (readonly, strong) AVPlayer *player;

@property(nonatomic, weak)id<CGPaintVideoInputDelegate>delegate;

- (instancetype)initWithURL:(NSURL *)url;

- (void)requestRender;
- (void)pauseRender;
- (void)resumeRender;
- (void)stopRender;

@end

NS_ASSUME_NONNULL_END
