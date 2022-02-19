//
//  CGPixelViewOutput.h
//  CGPixel
//
//  Created by Jason on 21/3/3.
//

#import <UIKit/UIKit.h>
#import "CGPixelContext.h"
#import "CGPixelInput.h"

//凡是需要输入纹理对象的节点都是Input类型。
@interface CGPixelViewOutput : UIView<CGPixelInput>

- (void)setClearColorRed:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alpha;

@end
