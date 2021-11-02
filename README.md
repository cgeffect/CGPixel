# CGPaint
GPU accelerated processor for iOS based on OpenGL

idea from GPUImage https://github.com/BradLarson/GPUImage

![image](https://user-images.githubusercontent.com/15692322/124691103-da010180-df0d-11eb-8e20-e6d9791ff708.png)

![image](https://user-images.githubusercontent.com/15692322/139862736-b8cb67b0-7b8f-4bb1-9f72-05d7b26d653d.gif)

Input source
1. CGPaintImageInput
2. CGPaintPixelBufferInput<br/>
    support: NV12/32BGRA
3. CGPaintRawDataInput<br/>
    support: NV12/NV12/BGRA/RGBA/I420
4. CGPaintTextureInput
5. CGPaintVideoInput

Output
1. CGPaintImageOutput
2. CGPaintPixelBufferOutput
4. CGPaintRawDataOutput
5. CGPaintTextureOutput
6. CGPaintVideoOutput

``` 
UIImage *sourceImage = [UIImage imageNamed:@"rgba"];
CGPaintImageInput *inputSource = [[CGPaintImageInput alloc] initWithImage:sourceImage];
CGPaintFilter *filter = [[CGPaintFilter alloc] init];
CGPaintViewOutput * paintview = [[CGPaintViewOutput alloc] initWithFrame:frame];

[inputSource addTarget:filter];
[filter addTarget:paintview];
[inputSource requestRender];
```

iPhone simulator not support fast texture upload, please use machine debug

## Future Plan
1. support camerm preview
2. support camera record
3. support video encode

