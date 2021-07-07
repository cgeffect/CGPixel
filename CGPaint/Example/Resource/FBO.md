#  FBO

在OpenGL渲染管线中几何数据和纹理经过变换和一些测试处理，最终会被展示到屏幕上。OpenGL渲染管线的最终位置是在帧缓冲区中。帧缓冲区是一系列二维的像素存储数组，包括了颜色缓冲区、深度缓冲区、模板缓冲区以及累积缓冲区。默认情况下OpenGL使用的是窗口系统提供的帧缓冲区。

OpenGL的GL_ARB_framebuffer_object这个扩展提供了一种方式来创建额外的帧缓冲区对象（FBO）。使用帧缓冲区对象，OpenGL可以将原先绘制到窗口提供的帧缓冲区重定向到FBO之中。

和窗口提供的帧缓冲区类似，FBO提供了一系列的缓冲区，包括颜色缓冲区、深度缓冲区和模板缓冲区（需要注意的是FBO中并没有提供累积缓冲区）这些逻辑的缓冲区在FBO中被称为 framebuffer-attachable images说明它们是可以绑定到FBO的二维像素数组。

## FBO中有两类绑定的对象：纹理图像（texture images）和渲染图像（renderbuffer images）。如果纹理对象绑定到FBO，那么OpenGL就会执行渲染到纹理（render to texture）的操作，如果渲染对象绑定到FBO，那么OpenGL会执行离屏渲染(offscreen rendering) 

FBO可以理解为包含了许多挂接点的一个对象，它自身并不存储图像相关的数据，他提供了一种可以快速切换外部纹理对象和渲染对象挂接点的方式，在FBO中必然包含一个深度缓冲区挂接点和一个模板缓冲区挂接点，同时还包含许多颜色缓冲区挂节点（具体多少个受OpenGL实现的影响，可以通过GL_MAX_COLOR_ATTACHMENTS使用glGet查询），FBO的这些挂接点用来挂接纹理对象和渲染对象，这两类对象中才真正存储了需要被显示的数据。FBO提供了一种快速有效的方法挂接或者解绑这些外部的对象，对于纹理对象使用 glFramebufferTexture2D，对于渲染对象使用glFramebufferRenderbuffer 
具体描述参考下图： 

2. 使用方法

2.1 创建FBO

创建FBO的方式类似于创建VBO，使用glGenFramebuffers
```
void glGenFramebuffers( GLsizei n,GLuint *ids);
```   
n:创建的帧缓冲区对象的数量 
ids：保存创建帧缓冲区对象ID的数组或者变量 
其中，ID为0有特殊的含义，表示窗口系统提供的帧缓冲区（默认） 
FBO不在使用之后使用glDeleteFramebuffers删除该FBO

创建FBO之后，在使用之前需要绑定它，使用glBindFramebuffers

```
void glBindFramebuffer(GLenum target, GLuint id)
```

target:绑定的目标，该参数必须设置为 GL_FRAMEBUFFER 
id：由glGenFramebuffers创建的id

2.2 渲染对象

渲染对象是用来绑定的缓冲区对象FBO上做离屏渲染的。它可以让场景直接渲染到这个对象中（而不是到窗口系统中显示），创建它的方法与创建FBO有点类似：
```
void glGenRenderbuffers(GLsizei n, GLuint* ids) 创建
void glDeleteRenderbuffers(GLsizei n, const Gluint* ids) 删除
void glBindRenderbuffer(GLenum target, GLuint id) 绑定 
```
绑定完成之后，需要为渲染对象开辟一块空间，使用下面函数完成：
```
void glRenderbufferStorage(GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
```
target：指定目标，必须设置为GL_RENDERBUFFER 
internalformat：设置图像格式（参考《OpenGL图像格式》） 
width和height：设置渲染对象的长和宽（大小必须小于 GL_MAX_RENDERBUFFER_SIZE）

可以使用glGetRenderbufferparameteriv函数来获取当前绑定的渲染对象
```
void glGetRenderbufferParameteriv(GLenum target, GLenum param, GLint* value)
```
target：参数必须是GL_RENDERBUFFER 
param：取值如下（根据查询的不同选择相应的值）
```
GL_RENDERBUFFER_WIDTH
GL_RENDERBUFFER_HEIGHT
GL_RENDERBUFFER_INTERNAL_FORMAT
GL_RENDERBUFFER_RED_SIZE
GL_RENDERBUFFER_GREEN_SIZE
GL_RENDERBUFFER_BLUE_SIZE
GL_RENDERBUFFER_ALPHA_SIZE
GL_RENDERBUFFER_DEPTH_SIZE
GL_RENDERBUFFER_STENCIL_SIZE
```
2.3 挂接对象到FBO

FBO本身并不包含任何图像存储空间，它需要挂接纹理对象或者渲染对象到FBO，挂接图像对象到FBO使用下面的方式：

2.3.1 挂接2D纹理到FBO
```
glFramebufferTexture2D(GLenum target,
                       GLenum attachmentPoint,
                       GLenum textureTarget,
                       GLuint textureId,
                       GLint  level)
```
target:挂接的目标，必须指定为 GL_FRAMEBUFFER 
attachmentPoint:挂接点位，取值：GL_COLOR_ATTACHMENT0到GL_COLOR_ATTACHMENTn，GL_DEPTH_ATTACHMENT，GL_STENCIL_ATTACHMENT 
对应着上图中颜色缓冲区点位和深度以及模板缓冲区点位 
textureTarget：设置为二维纹理（GL_TEXTURE_2D） 
textureId：纹理对象的ID值（如果设置为0，那么纹理对象从FBO点位上解绑） 
level：mipmap的层级

2.3.2 挂接渲染对象到FBO
```
void glFramebufferRenderbuffer(GLenum target,
                               GLenum attachmentPoint,
                               GLenum renderbufferTarget,
                               GLuint renderbufferId)
```
第一个和第二个参数与挂接到纹理一样，第三个参数必须设置为GL_RENDERBUFFER，第四个参数是渲染对象的ID值。（如果设置为0，那么该渲染对象从当前点位上解绑）

2.4 检查FBO状态

当挂接完成之后，我们在执行FBO下面的操作之前，必须检查一下FBO的状态，使用以下的函数：
```
GLenum glCheckFramebufferStatus(GLenum target)
```
target:取值必须是GL_FRAMEBUFFER，当返回GL_FRAMEBUFFER_COMPLETE时，表示所有状态都正常，否则返回错误信息。


//https://learnopengl-cn.github.io/04%20Advanced%20OpenGL/05%20Framebuffers/
