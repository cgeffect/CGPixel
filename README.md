# CGPaint
<img width="945" alt="截屏2021-11-27 上午12 08 45" src="https://user-images.githubusercontent.com/15692322/143607523-5e14a01f-6fd7-4e67-a086-87e363b08486.png">
CGPaint 是一个适用于 iOS 的GPU加速OpenGL处理库<br>

SDK 的 Github 地址：https://github.com/cgeffect/CGPaint

感谢 GPUImage https://github.com/BradLarson/GPUImage

主要功能是实现了滤镜链, 简化了GPUImage的功能, 对于初学者更容易理解.

![image](https://user-images.githubusercontent.com/15692322/124691103-da010180-df0d-11eb-8e20-e6d9791ff708.png)

![image](https://user-images.githubusercontent.com/15692322/139862736-b8cb67b0-7b8f-4bb1-9f72-05d7b26d653d.gif)


输入源
1. CGPaintImageInput
2. CGPaintPixelBufferInput<br/>
    support: NV12/32BGRA
3. CGPaintRawDataInput<br/>
    support: NV12/NV12/BGRA/RGBA/I420
4. CGPaintTextureInput
5. CGPaintVideoInput

输出源
1. CGPaintImageOutput
2. CGPaintPixelBufferOutput
4. CGPaintRawDataOutput
5. CGPaintTextureOutput
6. CGPaintVideoOutput

### 代码示例
``` 
UIImage *sourceImage = [UIImage imageNamed:@"rgba"];
CGPaintImageInput *inputSource = [[CGPaintImageInput alloc] initWithImage:sourceImage];
CGPaintFilter *filter = [[CGPaintFilter alloc] init];
CGPaintViewOutput * paintview = [[CGPaintViewOutput alloc] initWithFrame:frame];

[inputSource addTarget:filter];
[filter addTarget:paintview];
[inputSource requestRender];
```

模拟器不支持fast texture upload, 使用真机运行

Metal实现滤镜渲染链[CGMetal](https://github.com/cgeffect/CGMetal)
