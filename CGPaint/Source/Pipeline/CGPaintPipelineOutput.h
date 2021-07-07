//
//  CGPaintPipelineOutput.h
//  CGPaint
//
//  Created by Jason on 2021/5/16.
//  Copyright © 2021 CGPaint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGPaintFramebuffer.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct _CGRenderTexture {
    GLuint textureId;
    GLuint width;
    GLuint height;
    CGTextureOptions option;
} CGRenderTexture;

@interface CGPaintPipelineOutput : NSObject
{
@protected
    CGPaintFramebuffer *_outputFramebuffer;
}

- (void)glDrawToTexture;

@end

NS_ASSUME_NONNULL_END
