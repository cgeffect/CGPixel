//
//  CCGPUImageBaseTwoFilter.m
//  CCBeautifulCamera
//
//  Created by 王腾飞 on 2020/4/13.
//  Copyright © 2020 Selfie. All rights reserved.
//

#import "CCGPUImageBaseTwoFilter.h"

@implementation CCGPUImageBaseTwoFilter

- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString
            fragmentShaderFromString:(NSString *)fragmentShaderString {
    self = [super initWithVertexShaderFromString:vertexShaderString
                        fragmentShaderFromString:fragmentShaderString];
   
    self.timeUniform = [filterProgram uniformIndex:@"time"];
    self.time = 0.0f;
    
    return self;
}

- (void)setTime:(CGFloat)time {
    _time = time;
    
    [self setFloat:time forUniform:self.timeUniform program:filterProgram];
}

- (void)setTimeValue:(CGFloat)time {
    _time = time;
}


- (GLubyte *)getImageDataWithImage:(UIImage *)image {
    //1、将 UIImage 转换为 CGImageRef
     CGImageRef spriteImage = image.CGImage;
     
     //判断图片是否获取成功
     if (!spriteImage) {
         NSLog(@"Failed to load image %@", image);
         exit(1);
     }
     
     //2、读取图片的大小，宽和高
     size_t width = CGImageGetWidth(spriteImage);
     size_t height = CGImageGetHeight(spriteImage);
     
     //3.获取图片字节数 宽*高*4（RGBA）
     GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
     
     //4.创建上下文
     /*
      参数1：data,指向要渲染的绘制图像的内存地址
      参数2：width,bitmap的宽度，单位为像素
      参数3：height,bitmap的高度，单位为像素
      参数4：bitPerComponent,内存中像素的每个组件的位数，比如32位RGBA，就设置为8
      参数5：bytesPerRow,bitmap的每一行的内存所占的比特数
      参数6：colorSpace,bitmap上使用的颜色空间
      参数7：kCGImageAlphaPremultipliedLast：RGBA
      */
     
     size_t bitsPerComponent = CGImageGetBitsPerComponent(spriteImage);
     size_t bytesPerRow = CGImageGetBytesPerRow(spriteImage);
     CGColorSpaceRef colorSpaceRef = CGImageGetColorSpace(spriteImage);
     CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(spriteImage);
     
     if (bitmapInfo == kCGImageAlphaPremultipliedLast) {
//         NSLog(@"yes");
     }
     CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, bitsPerComponent, bytesPerRow, colorSpaceRef, bitmapInfo);
     

     //5、在CGContextRef上--> 将图片绘制出来
     /*
      CGContextDrawImage 使用的是Core Graphics框架，坐标系与UIKit 不一样。UIKit框架的原点在屏幕的左上角，Core Graphics框架的原点在屏幕的左下角。
      CGContextDrawImage
      参数1：绘图上下文
      参数2：rect坐标
      参数3：绘制的图片
      */
     CGRect rect = CGRectMake(0, 0, width, height);
    
     //6.使用默认方式绘制
     CGContextDrawImage(spriteContext, rect, spriteImage);

     //7、画图完毕就释放上下文
     CGContextRelease(spriteContext);
    return spriteData;
}
@end
