# CGPaint
CGPaint 是一个适用于 iOS 的GPU加速OpenGL处理库<br>

SDK 的 Github 地址：https://github.com/cgeffect/CGPaint

感谢 GPUImage https://github.com/BradLarson/GPUImage

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

## 未来计划
1. 支持相机预览/录制
3. 支持视频编码

