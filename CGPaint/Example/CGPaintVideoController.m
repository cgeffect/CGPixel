//
//  CGPaintVideoController.m
//  CGPaint
//
//  Created by Jason on 2021/5/31.
//

#import "CGPaintVideoController.h"
#import "CGPaint.h"

@interface CGPaintVideoController ()
{
    CGPaintViewOutput *_paintview;
    CGPaintVideoInput *_inputSource;
    CGPaintFilter<CGPaintInput> *filter;
}
@end

@implementation CGPaintVideoController

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
    switch (_filterType) {
        case CG_FILTER:
        {
            filter = [[CGPaintFilter alloc] init];
        }break;;
        case CG_SOUL:
        {
            filter = [[CGPaintSoulFilter alloc] init];
        }break;
        case CG_RADIAL_FAST_BLUR:
        {
            filter = [[CGPaintRadialFastBlurFilter alloc] init];
        }break;
        case CG_SHAKE:
        {
            filter = [[CGPaintShakeFilter alloc] init];
        }break;
        case CG_GLITCH:
        {
            filter = [[CGPaintGlitchFilter alloc] init];
        }break;
        case CG_RADIAL_SCALE_BLUR:
        {
            filter = [[CGPaintRadialScaleBlurFilter alloc] init];
        }break;
        case CG_RADIAL_ROTATE_BLUR:
        {
            filter = [[CGPaintRadialRotateBlurFilter alloc] init];
        }break;
        case CG_VORTEX:
        {
            filter = [[CGPaintVortexFilter alloc] init];
        }break;
        default:
            break;
    }
    CGPaintGrayFilter *gray = [[CGPaintGrayFilter alloc] init];
    [_inputSource addTarget:gray];
    [gray addTarget:filter];
    [filter addTarget:_paintview];
    [_inputSource requestRender];
}

- (void)valueChange:(UISlider *)slide {
    switch (_filterType) {
        case CG_SOUL:[filter setValue:slide.value * 2];break;
        case CG_RADIAL_FAST_BLUR:[filter setValue:slide.value];break;
        case CG_SHAKE:[filter setValue:slide.value * 2];break;
        case CG_GLITCH:[filter setValue:slide.value * 2];break;
        case CG_RADIAL_SCALE_BLUR:[filter setValue:slide.value * 100];break;
        case CG_RADIAL_ROTATE_BLUR:[filter setValue:slide.value * 100];break;
        case CG_VORTEX:[filter setValue:slide.value * 100 - 50];break;
        default:
            break;
    }
}
- (void)dealloc
{
    [_inputSource stopRender];
}
@end
