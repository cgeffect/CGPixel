//
//  CGPaintRadialRotateBlurFilter.m
//  CGPaint
//
//  Created by CGPaint on 2021/5/19.
//

#import "CGPaintRadialRotateBlurFilter.h"

@implementation CGPaintRadialRotateBlurFilter

- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"fsh"];
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
