#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CGPixel.h"
#import "CGPixelUtils.h"
#import "CGPaintFramebuffer.h"
#import "CGPaintFramebufferCache.h"
#import "CGPaintProgram.h"
#import "CGPixelContext.h"
#import "CGPixelFilterInput.h"
#import "CGPixelInput.h"
#import "CGPixelOutput.h"
#import "CGPixelFilter.h"
#import "CGPixelGlitchFilter.h"
#import "CGPixelGrayFilter.h"
#import "CGPixelRadialFastBlurFilter.h"
#import "CGPixelRadialRotateBlurFilter.h"
#import "CGPixelRadialScaleBlurFilter.h"
#import "CGPixelShakeFilter.h"
#import "CGPixelSoulFilter.h"
#import "CGPixelVortexFilter.h"
#import "CGPixelCameraInput.h"
#import "CGPixelImageInput.h"
#import "CGPixelPixelBufferInput.h"
#import "CGPixelRawDataInput.h"
#import "CGPixelTextureInput.h"
#import "CGPixelVideoInput.h"
#import "CGPaintImageOutput.h"
#import "CGPaintPixelbufferOutput.h"
#import "CGPaintRawDataOutput.h"
#import "CGPaintTargetOutput.h"
#import "CGPaintTextureOutput.h"
#import "CGPaintViewOutput.h"
#import "CGPaintPipelineOutput.h"
#import "CGPaintRenderPipeline.h"

FOUNDATION_EXPORT double CGPixelVersionNumber;
FOUNDATION_EXPORT const unsigned char CGPixelVersionString[];

