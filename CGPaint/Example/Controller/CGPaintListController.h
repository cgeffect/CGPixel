//
//  CGPaintListController.h
//  CGPaint
//
//  Created by CGPaint on 2021/5/19.
//

#import <UIKit/UIKit.h>
#import "CGPaintController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGPaintListController : UITableViewController

@property(nonatomic, assign)CGRInputType inputType;
@property(nonatomic, strong)NSString *name;

@end

NS_ASSUME_NONNULL_END
