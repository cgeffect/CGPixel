//
//  CGPaintController.m
//  CGPaint
//
//  Created by Jason on 2021/5/15.
//

#import "CGPaintController.h"
#import "CGPaint.h"
#import "CGImageCoder.h"
#import <Accelerate/Accelerate.h>
#import "CGPreviewController.h"

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
            CVPixelBufferRef pixel = [CGPaintController pixelBufferCreate:kCVPixelFormatType_32BGRA width:1120 height:1120];
            [CGPaintController create32BGRAPixelBufferWithNV12:(UInt8 *)nv12.bytes width:1120 height:1120 dstBuffer:pixel];
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
            CVPixelBufferRef pixel = [CGPaintController pixelBufferCreate:kCVPixelFormatType_32BGRA width:1120 height:1120];
            [CGPaintController create32BGRAPixelBufferWithNV12:(UInt8 *)nv12.bytes width:1120 height:1120 dstBuffer:pixel];
            self->_inputSource = [[CGPaintPixelBufferInput alloc] initWithPixelBuffer:pixel format:CGPixelFormatBGRA];
            CVPixelBufferRelease(pixel);
        } else if (seg.selectedSegmentIndex == 1) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"nv12_1120x1120" ofType:@"yuv"];
            NSData *nv12 = [NSData dataWithContentsOfFile:path];
            CVPixelBufferRef pixel = [CGPaintController create420Yp8_CbCr8PixelBufferWithNV12:(UInt8 *)nv12.bytes width:1120 height:1120];
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

/*
 int width = (int)CGImageGetWidth(image.CGImage);
 int height = (int)CGImageGetHeight(image.CGImage);
 UInt8 *bgra = CGRDecodeImage32LittleARGB(image.CGImage, width, height);
 NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"bgra8_1125x1125.bgra"];
 FILE *file = fopen([path UTF8String], "wb++");
 int buffersize = width * height * 4;
 fwrite((uint8_t *)bgra, 1, buffersize, file);
 fclose(file);
 */


+ (CVPixelBufferRef)pixelBufferCreate:(OSType)pixelFormatType width:(NSUInteger)width height:(NSUInteger)height {
    CVPixelBufferRef _pixelBuffer;
    CFDictionaryRef pixelAttributes = (__bridge CFDictionaryRef)
    (@{
        (id)kCVPixelBufferIOSurfacePropertiesKey : @{},
        (id)kCVPixelBufferOpenGLESCompatibilityKey:@(YES)
     });
    CVPixelBufferCreate(kCFAllocatorDefault, (size_t) width, (size_t) height, pixelFormatType, pixelAttributes, &_pixelBuffer);
    return _pixelBuffer;
}
+ (BOOL)create32BGRAPixelBufferWithNV12:(nonnull UInt8 *)nv12 width:(NSUInteger)width height:(NSUInteger)height dstBuffer:(nonnull CVPixelBufferRef)dstBuffer {
    @autoreleasepool {
        vImage_YpCbCrToARGB outInfo;
        vImage_YpCbCrPixelRange pixelRange = (vImage_YpCbCrPixelRange){ 0, 128, 255, 255, 255, 1, 255, 0 };
        vImageConvert_YpCbCrToARGB_GenerateConversion(kvImage_YpCbCrToARGBMatrix_ITU_R_601_4, &pixelRange, &outInfo, kvImage420Yp8_CbCr8, kvImageARGB8888, kvImageNoFlags);
        vImage_Error error = kvImageNoError;
        
        vImage_Buffer srcYp = {.data = nv12, .width = width, .height = height, .rowBytes = width};
        vImage_Buffer srcCbCr = {.data = nv12 + width * height, .width = width, .height = height / 2, .rowBytes = width};

        CVPixelBufferLockBaseAddress(dstBuffer, kCVPixelBufferLock_ReadOnly);
        vImage_Buffer dest;
        dest.data = CVPixelBufferGetBaseAddress(dstBuffer);
        dest.width = CVPixelBufferGetWidth(dstBuffer);
        dest.height = CVPixelBufferGetHeight(dstBuffer);
        dest.rowBytes = CVPixelBufferGetBytesPerRow(dstBuffer);
        
        uint8_t permuteMap[4] = {3, 2, 1, 0}; // BGRA
        vImageConvert_420Yp8_CbCr8ToARGB8888(&srcYp, &srcCbCr, &dest, &outInfo, permuteMap, 255, kvImageNoFlags);
        CVPixelBufferUnlockBaseAddress(dstBuffer, kCVPixelBufferLock_ReadOnly);
        return error == kvImageNoError;
    }
}

+ (nullable CVPixelBufferRef)create420Yp8_CbCr8PixelBufferWithNV12:(UInt8 *)data width:(NSInteger)width height:(NSInteger)height {

    NSDictionary *pixelAttributes = @{
            (NSString *) kCVPixelBufferIOSurfacePropertiesKey: @{},
            (NSString *) kCVPixelBufferOpenGLESCompatibilityKey: @(YES)
    };
    CVPixelBufferRef pixelBuffer = NULL;

    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
            (size_t) width, (size_t) height,
            kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
            (__bridge CFDictionaryRef) (pixelAttributes), &pixelBuffer);

    if (status != kCVReturnSuccess) {
        NSLog(@"Unable to create CVPixelBuffer %d", status);
        return NULL;
    }
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);

    uint8_t *y_src = data;
    uint8_t *y_dest = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    size_t y_src_bytesPerRow = (size_t) width;
    size_t y_dest_bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);

    for (int i = 0; i < height; i++) {
        bzero(y_dest, y_dest_bytesPerRow);
        memcpy(y_dest, y_src, MIN(y_src_bytesPerRow, y_dest_bytesPerRow));
        y_src += y_src_bytesPerRow;
        y_dest += y_dest_bytesPerRow;
    }

    uint8_t *uv_src = data + width * height;
    uint8_t *uv_dest = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    size_t uv_src_bytesPerRow = (size_t) width;
    size_t uv_dest_bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);

    for (int i = 0; i < height / 2; i++) {
        bzero(uv_dest, uv_dest_bytesPerRow);
        memcpy(uv_dest, uv_src, MIN(uv_src_bytesPerRow, uv_dest_bytesPerRow));
        uv_src += uv_src_bytesPerRow;
        uv_dest += uv_dest_bytesPerRow;
    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    return pixelBuffer;
}
@end
