//
//  CGPixelYuvFilter.m
//  CGPixel
//
//  Created by Jason on 2022/5/14.
//

#import "CGPixelYuvFilter.h"
/**
 mat4 RGBtoYUV(0.257,  0.439, -0.148, 0.0,
              0.504, -0.368, -0.291, 0.0,
              0.098, -0.071,  0.439, 0.0,
              0.0625, 0.500,  0.500, 1.0 );

 YUV = RGBtoYUV * RGB;
 */
@implementation CGPixelYuvFilter

- (instancetype)init {
#ifdef TARGET_IPHONE_POD
    NSBundle *bunle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bunle pathForResource:@"CGPixelYuvHigh" ofType:@"fsh"];
#else
    NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"fsh"];
#endif
    NSString *shader = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self = [super initWithFragmentShader:shader];
    if (self) {

    }
    return self;
}

- (void)glProgramUsed {
    
    int width = [_shaderProgram getUniformLocation:@"width"];
    int height = [_shaderProgram getUniformLocation:@"height"];
    [_shaderProgram setUniform1f:width x:1120];
    [_shaderProgram setUniform1f:height x:1120];

}
@end
