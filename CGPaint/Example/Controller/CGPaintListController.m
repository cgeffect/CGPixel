//
//  CGPaintListController.m
//  CGPaint
//
//  Created by CGPaint on 2021/5/19.
//

#import "CGPaintListController.h"
#import "CGPaintController.h"
#import "CGPaintVideoController.h"

@interface CGPaintListController ()

@end

@implementation CGPaintListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = _name;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CG_NUMFILTERS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSInteger index = [indexPath row];
    switch (index) {
        case CG_FILTER: cell.textLabel.text = @"原图"; break;
        case CG_SOUL: cell.textLabel.text = @"灵魂出窍"; break;
        case CG_SHAKE: cell.textLabel.text = @"摇动"; break;
        case CG_GLITCH: cell.textLabel.text = @"毛刺"; break;
        case CG_RADIAL_FAST_BLUR: cell.textLabel.text = @"快速径向模糊"; break;
        case CG_RADIAL_SCALE_BLUR: cell.textLabel.text = @"径向缩放模糊"; break;
        case CG_RADIAL_ROTATE_BLUR: cell.textLabel.text = @"径向旋转模糊"; break;
        case CG_VORTEX: cell.textLabel.text = @"旋涡"; break;
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_inputType == CG_VIDEO) {
        CGPaintVideoController *vc = [[CGPaintVideoController alloc] init];
        vc.filterType = (CGRFilterType)indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CGPaintController *vc = [[CGPaintController alloc] init];
        vc.filterType = (CGRFilterType)indexPath.row;
        vc.inputType = _inputType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
