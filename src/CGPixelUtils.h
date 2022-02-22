//
//  CGPixelUtils.h
//  CGPixel
//
//  Created by Jason on 2021/5/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CGPixelDefine.h"

NS_ASSUME_NONNULL_BEGIN

void glCheckError(char *flag);

#define VGX_TEXTURE0     0x0
#define VGX_TEXTURE1     0x1
#define VGX_TEXTURE2     0x2
#define VGX_TEXTURE3     0x3
#define VGX_TEXTURE4     0x4
#define VGX_TEXTURE5     0x5
#define VGX_TEXTURE6     0x6
#define VGX_TEXTURE7     0x7
#define VGX_TEXTURE8     0x8
#define VGX_TEXTURE9     0x9
#define VGX_TEXTURE10    0xA
#define VGX_TEXTURE11    0xB
#define VGX_TEXTURE12    0xC
#define VGX_TEXTURE13    0xD
#define VGX_TEXTURE14    0xE
#define VGX_TEXTURE15    0xF
#define VGX_TEXTURE16    0xD0
#define VGX_TEXTURE17    0xD1
#define VGX_TEXTURE18    0xD2
#define VGX_TEXTURE19    0xD3
#define VGX_TEXTURE20    0xD4
#define VGX_TEXTURE21    0xD5
#define VGX_TEXTURE22    0xD6
#define VGX_TEXTURE23    0xD7
#define VGX_TEXTURE24    0xD8
#define VGX_TEXTURE25    0xD9
#define VGX_TEXTURE26    0xDA
#define VGX_TEXTURE27    0xDB
#define VGX_TEXTURE28    0xDC
#define VGX_TEXTURE29    0xDD
#define VGX_TEXTURE30    0xDE
#define VGX_TEXTURE31    0xDF

#define CG_STRINGIZE(x) #x
#define CG_STRINGIZE2(x) CG_STRINGIZE(x)
#define CG_SHADER_STRING(text) @ CG_STRINGIZE2(text)

#define ATTR_POSITION @"position"
#define ATTR_TEXCOORD @"aTexCoord"
#define UNIF_TEXTURE @"uTexture"

#define GLTex GLuint

@interface CGPixelUtils : NSObject


@end

NS_ASSUME_NONNULL_END
