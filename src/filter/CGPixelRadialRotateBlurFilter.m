//
//  CGPixelRadialRotateBlurFilter.m
//  CGPixel
//
//  Created by CGPixel on 2021/5/19.
//

#import "CGPixelRadialRotateBlurFilter.h"

@implementation CGPixelRadialRotateBlurFilter

- (instancetype)init {
#ifdef TARGET_IPHONE_POD
    NSBundle *bunle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bunle pathForResource:NSStringFromClass([self class]) ofType:@"fsh"];
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
    [_shaderProgram setUniform2f:[_shaderProgram getUniformLocation:@"uSize"] x:self.size.width y:self.size.height];
    [_shaderProgram setUniform2f:[_shaderProgram getUniformLocation:@"uCenter"] x:self.size.width * 0.5 y:self.size.height * 0.5];
    [_shaderProgram setUniform1f:[_shaderProgram getUniformLocation:@"uCount"] x:_value];
}

@end
