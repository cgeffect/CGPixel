//
//  CGPaintGlitchFilter.m
//  CGPaint
//
//  Created by CGPaint on 2021/5/19.
//

#import "CGPaintGlitchFilter.h"

@implementation CGPaintGlitchFilter

- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"fsh"];
    NSString *shader = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self = [super initWithFragmentShader:shader];
    if (self) {

    }
    
    return self;
}
- (void)glProgramUsed {
    GLuint loc = [_shaderProgram getUniformLocation:@"Time"];
    [_shaderProgram setUniform1f:loc x:_value];
}

@end
