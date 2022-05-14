//
//  CCGPUImageStickerFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2020/4/12.
//  Copyright © 2020 Selfie. All rights reserved.
//

#import "CCGPUImageStickerFilter.h"

NSString * const kCCGPUImageStickerFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 uniform sampler2D inputStickerTexture;


 vec2 mapVec(vec2 vec, float sacle, vec2 center) {
     vec2 uv = vec;
     float t = 5.0;
     float xOffset = center.x;
     float yOffset = center.y;

     uv.x = uv.x - xOffset;
     uv.y = uv.y - yOffset;
     uv = uv * t;
     vec2 rs = uv + vec2(xOffset, yOffset);
     return rs;
 }

 void main()
 {
     vec2 rs = mapVec(textureCoordinate, 5.0, vec2(0.6, 0.7));
     
     vec3 result;
     if (rs.x > 0.0 && rs.x < 1.0 && rs.y > 0.0 && rs.y < 1.0) {
         result = texture2D(inputStickerTexture, rs).rgb;
     } else {
         result = texture2D(inputImageTexture, textureCoordinate).rgb;
     }
     gl_FragColor = vec4(result, 1.0);

 }
 );

@implementation CCGPUImageStickerFilter

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kCCGPUImageStickerFilterShaderString];
    return self;
}

//重写initializeAttributes增加自己的attribute属性
- (void)initializeAttributes {
    [super initializeAttributes];
    
//    [filterProgram addAttribute:@"flag"];
}

//重写initWithVertexShaderString:fragmentShaderString:，在该方法中调用runSynchronouslyOnVideoProcessingQueue获取内建变量的位置索引
- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString fragmentShaderFromString:(NSString *)fragmentShaderString {
    if (!(self = [super initWithVertexShaderFromString:vertexShaderString fragmentShaderFromString:fragmentShaderString])) {
        return nil;
    }
    
    runSynchronouslyOnVideoProcessingQueue(^{
//        _flagSlot = [filterProgram attributeIndex:@"flag"];
    });
    
    return self;
}

//重写renderToTextureWithVertices:textureCoordinates:，在这个方法中画自己想要画的东西
- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates {
    
    [super renderToTextureWithVertices:vertices textureCoordinates:textureCoordinates];
//
//    static GLfloat vertices2[] = {
//        -0.25, 0.25,   1.0,  // 左上
//        -0.25, -0.25,  1.0,  // 左下
//        0.25, 0.25,    1.0,  // 右上
//        0.25, -0.25,   1.0,  // 右下
//    };
//
//    const GLbyte *pointer2 = (const GLbyte*)vertices2;
//
//    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, pointer2);
//    glVertexAttribPointer(_flagSlot, 1, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, pointer2 + sizeof(GLfloat) * 2);
//    glEnableVertexAttribArray(_flagSlot);
//    glDrawArrays(GL_POINTS, 0, 4);
//
//    glDisableVertexAttribArray(_flagSlot);
}

@end
