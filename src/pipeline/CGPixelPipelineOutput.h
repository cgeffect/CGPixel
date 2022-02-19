//
//  CGPixelPipelineOutput.h
//  CGPixel
//
//  Created by Jason on 2021/5/16.
//  Copyright © 2021 CGPixel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGPixelFramebuffer.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct _CGRenderTexture {
    GLuint textureId;
    GLuint width;
    GLuint height;
    CGTextureOptions option;
} CGRenderTexture;

@interface CGPixelPipelineOutput : NSObject
{
@protected
    CGPixelFramebuffer *_outputFramebuffer;
}

- (void)glDrawToTexture;

@end

NS_ASSUME_NONNULL_END
