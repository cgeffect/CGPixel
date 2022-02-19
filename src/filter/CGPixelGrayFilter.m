//
//  CGPixelGrayFilter.m
//  CGPixel
//
//  Created by Jason on 2021/5/30.
//

#import "CGPixelGrayFilter.h"

@implementation CGPixelGrayFilter
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

@end
