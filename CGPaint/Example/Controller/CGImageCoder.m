//
//  CGRImageCoder.m
//  CGPaint
//
//  Created by Jason on 2021/5/20.
//

#import "CGImageCoder.h"

CGColorSpaceRef YYCGColorSpaceGetDeviceRGB(void) {
    static CGColorSpaceRef space;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        space = CGColorSpaceCreateDeviceRGB();
    });
    return space;
}
@implementation CGImageCoder

/*
 kCGImageAlphaPremultipliedFirst所表示的信息
 是否包含 alpha
 如果包含 alpha ，那么 alpha 信息所处的位置，在像素的最低有效位，比如 RGBA ，还是最高有效位，比如 ARGB ；
 如果包含 alpha ，那么每个颜色分量是否已经乘以 alpha 的值，这种做法可以加速图片的渲染时间，因为它避免了渲染时的额外乘法运算。比如，对于 RGB 颜色空间，用已经乘以 alpha 的数据来渲染图片，每个像素都可以避免 3 次乘法运算，红色乘以 alpha ，绿色乘以 alpha 和蓝色乘以 alpha 。
 */
//小端模式ARGB
UInt8 * CGRDecodeImage32LittleARGB1(CGImageRef imageRef, int width, int height) {
    UInt8 * imageData = (UInt8 *) calloc(1, width * height * 4);
    CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
    BOOL hasAlpha = NO;
    if (alphaInfo == kCGImageAlphaPremultipliedLast ||
        alphaInfo == kCGImageAlphaPremultipliedFirst ||
        alphaInfo == kCGImageAlphaLast ||
        alphaInfo == kCGImageAlphaFirst) {
        hasAlpha = YES;
    }
    // BGRA8888 (premultiplied) or BGRX8888
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
    bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, genericRGBColorspace, bitmapInfo);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
    CGContextRelease(context);
    CGColorSpaceRelease(genericRGBColorspace);
    return imageData;
}

//大端模式RGBA
UInt8 * CGRDecodeImage32BigRGBA1(CGImageRef imageRef, int width, int height) {
    UInt8 * imageData = (UInt8 *) calloc(1, width * height * 4);
    CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
//    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
    //颜色格式和存储方式 kCGBitmapByteOrderDefault = kCGBitmapByteOrder32Big
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, genericRGBColorspace, bitmapInfo);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(genericRGBColorspace);
    return imageData;
}

CGImageRef YYCGImageCreateDecodedCopy(CGImageRef imageRef, BOOL decodeForDisplay) {
    if (!imageRef) return NULL;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    if (width == 0 || height == 0) return NULL;
    
    if (decodeForDisplay) { //decode with redraw (may lose some precision)
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, YYCGColorSpaceGetDeviceRGB(), bitmapInfo);
        if (!context) return NULL;
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef newImage = CGBitmapContextCreateImage(context);
        CFRelease(context);
        return newImage;
        
    } else {
        CGColorSpaceRef space = CGImageGetColorSpace(imageRef);
        size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
        size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        if (bytesPerRow == 0 || width == 0 || height == 0) return NULL;
        
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        if (!dataProvider) return NULL;
        CFDataRef data = CGDataProviderCopyData(dataProvider); // decode
        if (!data) return NULL;
        
        CGDataProviderRef newProvider = CGDataProviderCreateWithCFData(data);
        CFRelease(data);
        if (!newProvider) return NULL;
        
        CGImageRef newImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, space, bitmapInfo, newProvider, NULL, false, kCGRenderingIntentDefault);
        CFRelease(newProvider);
        return newImage;
    }
}
@end
