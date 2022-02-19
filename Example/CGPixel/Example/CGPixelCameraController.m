//
//  CGPixelCameraController.m
//  CGPixel
//
//  Created by Jason on 2021/12/25.
//

#import "CGPixelCameraController.h"
#import "CGPreviewController.h"
#import "CGPixel.h"

@interface CGPixelCameraController ()<CGPixelCaptureDelegate>
{
    CGPixelViewOutput *_metalView;
    CGPixelCameraInput *_cameraInput;
}

@end

@implementation CGPixelCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"CG_VIDEO";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIBarButtonItem *take = [[UIBarButtonItem alloc] initWithTitle:@"take" style:(UIBarButtonItemStyleDone) target:self action:@selector(takePhoto)];
    UIBarButtonItem *toggle = [[UIBarButtonItem alloc] initWithTitle:@"switch" style:(UIBarButtonItemStyleDone) target:self action:@selector(toggle)];
    UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:@"start" style:(UIBarButtonItemStyleDone) target:self action:@selector(start)];
    UIBarButtonItem *end = [[UIBarButtonItem alloc] initWithTitle:@"end" style:(UIBarButtonItemStyleDone) target:self action:@selector(end)];
    self.navigationItem.rightBarButtonItems = @[take, toggle, start, end];
    
    _metalView = [[CGPixelViewOutput alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    _metalView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:_metalView];
    
    [CGPixelCameraInput checkCameraAuthor];
    [CGPixelCameraInput checkMicrophoneAuthor];
    _cameraInput = [[CGPixelCameraInput alloc] initWithType:(CGMetalCaptureTypeVideo)];
    _cameraInput.delegate = self;
    CGPixelFilter *filter = [[CGPixelGlitchFilter alloc] init];
    [filter setValue:2];
    [_cameraInput addTarget:filter];
    [filter addTarget:_metalView];
    [_cameraInput startRunning];
    
}

- (void)takePhoto {
    [_cameraInput takePhoto];
}

- (void)toggle {
    [_cameraInput changeCamera];
}

- (void)start {

}
- (void)end {

}

- (void)captureAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
}

- (void)captureVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
}

- (void)takePhotoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
}

- (void)takePhotoData:(NSData *)photoData {
    UIImage *image = [UIImage imageWithData:photoData];
    CGPreviewController *vc = [[CGPreviewController alloc] init];
    vc.image = image;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {

}
- (NSString *)createFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *tmpPath = [path stringByAppendingPathComponent:@"temp"];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    [[NSFileManager defaultManager] createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString* outFilePath = [tmpPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_%@", (int)time, fileName]];
    return outFilePath;
}
@end
