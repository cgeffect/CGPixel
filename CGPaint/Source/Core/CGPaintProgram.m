//
//  CGPaintProgram.m
//  CGPaint
//
//  Created by Jason on 21/3/1.
//

#import "CGPaintProgram.h"
#import "CGPaintUtils.h"

@implementation CGPaintProgram {
    NSMutableArray  *attributes;
    NSMutableArray  *uniforms;
    GLuint          program;
    GLuint          vertShader;
    GLuint          fragShader;
}

- (instancetype) initWithVertexShaderString:(NSString *)vShaderString fragmentShaderString:(NSString *)fShaderString
{
    if ((self = [super init])) {
        attributes = [[NSMutableArray alloc] init];
        uniforms = [[NSMutableArray alloc] init];
        program = glCreateProgram();
        
        // Create and compile vertex shader
        if (![self compileShader:&vertShader type:GL_VERTEX_SHADER string:vShaderString]) {
            NSLog(@"Failed to compile vertex shader");
        }
        
        // Create and compile fragment shader
        if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER string:fShaderString]) {
            NSLog(@"Failed to compile fragment shader");
        }
        // Attach Shader to program
        glAttachShader(program, vertShader);
        glAttachShader(program, fragShader);
    }
    return self;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type string:(NSString *)shaderString {
    
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[shaderString UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    
    if (status == GL_TRUE) {
//        NSLog(@"%d: shader compile success", type);
    } else {
        GLint logLength;
        glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0) {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetShaderInfoLog(*shader, logLength, &logLength, log);
            if (shader == &vertShader) {
                NSLog(@" vertex Shader log is : %@", [NSString stringWithFormat:@"%s", log]);
            } else {
                NSLog(@" fragment Shader log is : %@", [NSString stringWithFormat:@"%s", log]);
            }
            free(log);
        }
    }
    return status == GL_TRUE;
}

- (void)use {
    glUseProgram(program);
    glCheckError("use");
}

- (void)unuse {
    glUseProgram(GL_NONE);
    glCheckError("unuse");
}

- (BOOL)link {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    GLint status;
    glLinkProgram(program);
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE) {
        NSLog(@"linked failed, 检查着色器书写内容是否有误");
        return NO;
    }
    if (vertShader) {
        glDeleteShader(vertShader);
        vertShader = 0;
    }
    if (fragShader) {
        glDeleteShader(fragShader);
        fragShader = 0;
    }
    
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"linked success in %f ms", linkTime * 1000.0);
    glCheckError("use");
    return YES;
}

#pragma mark -
#pragma mark validate
- (BOOL)validate;
{
    //日志长度
    GLint logLength;
    
    //验证program
    glValidateProgram(program);
    
    //获取日志长度
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
    
    //日志长度>0
    if (logLength > 0) {
        //获取日志信息
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(program, logLength, &logLength, log);
        NSString *programLog = [NSString stringWithFormat:@"%s", log];
        NSLog(@"program validate failed : %@", programLog);
        free(log);
        return NO;
    } else {
//        NSLog(@"program validate success");
        return YES;
    }
}

- (void)dealloc {
    if (vertShader) {
        glDeleteShader(vertShader);
        glCheckError("CGProgram: glDeleteShader");
    }
    
    if (fragShader) {
        glDeleteShader(fragShader);
        glCheckError("CGProgram: glDeleteShader");
    }
    
    
    if (program) {
        glDeleteProgram(program);
        glCheckError("CGProgram: glDeleteProgram");
    }
}

#pragma mark -
#pragma mark getter
- (void)addAttribute:(NSString *)attributeName {
    if (![attributes containsObject:attributeName]) {
        [attributes addObject:attributeName];
        
        /*
         glGetAttribLocation(GLuint program, const GLchar *name), 该方法允许我们获取系统为我们分配的attribute的索引,
         在glLinkProgram(GLuint program)之后调用, 否则返回-1, 如果attribute未被激活, 即attribute未被使用, 同样返回-1
         
         glBindAttribLocation: glGetAttribLocation是系统帮我们设置好了attribute的索引, 我们只需获取就可以使用了, 而glBindAttribLocation允许手动设置attribute的索引, 必须在glLinkProgram之前调用

         */
        
        glBindAttribLocation(program, (GLuint)[attributes indexOfObject:attributeName], [attributeName UTF8String]);
    }
}

- (GLuint)attributeIndex:(NSString *)attributeName {
    return (GLuint)[attributes indexOfObject:attributeName];
}

- (GLint)getUniformLocation:(NSString *)name {
    GLint loc = glGetUniformLocation(program, name.UTF8String);
    glCheckError("getUniformLocation");
    return loc;
}

- (GLint)getAttribLocation:(NSString *)name {
    GLint loc = glGetAttribLocation(program, name.UTF8String);
    glCheckError("getAttribLocation");
    return loc;
}

#pragma mark -
#pragma mark setter
- (void)setUniform1f:(GLint)location x:(GLfloat)x {
    glUniform1f(location, x);
}
- (void)setUniform1i:(GLint)location x:(GLint)x {
    glUniform1i(location, x);
}
- (void)setUniform2f:(GLint)location x:(GLfloat)x y:(GLfloat)y {
    glUniform2f(location, x, y);
}
- (void)setUniform2i:(GLint)location x:(GLint)x y:(GLint)y {
    glUniform2i(location, x, y);
}
- (void)setUniform3f:(GLint)location x:(GLfloat)x y: (GLfloat)y z:(GLfloat)z {
    glUniform3f(location, x, y, z);
}
- (void)setUniform3i:(GLint)location x:(GLint)x y: (GLint)y z:(GLint)z {
    glUniform3i(location, x, y, z);
}
- (void)setUniform4f:(GLint)location x:(GLfloat)x y:(GLfloat)y  z:(GLfloat)z w:(GLfloat)w {
    glUniform4f(location, x, y, z, w);
}
- (void)setUniform4i:(GLint)location x:(GLint)x y:(GLint)y  z:(GLint)z w:(GLint)w {
    glUniform4i(location, x, y, z, w);
}

@end
