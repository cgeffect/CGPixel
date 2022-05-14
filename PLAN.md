# CGPixel

现代最新版的一些图形api, 包括vulkan/metal 都有相同的设计理念, opengl是面向过程的, metal是面向对象的, 最要命的是opengl天生不适合多线程并发, 线程和上下文绑定, opengl在这一点上很容易出错 
接下来两个计划:
1. GL线程单独抽离出来, 和渲染完全分开
2. 把opengl的渲染流程改成和metal相似

https://github.com/LinBinghe/XMedia
https://github.com/wangyijin/GPUImage-x
