//
//  CGPixelYuvOutput.m
//  CGPixel
//
//  Created by Jason on 2022/5/14.
//

#import "CGPixelYuvOutput.h"

@implementation CGPixelYuvOutput

#pragma mark -
#pragma mark CGPaintInput
- (void)newFrameReadyAtTime:(CMTime)frameTime framebuffer:(CGPixelFramebuffer *)framebuffer {
    [framebuffer bindFramebuffer];

    int width = framebuffer.fboSize.width;
    int height = framebuffer.fboSize.height;
    
    uint8_t *yuv = (uint8_t *)malloc(width * height * 3 / 2);
    glPixelStorei(GL_PACK_ALIGNMENT, 4);

    int offset = width * height;
    // Y
    glReadPixels(0, 0, width / 4, height,  GL_RGBA, GL_UNSIGNED_BYTE, yuv);
    // U
    glReadPixels(width / 4, 0, width / 8, height / 2, GL_RGBA, GL_UNSIGNED_BYTE, yuv + offset);
    // V
    glReadPixels(width / 4, height / 2, width / 8, height / 2, GL_RGBA, GL_UNSIGNED_BYTE, yuv + offset * 5 / 4);
    
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    documentsDir = [documentsDir stringByAppendingPathComponent:@"log.yuv"];

    NSData *d = [NSData dataWithBytes:yuv length:width * height * 3 / 2];
    [d writeToFile:documentsDir atomically:YES];
}

- (void)dealloc {

}

@end
