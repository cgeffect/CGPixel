//
//  CGPaintVortexFilter.m
//  CGPaint
//
//  Created by CGPaint on 2021/5/24.
//

#import "CGPaintVortexFilter.h"

@implementation CGPaintVortexFilter
- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"fsh"];
    NSString *shader = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self = [super initWithFragmentShader:shader];
    if (self) {

    }
    return self;
}
- (void)glProgramUsed {
    int index = [_shaderProgram getUniformLocation:@"uD"];
    [_shaderProgram setUniform1f:index x:_value];
}
@end
