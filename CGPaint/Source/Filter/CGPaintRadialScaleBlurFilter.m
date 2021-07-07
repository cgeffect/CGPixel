//
//  CGPaintRadialScaleBlurFilter.m
//  CGPaint
//
//  Created by CGPaint on 2021/5/19.
//

#import "CGPaintRadialScaleBlurFilter.h"

@interface CGPaintRadialScaleBlurFilter ()
{
    int uSize;
    int uCenter;
    int uCount;
}
@end

@implementation CGPaintRadialScaleBlurFilter
- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"fsh"];
    NSString *shader = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self = [super initWithFragmentShader:shader];
    if (self) {

    }
    
    return self;
    
}

- (void)glProgramLinked {
    uSize = [_shaderProgram getUniformLocation:@"uSize"];
    uCenter = [_shaderProgram getUniformLocation:@"uCenter"];
    uCount = [_shaderProgram getUniformLocation:@"uCount"];
}
- (void)glProgramUsed {
    [_shaderProgram setUniform2f:uSize x:self.size.width y:self.size.height];
    [_shaderProgram setUniform2f:uCenter x:self.size.width * 0.5 y:self.size.height * 0.5];
    [_shaderProgram setUniform1f:uCount x:_value];
}

@end
