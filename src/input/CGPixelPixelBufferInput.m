//
//  CGPixelPixelBufferInput.m
//  CGPixel
//
//  Created by CGPixel on 2021/5/14.
//

#import "CGPixelPixelBufferInput.h"

static const GLfloat imageVertices[] = {
    -1.0f, -1.0f,
    1.0f, -1.0f,
    -1.0f,  1.0f,
    1.0f,  1.0f,
};

static const GLfloat textureCoordinates[] = {
    0.0f, 0.0f,
    1.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
};
NSString *const gl_pix_vert = CG_SHADER_STRING (
    attribute vec4 position;
    attribute vec2 aTexCoord;

    varying lowp vec2 varyTextCoord;
    void main() {
      varyTextCoord = aTexCoord;
      gl_Position = position;
    }
);
NSString *const gl_pix_frag_nv12 = CG_SHADER_STRING (
    precision highp float;
    varying vec2 varyTextCoord;
    uniform sampler2D y_texture;
    uniform sampler2D vu_texture;

    void main()
    {
      vec3 yuv;
      yuv.x = texture2D(y_texture, varyTextCoord).r;
      yuv.yz = texture2D(vu_texture, varyTextCoord).rg;

      float y = yuv.x;
      float u = yuv.y - 0.5;
      float v = yuv.z - 0.5;
        
      float r = y + 1.402 * v;
      float g = y - 0.344 * u - 0.714 * v;
      float b = y + 1.772 * u;
      gl_FragColor = vec4(r, g, b, 1.0);
    }
);

@interface CGPixelPixelBufferInput ()
{
    CGPixelProgram *_shaderProgram;
    //顶点属性,纹理属性
    GLint _position, _aTexCoord;
    
    CVOpenGLESTextureCacheRef _renderTextureCache;
    int _bufferWidth, _bufferHeight;
    CVOpenGLESTextureRef _dstTexture;

    //选择颜色通道
    CVOpenGLESTextureRef _lumaTexture;
    CVOpenGLESTextureRef _chromaTexture;
    GLuint _yTexUniform, _uvTexUniform;
    GLuint _yTex, _uvTex;
}
@end

@implementation CGPixelPixelBufferInput

- (instancetype)initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer format:(CGPixelFormat)format {
    self = [super init];
    if (self) {
//        if ([CGPaintContext supportsFastTextureUpload] == NO) {
//            NSAssert(NO, @"iPhone simulator not support fast texture upload");
//        }
        _bufferWidth = (int) CVPixelBufferGetWidth(pixelBuffer);
        _bufferHeight = (int) CVPixelBufferGetHeight(pixelBuffer);
        runSyncOnSerialQueue(^{
            [[CGPixelContext sharedRenderContext] useAsCurrentContext];
            EAGLContext *_oglContext = [EAGLContext currentContext];
            CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _oglContext, NULL, &self->_renderTextureCache);
            if (err) {
                NSLog(@"CGPaintPixelBufferInput Error at CVOpenGLESTextureCacheCreate %d", err);
            }
            if (format == CGPixelFormatBGRA) {
                GLuint _texId = [self glGenTexIdWithPixelBufferBGRA:pixelBuffer];
                self->_outputFramebuffer = [[CGPixelFramebuffer alloc] initWithSize:CGSizeMake(self->_bufferWidth, self->_bufferHeight) texture:_texId];
            } else if (format == CGPixelFormatNV12) {
                self->_shaderProgram = [[CGPixelProgram alloc] initWithVertexShaderString:gl_pix_vert fragmentShaderString:gl_pix_frag_nv12];
                if (self->_shaderProgram && [self->_shaderProgram link]) {
                    self->_position = [self->_shaderProgram getAttribLocation:ATTR_POSITION];
                    self->_aTexCoord = [self->_shaderProgram getAttribLocation:ATTR_TEXCOORD];
                    self->_yTexUniform = [self->_shaderProgram getUniformLocation:@"y_texture"];
                    self->_uvTexUniform = [self->_shaderProgram getUniformLocation:@"vu_texture"];
                }
               
                [self glGenTexIdWithPixelBuffer420Yp8_CbCr8:pixelBuffer];
                
                self->_outputFramebuffer = [[CGPixelFramebuffer alloc] initWithSize:CGSizeMake(self->_bufferWidth, self->_bufferHeight) onlyTexture:NO];

                [self->_shaderProgram use];
                [self->_outputFramebuffer bindFramebuffer];
                [self drawNV12ToFBO];
                [self->_shaderProgram unuse];
                [self->_outputFramebuffer unbindFramebuffer];
            }
        });
    }
    return self;
}

- (void)updatePixelBuffer:(CVPixelBufferRef)pixelBuffer format:(CGPixelFormat)format {
    _bufferWidth = (int) CVPixelBufferGetWidth(pixelBuffer);
    _bufferHeight = (int) CVPixelBufferGetHeight(pixelBuffer);
    runSyncOnSerialQueue(^{
        [[CGPixelContext sharedRenderContext] useAsCurrentContext];
        if (format == CGPixelFormatBGRA) {
            GLuint _texId = [self glGenTexIdWithPixelBufferBGRA:pixelBuffer];
            [self->_outputFramebuffer updateWithSize:CGSizeMake(self->_bufferWidth, self->_bufferHeight) texture:_texId];
        } else if (format == CGPixelFormatNV12) {
            [self glGenTexIdWithPixelBuffer420Yp8_CbCr8:pixelBuffer];
            [self->_shaderProgram use];
            [self->_outputFramebuffer bindFramebuffer];
            [self drawNV12ToFBO];
            [self->_shaderProgram unuse];
            [self->_outputFramebuffer unbindFramebuffer];
        }
    });
}

