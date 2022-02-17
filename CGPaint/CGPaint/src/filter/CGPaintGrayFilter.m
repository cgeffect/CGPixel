//
//  CGPaintGrayFilter.m
//  CGPaint
//
//  Created by Jason on 2021/5/30.
//

#import "CGPaintGrayFilter.h"

@implementation CGPaintGrayFilter
- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"fsh"];
    NSString *shader = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self = [super initWithFragmentShader:shader];
    if (self) {

    }
    return self;
}

@end
