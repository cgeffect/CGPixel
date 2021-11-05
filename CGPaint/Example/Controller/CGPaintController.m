//
//  CGPaintController.m
//  CGPaint
//
//  Created by Jason on 2021/5/15.
//

#import "CGPaintController.h"
#import "CGPaint.h"
#import "CGImageCoder.h"
#import "CGPreviewController.h"
#import "CGPaintSource.h"
@interface CGPaintController ()
{
    CGPaintOutput *_inputSource;
    CGPaintFilter<CGPaintInput> *filter;
    CGPaintViewOutput * paintview;
    CGPaintTargetOutput *_targetOutput;
    UIImage *_sourceImage;
}
@end

@implementation CGPaintController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];;

    paintview = [[CGPaintViewOutput alloc] initWithFrame:CGRectMake(0, 100, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width)];
    paintview.backgroundColor = UIColor.redColor;
    [self.view addSubview:paintview];
        
    [self setInputSource];
    UISlider *slide = [[UISlider alloc] initWithFrame:CGRectMake(30, UIScreen.mainScreen.bounds.size.height - 100, UIScreen.mainScreen.bounds.size.width - 60, 50)];
    slide.minimumValue = 0;
    slide.maximumValue = 1;
    [slide addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slide];
    
    _sourceImage = [UIImage imageNamed:@"rgba"];
    switch (_inputType) {
        case CG_TEXTURE:
            self.navigationItem.title = @"CG_TEXTURE";
            break;
        case CG_RAWDATA:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"rgba8_1125x1125" ofType:@"rgba"];
            NSData *rgba = [NSData dataWithContentsOfFile:path];
            _inputSource = [[CGPaintRawDataInput alloc] initWithByte:(UInt8 *)rgba.bytes byteSize:CGSizeMake(1125, 1125) format:CGDataFormatRGBA];
            self.navigationItem.title = @"CG_RAWDATA";
        } break;
        case CG_IMAGE:
            _inputSource = [[CGPaintImageInput alloc] initWithImage:_sourceImage];
            self.navigationItem.title = @"CG_IMAGE";
            break;
        case CG_PIXELBUFFER:
        {
            self.navigationItem.title = @"CG_PIXELBUFFER";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"nv12_1120x1120_bgra" ofType:@"yuv"];
            NSData *nv12 = [NSData dataWithContentsOfFile:path];
            CVPixelBufferRef pixel = [CGPaintSource pixelBufferCreate:kCVPixelFormatType_32BGRA width:1120 height:1120];
            [CGPaintSource create32BGRAPixelBufferWithNV12:(UInt8 *)nv12.bytes width:1120 height:1120 dstBuffer:pixel];
            _inputSource = [[CGPaintPixelBufferInput alloc] initWithPixelBuffer:pixel format:CGPixelFormatBGRA];
            CVPixelBufferRelease(pixel);
        } break;
        default:
            break;
    }
    [self setupFilter];
}

- (void)setInputSource {
    
    NSArray *itemList = nil;
    if (_inputType == CG_RAWDATA) {
        itemList = @[@"RGBA", @"BGRA", @"NV21", @"NV12", @"I420"];
    } else if (_inputType == CG_PIXELBUFFER) {
        itemList = @[@"BGRA", @"NV12"];
    }
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:itemList];
    seg.frame = CGRectMake(0, CGRectGetMaxY(paintview.frame) + 20, UIScreen.mainScreen.bounds.size.width, 50);
    [seg addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    seg.selectedSegmentIndex = 0;
}

- (void)segAction:(UISegmentedControl *)seg {
    if (seg.numberOfSegments == 5) {
        NSString *path = nil;
        CGDataFormat format = 0;
        CGSize size = CGSizeZero;
        if (seg.selectedSegmentIndex == 0) {
            path = [[NSBundle mainBundle] pathForResource:@"rgba8_1125x1125" ofType:@"rgba"];
            format = CGDataFormatRGBA;
            size = CGSizeMake(1125, 1125);
        } else if (seg.selectedSegmentIndex == 1) {
            path = [[NSBundle mainBundle] pathForResource:@"bgra8_1125x1125" ofType:@"bgra"];
            format = CGDataFormatBGRA;
            size = CGSizeMake(1125, 1125);
        } else if (seg.selectedSegmentIndex == 2) {
            path = [[NSBundle mainBundle] pathForResource:@"nv21_1120x1120" ofType:@"yuv"];
            format = CGDataFormatNV21;
            size = CGSizeMake(1120, 1120);
        } else if (seg.selectedSegmentIndex == 3) {
            path = [[NSBundle mainBundle] pathForResource:@"nv12_1120x1120" ofType:@"yuv"];
            format = CGDataFormatNV12;
            size = CGSizeMake(1120, 1120);
        } else if (seg.selectedSegmentIndex == 4) {
            path = [[NSBundle mainBundle] pathForResource:@"I420_1120x1120" ofType:@"yuv"];
            format = CGDataFormatI420;
            size = CGSizeMake(1120, 1120);
        }
        NSData *data = [NSData dataWithContentsOfFile:path];
        self->_inputSource = [[CGPaintRawDataInput alloc] initWithByte:(UInt8 *)data.bytes byteSize:size format:format];
    } else {
        if (seg.selectedSegmentIndex == 0) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"nv12_1120x1120_bgra" ofType:@"yuv"];
            NSData *nv12 = [NSData dataWithContentsOfFile:path];
            CVPixelBufferRef pixel = [CGPaintSource pixelBufferCreate:kCVPixelFormatType_32BGRA width:1120 height:1120];
            [CGPaintSource create32BGRAPixelBufferWithNV12:(UInt8 *)nv12.bytes width:1120 height:1120 dstBuffer:pixel];
            self->_inputSource = [[CGPaintPixelBufferInput alloc] initWithPixelBuffer:pixel format:CGPixelFormatBGRA];
            CVPixelBufferRelease(pixel);
        } else if (seg.selectedSegmentIndex == 1) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"nv12_1120x1120" ofType:@"yuv"];
            NSData *nv12 = [NSData dataWithContentsOfFile:path];
            CVPixelBufferRef pixel = [CGPaintSource create420Yp8_CbCr8PixelBufferWithNV12:(UInt8 *)nv12.bytes width:1120 height:1120];
            self->_inputSource = [[CGPaintPixelBufferInput alloc] initWithPixelBuffer:pixel format:CGPixelFormatNV12];
            CVPixelBufferRelease(pixel);
        }
    }
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
    _targetOutput = [[CGPaintPixelbufferOutput alloc] init];
    CGPaintGrayFilter *gray = [[CGPaintGrayFilter alloc] init];
    [_inputSource addTarget:gray];
    [gray addTarget:filter];
    [filter addTarget:paintview];
    [filter addTarget:_targetOutput];
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
    [_inputSource requestRender];
//    _targetOutput.enableOutput = YES;
    [((CGPaintPixelbufferOutput *)_targetOutput) setOutputCallback:^(CVPixelBufferRef  _Nonnull pixelbuffer) {
        
    }];
}

- (void)save {
    [filter imageFromCurrentFramebuffer:^(CGImageRef  _Nonnull imageRef) {
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:1 orientation:UIImageOrientationUp];
        CGPreviewController *preview = [[CGPreviewController alloc] init];
        preview.image = image;
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self.navigationController pushViewController:preview animated:YES];
    }];
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    ELPushStreamViewController *vc = [[ELPushStreamViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)dealloc
{
    
}

@end
