//
//  CGPixelUtils.m
//  CGPixel
//
//  Created by Jason on 2021/5/15.
//

#import "CGPixelUtils.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

void glCheckError(char *flag) {
    GLenum error;
    while ((error = glGetError()) != GL_NO_ERROR) {
        switch (error) {
            case GL_NO_ERROR:
                NSLog(@"GL_NO_ERROR: gl success");
                break;
            case GL_INVALID_ENUM:
                NSLog(@"GL_INVALID_ENUM: 为枚举参数指定了不可接受的值");
                break;
            case GL_INVALID_VALUE:
                NSLog(@"GL_INVALID_VALUE: 数字参数超出范围");
                break;
            case GL_INVALID_OPERATION:
                //这个问题有可能是每一次渲染都需要use当前的program和bind当前的fbo, 看下是不是use和fbo被其他地方占用了
                NSLog(@"GL_INVALID_OPERATION: 当前状态下不允许指定的操作");
                break;
            case GL_INVALID_FRAMEBUFFER_OPERATION:
                NSLog(@"GL_INVALID_FRAMEBUFFER_OPERATION: 该命令试图渲染到帧缓冲区或从帧缓冲区读取，而当前绑定的帧缓冲区不是帧缓冲区完成状态, 即glCheckFramebufferStatus的返回值不是GL_FRAMEBUFFER_COMPLETE");
                break;
            case GL_OUT_OF_MEMORY:
                NSLog(@"GL_OUT_OF_MEMORY: 没有足够的内存来执行命令。 在记录此错误之后，GL的状态是未定义的，除了错误标志的状态。");
                break;
            case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
                NSLog(@"GL_OUT_OF_MEMORY: 没有足够的内存来执行命令。 在记录此错误之后，GL的状态是未定义的，除了错误标志的状态。");
                break;
            default:
                NSLog(@"其他gl错误");
                break;
        }
        printf("%s: glError: 0x%X\n", flag, error);
    }
}

@implementation CGPixelUtils

@end
