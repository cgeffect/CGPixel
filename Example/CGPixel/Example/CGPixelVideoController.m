//
//  CGPixelVideoController.m
//  CGPixel
//
//  Created by Jason on 2021/5/31.
//

#import "CGPixelVideoController.h"
#import "CGPaint.h"

@interface CGPixelVideoController ()
{
    CGPaintViewOutput *_paintview;
    CGPaintVideoInput *_inputSource;
    CGPaintSoulFilter *_soul;
    CGPaintGlitchFilter *_glitch;

}
@end

@implementation CGPixelVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    _paintview = [[CGPaintViewOutput alloc] initWithFrame:CGRectMake(0, 100, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width)];
    _paintview.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_paintview];
    
    self.navigationItem.title = @"CG_VIDEO";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"mp4"];
    _inputSource = [[CGPaintVideoInput alloc] initWithURL:[NSURL fileURLWithPath:path]];
        
    UISlider *slide = [[UISlider alloc] initWithFrame:CGRectMake(30, UIScreen.mainScreen.bounds.size.height - 100, UIScreen.mainScreen.bounds.size.width - 60, 50)];
    slide.minimumValue = 0;
    slide.maximumValue = 1;
    [slide addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slide];

    [self setupFilter];
}

- (void)setupFilter {
    _soul = [[CGPaintSoulFilter alloc] init];
    _glitch = [[CGPaintGlitchFilter alloc] init];
    [_inputSource addTarget:_glitch];
    [_glitch addTarget:_soul];
    [_soul addTarget:_paintview];
    [_inputSource requestRender];
}

- (void)valueChange:(UISlider *)slide {
    [_soul setValue:slide.value * 2];
    [_glitch setValue:slide.value * 2];
}
- (void)dealloc
{
    [_inputSource stopRender];
}
@end
