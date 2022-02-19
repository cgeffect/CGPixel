//
//  CGPixelSoulFilter.m
//  CGPixel
//
//  Created by CGPaint on 2021/5/14.
//  Copyright © 2021 CGPaint. All rights reserved.
//

#import "CGPaintSoulFilter.h"

@implementation CGPaintSoulFilter

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
    int index = [_shaderProgram getUniformLocation:@"Time"];
    [_shaderProgram setUniform1f:index x:_value];
}

@end
