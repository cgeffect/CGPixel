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

//
//- (UIImage*) takePicture {
//    int s = 1;
//    UIScreen* screen = [UIScreen mainScreen];
//    if ([screen respondsToSelector:@selector(scale)]) {
//        s = (int) [screen scale];
//    }
//
//    GLint viewport[4];
//    glGetIntegerv(GL_VIEWPORT, viewport);
//
//
//    int width = viewport[2];
//    int height = viewport[3];
//
//    int myDataLength = width * height * 4;
//    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
//    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
//    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
//    for(int y1 = 0; y1 < height; y1++) {
//        for(int x1 = 0; x1 <width * 4; x1++) {
//            buffer2[(height - 1 - y1) * width * 4 + x1] = buffer[y1 * 4 * width + x1];
//        }
//    }
//    free(buffer);
//
//    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
//    int bitsPerComponent = 8;
//    int bitsPerPixel = 32;
//    int bytesPerRow = 4 * width;
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
//    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
//    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
//    CGColorSpaceRelease(colorSpaceRef);
//    CGDataProviderRelease(provider);
//    UIImage *image = [ UIImage imageWithCGImage:imageRef scale:s orientation:UIImageOrientationUp ];
//    return image;
//}

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
