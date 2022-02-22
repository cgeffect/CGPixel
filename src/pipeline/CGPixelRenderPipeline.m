//
//  CGPixelRenderPipeline.m
//  CGPixel
//
//  Created by Jason on 21/3/1.
//

#import "CGPixelRenderPipeline.h"
#import "CGPixelProgram.h"
#import "CGPixelUtils.h"
#import "CGPixelContext.h"
#import <UIKit/UIKit.h>

NSString *const directPassVertexShaderString = CG_SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 aTexCoord;
 
 varying vec2 varyTextCoord;
 
 void main()
 {
    gl_Position = position;
    varyTextCoord = vec2(aTexCoord.x, 1.0 - aTexCoord.y);
 }
 );

NSString *const directPassFragmentShaderString = CG_SHADER_STRING
(
 varying highp vec2 varyTextCoord;
 
 uniform sampler2D uTexture;
 
 void main()
 {
     gl_FragColor = texture2D(uTexture, varyTextCoord);
 }
 );

static const GLfloat imageVertices[] = {
    -1.0f, -1.0f,
    1.0f, -1.0f,
    -1.0f,  1.0f,
    1.0f,  1.0f,
};

GLfloat textureCoordinates[] = {
    0.0f, 0.0f,
    1.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
};

@implementation CGPixelRenderPipeline
{
    CGPixelProgram*        _program;
    CGPixelRenderPipeline* _renderPipline;
    GLint                  _aPosition;
    GLint                  _aTexCoord;
    GLuint                 _uTexture;
    GLuint                 _displayFramebuffer;
    GLuint                 _renderbuffer;
    GLint                  _backingWidth;
    GLint                  _backingHeight;
    CAEAGLLayer *_glLayer;
    CGSize _mLayerSize;   // layer的尺寸，像素值
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)glPrepareDrawToGLLayer:(CAEAGLLayer *)glLayer {
    _glLayer = glLayer;
    _mLayerSize.width = glLayer.frame.size.width * [UIScreen mainScreen].scale;
    _mLayerSize.height = glLayer.frame.size.height * [UIScreen mainScreen].scale;

    BOOL ret = FALSE;
    [self genRenderbuffer];
    [self genFramebuffer];
    _program = [[CGPixelProgram alloc] initWithVertexShaderString:directPassVertexShaderString fragmentShaderString:directPassFragmentShaderString];
    if(_program && [_program link] && [_program validate]) {
//        [_program addAttribute:@"position"];
//        [_program addAttribute:@"inputTextureCoordinate"];
//        aPosition = [_program attributeIndex:@"position"];
//        aTextureCoord = [_program attributeIndex:@"inputTextureCoordinate"];
        
        _aPosition = [_program getAttribLocation:ATTR_POSITION];
        _aTexCoord = [_program getAttribLocation:ATTR_TEXCOORD];
        _uTexture = [_program getUniformLocation:UNIF_TEXTURE];
        ret = TRUE;
    }
    return ret;
}
- (BOOL)genRenderbuffer {
    glGenRenderbuffers(1, &_renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
    EAGLContext *context = [[CGPixelContext sharedRenderContext] context];
    int ret = [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
    if (!ret) {
        NSLog(@"gl attach renderbuffer error");
        return FALSE;
    }

    //layer的宽高
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    if (_backingWidth <= 0 || _backingHeight <= 0) {
        NSLog(@"failed to create fbo size %d %d", _backingWidth, _backingHeight);
        return FALSE;
    }
    return TRUE;
}

- (BOOL)genFramebuffer {
    glGenFramebuffers(1, &_displayFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _displayFramebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderbuffer);
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete framebuffer object %x", status);
        return FALSE;
    }
    return TRUE;
}

- (void)glDraw:(int)inputTex width:(int)width height:(int)height {
    [self glDrawToRenderbuffer:inputTex width:width height:height aspectRatio:0];
}
- (void)glDrawToRenderbuffer:(int)inputTex width:(int)width height:(int)height aspectRatio:(float)aspectRatio {
    CGRect viewPort = [self glPrepareViewport:width height:height];
    int x = (int) viewPort.origin.x;
    int y = (int) viewPort.origin.y;
    int w = (int) viewPort.size.width;
    int h = (int) viewPort.size.height;
    glViewport(x, y, w, h);
    
    [_program use];
    glBindFramebuffer(GL_FRAMEBUFFER, _displayFramebuffer);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, inputTex);
    glUniform1i(_uTexture, VGX_TEXTURE0);
    
    glEnableVertexAttribArray(_aPosition);
    glVertexAttribPointer(_aPosition, 2, GL_FLOAT, 0, 0, imageVertices);
    glEnableVertexAttribArray(_aTexCoord);
    glVertexAttribPointer(_aTexCoord, 2, GL_FLOAT, 0, 0, textureCoordinates);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(self->_aTexCoord);
    glDisableVertexAttribArray(self->_aPosition);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
    [[[CGPixelContext sharedRenderContext] context] presentRenderbuffer:GL_RENDERBUFFER];
    
    glBindFramebuffer(GL_FRAMEBUFFER, GL_NONE);
    glBindTexture(GL_TEXTURE_2D, GL_NONE);
    [_program unuse];
}

#pragma mark private
- (CGRect)glPrepareViewport:(NSUInteger)texWidth height:(NSUInteger)texHeight {
    if (texWidth == 0 || texHeight == 0) {
        return CGRectZero;
    }
    int x, y, w, h;
    int layerW = (int) self->_mLayerSize.width;
    int layerH = (int) self->_mLayerSize.height;
    float ratio_tex = (float) texHeight / texWidth;
    float ratio_layer = (float)layerH / (float)layerW;
    if (ratio_tex > ratio_layer) {
        h = (int) layerH;
        w = (int) (layerH / ratio_tex);
    } else {
        w = (int) layerW;
        h = (int) (layerW * ratio_tex);
    }
    x = ((int) layerW - w) / 2;
    y = ((int) layerH - h) / 2;
    return CGRectMake(x, y, w, h);
}

- (void)dealloc
{
    if (_displayFramebuffer) {
        glDeleteFramebuffers(1, &_displayFramebuffer);
        _displayFramebuffer = GL_NONE;
        glCheckError("glDeleteFramebuffers");
    }
    
    if (_renderbuffer) {
        glDeleteRenderbuffers(1, &_renderbuffer);
        _renderbuffer = GL_NONE;
        glCheckError("glDeleteRenderbuffers");
    }
}
@end
