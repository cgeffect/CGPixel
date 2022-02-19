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
#import "CGPaintGlitchFilter.h"
#import "CGPaintGrayFilter.h"
#import "CGPaintRadialFastBlurFilter.h"
#import "CGPaintRadialRotateBlurFilter.h"
#import "CGPaintRadialScaleBlurFilter.h"
#import "CGPaintShakeFilter.h"
#import "CGPaintSoulFilter.h"
#import "CGPaintVortexFilter.h"
#import "CGPixelFilter.h"
#import "CGPaintCameraInput.h"
#import "CGPaintImageInput.h"
#import "CGPaintPixelBufferInput.h"
#import "CGPaintRawDataInput.h"
#import "CGPaintTextureInput.h"
#import "CGPaintVideoInput.h"
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

