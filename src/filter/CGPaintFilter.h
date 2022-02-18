//
//  CGPaintFilter.h
//  CGPaint
//
//  Created by CGPaint on 2021/5/13.
//

#import <Foundation/Foundation.h>
#import "CGPaintInput.h"
#import "CGPaintOutput.h"
#import "CGPaintProgram.h"
#import "CGPaintFilterInput.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPaintFilter : CGPaintOutput<CGPaintInput, CGPaintFilterInput>
{
@protected
    CGPaintProgram *_shaderProgram;
    float _value;
}

#pragma mark -
#pragma mark Init
- (instancetype)initWithVertexShader:(NSString *)vertexShader fragmentShader:(NSString *)fragmentShader;

- (instancetype)initWithFragmentShader:(NSString *)fragmentShader;

//颜色范围[0-1]
- (void)setClearColorRed:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alpha;

@property(nonatomic, assign, readonly)CGSize size;

//@property(nonatomic, assign)BOOL enableFrameForImageCapture;

#pragma mark -
#pragma mark 渲染
//根据顶点/纹理渲染
- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;

//通知响应链下游对象
- (void)notifyNextTargetsAboutNewFrameAtTime:(CMTime)frameTime;

#pragma mark -
#pragma mark set
- (void)setValue:(CGFloat)value;

#pragma mark -
#pragma mark 输出结果
//The caller maintains memory
- (CGImageRef)imageFromCurrentFramebuffer;
//The CGPaint maintains memory
- (void)imageFromCurrentFramebuffer:(void(^)(CGImageRef imageRef))callback;

@end

NS_ASSUME_NONNULL_END