- (GLuint)glGenTexIdWithPixelBufferBGRA:(CVPixelBufferRef)pixelBuffer {
    if (!_renderTextureCache) {
        NSLog(@"UFGLPixelBufferToTexture CVOpenGLESTextureCacheRef nil");
        return 0;
    }

    CVReturn err = noErr;
    GLuint texId = 0;
    err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
            _renderTextureCache,
            pixelBuffer,
            NULL,
            GL_TEXTURE_2D,
            GL_RGBA,
            _bufferWidth,
            _bufferHeight,
            GL_BGRA,
            GL_UNSIGNED_BYTE,
            0,
            &_dstTexture);

    if (!_dstTexture || err) {
        NSLog(@"CGPaintPixelBufferInput Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
        return 0;
    } else {
        texId = CVOpenGLESTextureGetName(_dstTexture);
        GLuint target = CVOpenGLESTextureGetTarget(_dstTexture);
        glBindTexture(target, texId);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        CFRelease(_dstTexture);
    }
    CVOpenGLESTextureCacheFlush(_renderTextureCache, 0);
    return texId;
}

- (void)glGenTexIdWithPixelBuffer420Yp8_CbCr8:(CVPixelBufferRef)pixelBuffer {
    if (!_renderTextureCache) {
        NSLog(@"CGPaintPixelBufferInput CVOpenGLESTextureCacheRef nil");
    }
    CVReturn err;
//    size_t planeCount = CVPixelBufferGetPlaneCount(pixelBuffer);
//    NSLog(@"平面个数: %zu", planeCount);
    
    _bufferWidth = (int) CVPixelBufferGetWidth(pixelBuffer);
    _bufferHeight = (int) CVPixelBufferGetHeight(pixelBuffer);

    //Y
    err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                       _renderTextureCache,
                                                       pixelBuffer,
                                                       NULL,
                                                       GL_TEXTURE_2D,
                                                       GL_RED_EXT,
                                                       _bufferWidth,
                                                       _bufferHeight,
                                                       GL_RED_EXT,
                                                       GL_UNSIGNED_BYTE,
                                                       0,
                                                       &_lumaTexture);
    if (err) {
        NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
    }
    
    _yTex = CVOpenGLESTextureGetName(_lumaTexture);
    glBindTexture(CVOpenGLESTextureGetTarget(_lumaTexture), _yTex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    CFRelease(_lumaTexture);
    //UV
    err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                       _renderTextureCache,
                                                       pixelBuffer,
                                                       NULL,
                                                       GL_TEXTURE_2D,
                                                       GL_RG_EXT,
                                                       _bufferWidth / 2,
                                                       _bufferHeight / 2,
                                                       GL_RG_EXT,
                                                       GL_UNSIGNED_BYTE,
                                                       1,
                                                       &_chromaTexture);
    if (err) {
        NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
    }
    _uvTex = CVOpenGLESTextureGetName(_chromaTexture);
    glBindTexture(CVOpenGLESTextureGetTarget(_chromaTexture), _uvTex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    CFRelease(_chromaTexture);
}

- (void)drawNV12ToFBO {
    CGSize size = [_outputFramebuffer fboSize];
    glViewport(0, 0, size.width, size.height);
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _yTex);
    glUniform1i(_yTexUniform, VGX_TEXTURE0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _uvTex);
    glUniform1i(_uvTexUniform, VGX_TEXTURE1);
    
    glEnableVertexAttribArray(self->_position);
    glVertexAttribPointer(self->_position, 2, GL_FLOAT, 0, 0, imageVertices);
    glEnableVertexAttribArray(self->_aTexCoord);
    glVertexAttribPointer(self->_aTexCoord, 2, GL_FLOAT, 0, 0, textureCoordinates);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(self->_position);
    glDisableVertexAttribArray(self->_aTexCoord);
    
    //这个纹理不需要删除吗? 删除会出问题, 难道是ios自己管理?
//    glDeleteTextures(1, &(_yTex));
//    glDeleteTextures(1, &(_uvTex));
}

- (void)requestRender {
    runSyncOnSerialQueue(^{
        [[CGPixelContext sharedRenderContext] useAsCurrentContext];
        for (id<CGPixelInput> currentTarget in self->_targets){
            [currentTarget setInputFramebuffer:self->_outputFramebuffer];
            CMSampleTimingInfo info = {0};
            [currentTarget newFrameReadyAtTime:kCMTimeZero timimgInfo:info];
        }
    });
}
- (void)dealloc
{
    runSyncOnSerialQueue(^{
        [[CGPixelContext sharedRenderContext] useAsCurrentContext];
        if (self->_renderTextureCache) {
            CFRelease(self->_renderTextureCache);
            self->_renderTextureCache = 0;
        }
        self->_outputFramebuffer = nil;
    });
}

@end
