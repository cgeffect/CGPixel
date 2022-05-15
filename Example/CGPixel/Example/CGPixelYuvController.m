//
//  CGPixelYuvController.m
//  CGPixel
//
//  Created by Jason on 2022/5/15.
//

#import "CGPixelYuvController.h"
#import "CGPixel.h"
#import "CGPixelSource.h"

@interface CGPixelYuvController ()

@end

@implementation CGPixelYuvController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    CGPixelImageInput *input = [[CGPixelImageInput alloc] initWithImage:[UIImage imageNamed:@"rgba_1120"]];
    CGPixelFilter *basic = [[CGPixelFilter alloc] init];
    CGPixelYuvFilter *filter = [[CGPixelYuvFilter alloc] init];
    CGPixelYuvOutput *output = [[CGPixelYuvOutput alloc] init];
    CGPixelImageOutput *imgOut = [[CGPixelImageOutput alloc] init];
    CGPixelViewOutput *viewOut = [[CGPixelViewOutput alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:viewOut];
    [input addTarget:basic];
//    [basic addTarget:imgOut];
    [basic addTarget:filter];
    [filter addTarget:output];
    [filter addTarget:viewOut];
    [input requestRender];
}

@end
