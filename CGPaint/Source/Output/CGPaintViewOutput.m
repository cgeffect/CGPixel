//
//  CGPaintViewOutput.m
//  CGPaint
//
//  Created by Jason on 21/3/3.
//

#import "CGPaintViewOutput.h"
#import "CGPaintRenderPipeline.h"
#import "CGPaintOutput.h"

@implementation CGPaintViewOutput
{
    CGPaintFramebuffer *_inputFramebuffer;
    CGPaintRenderPipeline *_renderPipline;
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
        eaglLayer.drawableProperties = @{
                kEAGLDrawablePropertyRetainedBacking: @NO,
                kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8
        };

        runSyncOnSerialQueue(^{
            [[CGPaintContext sharedRenderContext] useAsCurrentContext];
            self->_renderPipline = [[CGPaintRenderPipeline alloc] init];
            if ([self->_renderPipline glPrepareDrawToGLLayer:(CAEAGLLayer *)self.layer]) {
                NSLog(@"glPrepareRender success...");
            } else {
                NSLog(@"glPrepareRender failed...");
            }
        });
    }
    return self;
}

- (void)setInputFramebuffer:(CGPaintFramebuffer *)framebuffer {
    _inputFramebuffer = framebuffer;
}

- (void)newFrameReadyAtTime:(CMTime)frameTime timimgInfo:(CMSampleTimingInfo)timimgInfo {
    [_renderPipline glDraw:[_inputFramebuffer texture] width:self.bounds.size.width height:self.bounds.size.height];
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
