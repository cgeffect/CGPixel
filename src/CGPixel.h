//
//  CGPixel.h
//  CGPixel
//
//  Created by CGPixel on 2021/5/12.
//

#import <Foundation/Foundation.h>

//! Project version number for AVTPlayer.
FOUNDATION_EXPORT double CGPaintVersionNumber;

//! Project version string for AVTPlayer.
FOUNDATION_EXPORT const unsigned char CGPaintVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CGPaint/PublicHeader.h>

#pragma mark -
#pragma mark Filter
#import "CGPixelFilter.h"
#import "CGPixelSoulFilter.h"
#import "CGPixelRadialFastBlurFilter.h"
#import "CGPixelShakeFilter.h"
#import "CGPixelGlitchFilter.h"
#import "CGPixelRadialRotateBlurFilter.h"
#import "CGPixelRadialScaleBlurFilter.h"
#import "CGPixelVortexFilter.h"
#import "CGPixelGrayFilter.h"

#pragma mark -
#pragma mark Input
#import "CGPixelImageInput.h"
#import "CGPixelRawDataInput.h"
#import "CGPixelTextureInput.h"
#import "CGPixelPixelBufferInput.h"
#import "CGPixelVideoInput.h"
#import "CGPixelCameraInput.h"

#pragma mark -
#pragma mark Output
#import "CGPixelViewOutput.h"
#import "CGPixelImageOutput.h"
#import "CGPixelRawDataOutput.h"
#import "CGPixelTextureOutput.h"
#import "CGPixelPixelbufferOutput.h"

