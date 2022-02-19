//
//  CGPixelFramebuffer.h
//  CGPixel
//
//  Created by Jason on 21/3/1.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <CoreGraphics/CGGeometry.h>
#import <CoreVideo/CoreVideo.h>

/*
 将纹理对象和帧缓存对 象的创建、绑定、销毁等操作以面向对象的方式封装起来
 */
typedef struct _CGTextureOptions {
    GLenum minFilter;
    GLenum magFilter;
    GLenum wrapS;
    GLenum wrapT;
    GLenum internalFormat;
    GLenum format;
    GLenum type;
} CGTextureOptions;

//该类的所有操作都必须在GL环境中执行
@interface CGPixelFramebuffer : NSObject

@property(nonatomic, assign, readonly)CGSize fboSize;
@property(nonatomic, assign, readonly)GLuint texture;
@property(nonatomic, assign, readonly)BOOL isOnlyGenTexture;
@property(nonatomic, assign)BOOL isActivite;
@property(nonatomic, strong)NSString *hashKey;

//纹理选项(设置纹理参数需要使用)
@property(class, readonly) CGTextureOptions defaultTextureOption;
@property(nonatomic, assign, readonly)CGTextureOptions textureOptions;

//创建FBO和纹理, 使用默认的纹理参数
- (instancetype)initWithSize:(CGSize)framebufferSize onlyTexture:(BOOL)onlyTexture;;

//创建FBO和纹理, 使用自定义的纹理参数
- (instancetype)initWithSize:(CGSize)framebufferSize textureOptions:(CGTextureOptions)fboTextureOptions onlyTexture:(BOOL)onlyTexture;

//通过传进来的纹理和size构造实例
- (instancetype)initWithSize:(CGSize)framebufferSize texture:(GLuint)texture;
- (void)updateWithSize:(CGSize)framebufferSize texture:(GLuint)texture;

- (void)bindFramebuffer;

- (void)unbindFramebuffer;

- (void)bindTexture;

- (void)unbindTexture;

- (void)upload:(GLubyte *)data size:(CGSize)size internalformat:(GLenum)internalformat format:(GLenum)format isOverride:(BOOL)isOverride;

- (CVPixelBufferRef)renderTarget;

- (void)recycle;

@end
