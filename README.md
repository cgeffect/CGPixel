# CGPaint
基于OpenGL ES的图像和视频处理的iOS框架

框架设计参考GPUImage https://github.com/BradLarson/GPUImage

![image](https://user-images.githubusercontent.com/15692322/124691103-da010180-df0d-11eb-8e20-e6d9791ff708.png)

输入支持类型
1. CGPaintImageInput(图片)
2. CGPaintPixelBufferInput(CVPixelbufferRef)
3. CGPaintRawDataInput(Uint8 *)
4. CGPaintTextureInput(纹理ID)
5. CGPaintVideoInput(视频)

输出支持类型
1. CGPaintImageOutput(图片)
2. CGPaintPixelBufferOutput(CVPixelbufferRef)
4. CGPaintRawDataOutput(Uint8 *)
5. CGPaintTextureOutput(纹理ID)
6. CGPaintVideoOutput(视频)

``` 
UIImage *sourceImage = [UIImage imageNamed:@"rgba"];
CGPaintImageInput *inputSource = [[CGPaintImageInput alloc] initWithImage:sourceImage];
CGPaintFilter *filter = [[CGPaintFilter alloc] init];
CGPaintViewOutput * paintview = [[CGPaintViewOutput alloc] initWithFrame:frame];

[inputSource addTarget:filter];
[filter addTarget:paintview];
[inputSource requestRender];
```
