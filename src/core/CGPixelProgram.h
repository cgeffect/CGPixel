//
//  CGPixelProgram.h
//  CGPixel
//
//  Created by Jason on 21/3/1.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface CGPixelProgram : NSObject

- (instancetype) initWithVertexShaderString:(NSString *)vShaderString fragmentShaderString:(NSString *)fShaderString;

- (void)use;

- (void)unuse;

- (BOOL)link;

- (BOOL)validate;

#pragma mark -
#pragma mark getter
- (GLint)getUniformLocation:(NSString *)name;
- (GLint)getAttribLocation:(NSString *)name;
- (GLuint)attributeIndex:(NSString *)name;
- (void)addAttribute:(NSString *)name;
#pragma mark -
#pragma mark setter
- (void)setUniform1f:(GLint)location x:(GLfloat)x;
- (void)setUniform1i:(GLint)location x:(GLint)x;
- (void)setUniform2f:(GLint)location x:(GLfloat)x y:(GLfloat)y;
- (void)setUniform2i:(GLint)location x:(GLint)x y:(GLint)y;
- (void)setUniform3f:(GLint)location x:(GLfloat)x y: (GLfloat)y z:(GLfloat)z;
- (void)setUniform3i:(GLint)location x:(GLint)x y: (GLint)y z:(GLint)z;
- (void)setUniform4f:(GLint)location x:(GLfloat)x y:(GLfloat)y  z:(GLfloat)z w:(GLfloat)w;
- (void)setUniform4i:(GLint)location x:(GLint)x y:(GLint)y  z:(GLint)z w:(GLint)w;
@end
