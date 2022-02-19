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

#import "CGPaintUtils.h"
#import "CGPixel.h"
#import "CGPaintFramebuffer.h"
#import "CGPaintFramebufferCache.h"
#import "CGPaintInput.h"
#import "CGPaintOutput.h"
#import "CGPaintProgram.h"
#import "CGPixelContext.h"
#import "CGPixelFilterInput.h"
#import "CGPaintFilter.h"
#import "CGPaintGlitchFilter.h"
#import "CGPaintGrayFilter.h"
#import "CGPaintRadialFastBlurFilter.h"
#import "CGPaintRadialRotateBlurFilter.h"
#import "CGPaintRadialScaleBlurFilter.h"
#import "CGPaintShakeFilter.h"
#import "CGPaintSoulFilter.h"
#import "CGPaintVortexFilter.h"
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

