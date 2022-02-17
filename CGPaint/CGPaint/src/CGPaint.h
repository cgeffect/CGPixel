//
//  CGPaint.h
//  CGPaint
//
//  Created by CGPaint on 2021/5/12.
//

#import <Foundation/Foundation.h>

//! Project version number for AVTPlayer.
FOUNDATION_EXPORT double CGPaintVersionNumber;

//! Project version string for AVTPlayer.
FOUNDATION_EXPORT const unsigned char CGPaintVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CGPaint/PublicHeader.h>

#pragma mark -
#pragma mark Filter
#import "CGPaintFilter.h"
#import "CGPaintSoulFilter.h"
#import "CGPaintRadialFastBlurFilter.h"
#import "CGPaintShakeFilter.h"
#import "CGPaintGlitchFilter.h"
#import "CGPaintRadialRotateBlurFilter.h"
#import "CGPaintRadialScaleBlurFilter.h"
#import "CGPaintVortexFilter.h"
#import "CGPaintGrayFilter.h"

#pragma mark -
#pragma mark Input
#import "CGPaintImageInput.h"
#import "CGPaintRawDataInput.h"
#import "CGPaintTextureInput.h"
#import "CGPaintPixelBufferInput.h"
#import "CGPaintVideoInput.h"
#import "CGPaintCameraInput.h"

#pragma mark -
#pragma mark Output
#import "CGPaintViewOutput.h"
#import "CGPaintImageOutput.h"
#import "CGPaintRawDataOutput.h"
#import "CGPaintTextureOutput.h"
#import "CGPaintPixelbufferOutput.h"

