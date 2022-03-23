//
//  CGPixelController.h
//  CGPixel
//
//  Created by Jason on 2021/5/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    CG_FILTER = 0,
    CG_SOUL,
    CG_SHAKE,
    CG_GLITCH,
    CG_RADIAL_FAST_BLUR,
    CG_RADIAL_SCALE_BLUR,
    CG_RADIAL_ROTATE_BLUR,
    CG_VORTEX,
    CG_SKETCH,
    CG_MOSAIC,
    CG_DOT_MOSAIC,
    CG_CARTOON,
    CG_NUMFILTERS
} CGRFilterType;

typedef enum {
    CG_TEXTURE,
    CG_RAWDATA,
    CG_IMAGE,
    CG_PIXELBUFFER,
    CG_VIDEO
} CGRInputType;

@interface CGPixelController : UIViewController
@property(nonatomic, assign)CGRFilterType filterType;
@property(nonatomic, assign)CGRInputType inputType;
@end

NS_ASSUME_NONNULL_END
