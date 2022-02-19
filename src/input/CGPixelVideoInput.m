//
//  CGPixelVideoInput.m
//  CGPixel
//
//  Created by Jason on 2021/5/31.
//

#import "CGPixelVideoInput.h"
#import "CGPixelPixelBufferInput.h"
#import "CGPixelRawDataInput.h"

# define ONE_FRAME_DURATION 0.03
# define LUMA_SLIDER_TAG 0
# define CHROMA_SLIDER_TAG 1

static void *AVPlayerItemStatusContext = &AVPlayerItemStatusContext;

@interface CGPixelVideoInput ()<AVPlayerItemOutputPullDelegate>
{
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVAsset *_asset;
    dispatch_queue_t _myVideoOutputQueue;
    UInt8 *_dstData;
}
@property(nonatomic, strong)AVPlayerItemVideoOutput *videoOutput;
@property(nonatomic, strong)CADisplayLink *displayLink;
@property(nonatomic, strong)CGPixelOutput *input;

@end

@implementation CGPixelVideoInput

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
        [[self displayLink] addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[self displayLink] setPaused:YES];
        
        //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
        NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
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
//        size_t w = CVPixelBufferGetWidth(pixelBuffer);
//        size_t h = CVPixelBufferGetHeight(pixelBuffer);
        
//        if (_dstData == nil) {
//            _dstData = malloc(w * h * 3 / 2);
//        }
//        [self translate420VPixelBuffer:pixelBuffer toDataNV12:_dstData];
//
//        if (pixelBuffer != NULL) {
//            if (_input == nil) {
//                _input = [[CGPaintRawDataInput alloc] initWithByte:_dstData byteSize:CGSizeMake(w, h) format:CGPixelDataFormatNV12];
//            } else {
//                runSyncOnSerialQueue(^{
//                    [(CGPaintRawDataInput *)_input uploadByte:_dstData byteSize:CGSizeMake(w, h) format:CGPixelDataFormatNV12];
//                });
//            }
//            [self _requestRender];
//        }
        if (pixelBuffer != NULL) {
            if (_input == nil) {
                _input = [[CGPixelPixelBufferInput alloc] initWithPixelBuffer:pixelBuffer format:CGPixelFormatNV12];
            } else {
                [(CGPixelPixelBufferInput *)_input updatePixelBuffer:pixelBuffer format:CGPixelFormatNV12];
            }
            [self _requestRender];
        }
        
        if (pixelBuffer) {
            CVPixelBufferRelease(pixelBuffer);
        }
    } else {
        
    }
}
- (void)_requestRender {
    runSyncOnSerialQueue(^{
        [[CGPixelContext sharedRenderContext] useAsCurrentContext];
        for (id<CGPixelInput> currentTarget in self->_targets){
            [currentTarget setInputFramebuffer:self->_input.outFrameBuffer];
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

- (void)translate420VPixelBuffer:(nonnull CVPixelBufferRef)pixelBuffer toDataNV12:(nonnull UInt8 *)data {
    size_t pixelBufferWidth = CVPixelBufferGetWidth(pixelBuffer);
    size_t pixelBufferHeight = CVPixelBufferGetHeight(pixelBuffer);

    size_t bytePerRowY = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
    size_t bytesPerRowUV = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);

    NSInteger y_line_width = pixelBufferWidth > bytePerRowY ? bytePerRowY : pixelBufferWidth;
    NSInteger uv_line_width = pixelBufferWidth > bytesPerRowUV ? bytesPerRowUV : pixelBufferWidth;

    CVPixelBufferLockBaseAddress(pixelBuffer, 0);

    UInt8 *yData = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    UInt8 *uvData = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);

    // y
    for (int i = 0; i < pixelBufferHeight; i++) {
        memcpy(data + pixelBufferWidth * i, yData + bytePerRowY * i, (size_t) y_line_width);
    }
    // uv
    NSInteger uv_offset_base = pixelBufferWidth * pixelBufferHeight;
    for (int j = 0; j < pixelBufferHeight / 2; j++) {
        // 按行拷贝
        memcpy(data + uv_offset_base + pixelBufferWidth * j, uvData + bytesPerRowUV * j, (size_t) uv_line_width);
    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

@end
