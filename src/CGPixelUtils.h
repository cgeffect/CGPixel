//
//  CGPixelUtils.h
//  CGPixel
//
//  Created by Jason on 2021/5/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

void glCheckError(char *flag);

#define CG_TEXTURE0                                      0x0
#define CG_TEXTURE1                                      0x1
#define CG_TEXTURE2                                      0x2
#define CG_TEXTURE3                                      0x3
#define CG_TEXTURE4                                      0x4
#define CG_TEXTURE5                                      0x5
#define CG_TEXTURE6                                      0x6
#define CG_TEXTURE7                                      0x7
#define CG_TEXTURE8                                      0x8
#define CG_TEXTURE9                                      0x9
#define CG_TEXTURE10                                     0xA
#define CG_TEXTURE11                                     0xB
#define CG_TEXTURE12                                     0xC
#define CG_TEXTURE13                                     0xD
#define CG_TEXTURE14                                     0xE
#define CG_TEXTURE15                                     0xF
#define CG_TEXTURE16                                     0xD0
#define CG_TEXTURE17                                     0xD1
#define CG_TEXTURE18                                     0xD2
#define CG_TEXTURE19                                     0xD3
#define CG_TEXTURE20                                     0xD4
#define CG_TEXTURE21                                     0xD5
#define CG_TEXTURE22                                     0xD6
#define CG_TEXTURE23                                     0xD7
#define CG_TEXTURE24                                     0xD8
#define CG_TEXTURE25                                     0xD9
#define CG_TEXTURE26                                     0xDA
#define CG_TEXTURE27                                     0xDB
#define CG_TEXTURE28                                     0xDC
#define CG_TEXTURE29                                     0xDD
#define CG_TEXTURE30                                     0xDE
#define CG_TEXTURE31                                     0xDF

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
