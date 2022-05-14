# CGPixel

<img width="500" alt="截屏2021-11-27 上午12 08 45" src="https://user-images.githubusercontent.com/15692322/154796866-ff3657f1-9154-4b5d-b7d6-b33b44098353.png">

CGPixel 是一个适用于 iOS 的GPU加速OpenGL处理库<br>

SDK 的 Github 地址：https://github.com/cgeffect/CGPixel

感谢 GPUImage https://github.com/BradLarson/GPUImage

![image](https://user-images.githubusercontent.com/15692322/124691103-da010180-df0d-11eb-8e20-e6d9791ff708.png)

![image](https://user-images.githubusercontent.com/15692322/139862736-b8cb67b0-7b8f-4bb1-9f72-05d7b26d653d.gif)


输入源
1. CGPixelImageInput
2. CGPixelPixelBufferInput<br/>
    support: NV12/32BGRA
3. CGPixelRawDataInput<br/>
    support: NV12/NV12/BGRA/RGBA/I420
4. CGPixelTextureInput<br/>
5. CGPixelVideoInput<br/>
6. CGPixelCameraInput<br/>

输出源
1. CGPixelImageOutput<br/>
2. CGPixelPixelBufferOutput<br/>
2. CGPixelViewOutput<br/>
4. CGPixelRawDataOutput<br/>
5. CGPixelTextureOutput<br/>
6. CGPixelVideoOutput<br/>

### 代码示例
``` 
UIImage *sourceImage = [UIImage imageNamed:@"rgba"];
CGPixelImageInput *inputSource = [[CGPixelImageInput alloc] initWithImage:sourceImage];
CGPixelFilter *filter = [[CGPixelFilter alloc] init];
CGPixelViewOutput * paintview = [[CGPixelViewOutput alloc] initWithFrame:frame];

[inputSource addTarget:filter];
[filter addTarget:paintview];
[inputSource requestRender];
```

### 注意
模拟器不支持fast texture upload, 使用真机运行
iOS11以上, Xcode 13及其以上

Metal实现滤镜渲染[CGMetal](https://github.com/cgeffect/CGMetal)

没啥历史包袱建议直接上metal, Api简单, 健壮, 性能强劲!!!

### PLAN
现代最新版的一些图形api, 包括vulkan/metal 都有相同的设计理念, opengl是面向过程的, metal是面向对象的, 最要命的是opengl天生不适合多线程并发, 线程和上下文绑定 
接下来两个计划:
1. GL线程单独抽离出来, 和渲染完全分开
2. 把opengl的渲染流程改成和metal相似
