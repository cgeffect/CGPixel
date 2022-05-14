//
//  CGPixelPhotoFilter.m
//  CGPixel
//
//  Created by Jason on 2022/5/12.
//

#import "CGPixelPhotoFilter.h"

@implementation CGPixelPhotoFilter
{
    vec_float3 _inValue;
}
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

- (void)setInValue3:(vec_float3)inValue {
    _inValue = inValue;
}

- (void)setValue:(CGFloat)value {
    _value = value;
}
- (void)glProgramUsed {
    vec_float3 vec3 = {1.0, 0.0, 0.0};
    _inValue = vec3;
    int index = [_shaderProgram getUniformLocation:@"uColor"];
    [_shaderProgram setUniform3f:index x:_inValue.x y:_inValue.y z:_inValue.z];
    
    int idx = [_shaderProgram getUniformLocation:@"uRatio"];
    [_shaderProgram setUniform1f:idx x:_value / 100.0];

}

@end
