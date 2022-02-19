//
//  CGPixelViewOutput.m
//  CGPixel
//
//  Created by Jason on 21/3/3.
//

#import "CGPixelViewOutput.h"
#import "CGPixelRenderPipeline.h"
#import "CGPixelOutput.h"

@implementation CGPixelViewOutput
{
    CGPixelFramebuffer *_inputFramebuffer;
    CGPixelRenderPipeline *_renderPipline;
    float bgColor[4];
    GLenum error;

}

+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
        eaglLayer.opaque = NO;// 支持透明度
        //这里设置layer使用像素值, 如果不设置则默认使用点位值, 设置像素值后, 对应的viewPort计算也是用像素值
        eaglLayer.contentsScale = [UIScreen mainScreen].scale;
        eaglLayer.drawableProperties = @{
                kEAGLDrawablePropertyRetainedBacking: @NO,
                kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8
        };

        runSyncOnSerialQueue(^{
            [[CGPixelContext sharedRenderContext] useAsCurrentContext];
            self->_renderPipline = [[CGPixelRenderPipeline alloc] init];
            if ([self->_renderPipline glPrepareDrawToGLLayer:(CAEAGLLayer *)self.layer]) {
                NSLog(@"glPrepareRender success...");
            } else {
                NSLog(@"glPrepareRender failed...");
            }
        });
    }
    return self;
}

- (void)setInputFramebuffer:(CGPixelFramebuffer *)framebuffer {
    _inputFramebuffer = framebuffer;
}

- (void)newFrameReadyAtTime:(CMTime)frameTime timimgInfo:(CMSampleTimingInfo)timimgInfo {
    [_renderPipline glDraw:[_inputFramebuffer texture] width:_inputFramebuffer.fboSize.width height:_inputFramebuffer.fboSize.height];
    if (_inputFramebuffer.isOnlyGenTexture == NO) {
        [_inputFramebuffer recycle];
    }
}

- (void)setClearColorRed:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alpha {
    bgColor[0] = red;
    bgColor[1] = green;
    bgColor[2] = blue;
    bgColor[3] = alpha;
}

- (void)dealloc
{
    _renderPipline = nil;
    
}

@end
