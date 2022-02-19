//
//  CGPixelVideoInput.h
//  CGPixel
//
//  Created by Jason on 2021/5/31.
//

#import "CGPixelOutput.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CGPixelVideoInput;
@protocol CGPaintVideoInputDelegate <NSObject>

- (void)output:(CGPixelVideoInput *)output pixelbuffer:(CVPixelBufferRef)pixelbuffer;

@end

@interface CGPixelVideoInput : CGPixelOutput
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
