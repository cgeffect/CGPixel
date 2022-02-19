//
//  CGPixelCameraInput.h
//  CGMetal
//
//  Created by Jason on 2021/12/23.
//

#import "CGPixelOutput.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (int, CGMetalCaptureType) {
    CGMetalCaptureTypeVideo = 0,
    CGMetalCaptureTypePhoto,
};

@protocol CGPaintCaptureDelegate <NSObject>
@optional
- (void)captureVideoSampleBuffer:(CMSampleBufferRef _Nullable)sampleBuffer;

- (void)captureAudioSampleBuffer:(CMSampleBufferRef _Nullable)sampleBuffer;

- (void)takePhotoSampleBuffer:(CMSampleBufferRef _Nullable)sampleBuffer;

- (void)takePhotoData:(NSData *_Nullable)photoData;

@end

@interface CGPaintCameraInput : CGPixelOutput

@property(nonatomic) AVCaptureVideoOrientation videoOrientation;

@property (nonatomic, weak) id<CGPaintCaptureDelegate> delegate;

@property (nonatomic, assign, readonly) NSUInteger width;

@property (nonatomic, assign, readonly) NSUInteger height;

@property(nonatomic, assign, readonly) BOOL isFront;

+ (int)checkMicrophoneAuthor;

+ (int)checkCameraAuthor;

- (instancetype)initWithType:(CGMetalCaptureType)type;

- (void)startRunning;

- (void)stopRunning;

- (void)changeCamera;

- (void)takePhoto;

@end

NS_ASSUME_NONNULL_END
