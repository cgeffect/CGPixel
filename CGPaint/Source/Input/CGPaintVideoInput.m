//
//  CGPaintVideoInput.m
//  CGPaint
//
//  Created by Jason on 2021/5/31.
//

#import "CGPaintVideoInput.h"
#import "CGPaintPixelBufferInput.h"

# define ONE_FRAME_DURATION 0.03
# define LUMA_SLIDER_TAG 0
# define CHROMA_SLIDER_TAG 1

static void *AVPlayerItemStatusContext = &AVPlayerItemStatusContext;

@interface CGPaintVideoInput ()<AVPlayerItemOutputPullDelegate>
{
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVAsset *_asset;
    dispatch_queue_t _myVideoOutputQueue;
}
@property(nonatomic, strong)AVPlayerItemVideoOutput *videoOutput;
@property(nonatomic, strong)CADisplayLink *displayLink;
@property(nonatomic, strong)CGPaintPixelBufferInput *pixInput;
@end

@implementation CGPaintVideoInput

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
        [[self displayLink] addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[self displayLink] setPaused:YES];
        
        NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
        self.videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixBuffAttributes];
        _myVideoOutputQueue = dispatch_queue_create("myVideoOutputQueue", DISPATCH_QUEUE_SERIAL);
        [[self videoOutput] setDelegate:self queue:_myVideoOutputQueue];
        [self setupPlaybackForURL:url];
    }
    return self;
}

#pragma mark - Playback setup
- (void)setupPlaybackForURL:(NSURL *)URL {
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:URL];
    _playerItem = item;
    AVAsset *asset = [item asset];
    _asset = asset;
    [asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        if ([asset statusOfValueForKey:@"tracks" error:nil] == AVKeyValueStatusLoaded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [item addOutput:self.videoOutput];
                [self->_player replaceCurrentItemWithPlayerItem:item];
                [self.videoOutput requestNotificationOfMediaDataChangeWithAdvanceInterval:ONE_FRAME_DURATION];
            });
        }
    }];
}

#pragma mark - CADisplayLink Callback
- (void)displayLinkCallback:(CADisplayLink *)sender {
    CMTime outputItemTime = kCMTimeInvalid;
    CFTimeInterval nextVSync = ([sender timestamp] + [sender duration]);
    outputItemTime = [[self videoOutput] itemTimeForHostTime:nextVSync];
    if ([[self videoOutput] hasNewPixelBufferForItemTime:outputItemTime]) {
        CVPixelBufferRef pixelBuffer = NULL;
        pixelBuffer = [[self videoOutput] copyPixelBufferForItemTime:outputItemTime itemTimeForDisplay:NULL];
        [self.delegate output:self pixelbuffer:pixelBuffer];
        if (pixelBuffer != NULL) {
            if (_pixInput == nil) {
                _pixInput = [[CGPaintPixelBufferInput alloc] initWithPixelBuffer:pixelBuffer format:CGPixelFormatBGRA];
            } else {
                [_pixInput updatePixelBuffer:pixelBuffer format:CGPixelFormatBGRA];
            }
            [self _requestRender];
            CVPixelBufferRelease(pixelBuffer);
        }
    } else {
        
    }
}
- (void)_requestRender {
    runSyncOnSerialQueue(^{
        [[CGPaintContext sharedRenderContext] useAsCurrentContext];
        for (id<CGPaintInput> currentTarget in self->_targets){
            [currentTarget setInputFramebuffer:self->_pixInput.outFrameBuffer];
            CMSampleTimingInfo info = {0};
            [currentTarget newFrameReadyAtTime:kCMTimeZero timimgInfo:info];
        }
    });
}

#pragma mark - AVPlayerItemOutputPullDelegate
//注册完 requestNotificationOfMediaDataChangeWithAdvanceInterval 通知之后, 会立马调用这里
- (void)outputMediaDataWillChange:(AVPlayerItemOutput *)sender
{
    // Restart display link.
    [[self displayLink] setPaused:NO];
}

- (void)requestRender {
    [self->_player play];
}

- (void)pauseRender {
    [self.displayLink setPaused:YES];
    [self.player pause];
}

- (void)resumeRender {
    [self.displayLink setPaused:NO];
    [self.player play];
}

- (void)stopRender {
    [self.displayLink setPaused:YES];
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self.player pause];
}

- (AVPlayer *)player {
    return _player;
}
- (AVAsset *)asset {
    return _asset;
}
- (AVPlayerItem *)playerItem {
    return _playerItem;
}
- (void)dealloc
{
    _player = nil;
    _playerItem = nil;
    _asset = nil;
    _myVideoOutputQueue = nil;
    NSLog(@"%@ dealloc", self);
}
@end
