//
//  CGPaintViewOutput.h
//  CGPaint
//
//  Created by Jason on 21/3/3.
//

#import <UIKit/UIKit.h>
#import "CGPaintContext.h"
#import "CGPaintInput.h"

//凡是需要输入纹理对象的节点都是Input类型。
@interface CGPaintViewOutput : UIView<CGPaintInput>

- (void)setClearColorRed:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alpha;

@end
