//
//  CCGPUImageTwoInputFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2020/6/11.
//  Copyright © 2020 Selfie. All rights reserved.
//

#import "FXTwoInputFilter.h"

@implementation FXTwoInputFilter
- (id)init;
{
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:NSStringFromClass(self.class) ofType:@"fsh"];
    NSString* source = [NSString stringWithContentsOfFile:fragFile encoding:NSUTF8StringEncoding error:nil];

    if (!(self = [super initWithFragmentShaderFromString:source]))
    {
        return nil;
    }
        
    return self;
}
@end
