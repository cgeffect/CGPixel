//
//  CGPixelSourceController.m
//  CGPixel
//
//  Created by Jason on 2021/5/31.
//

#import "CGPixelSourceController.h"
#import "CGPixelListController.h"
#import "CGPixelController.h"
#import "CGPixelVideoController.h"
#import "CGPixelCameraController.h"

@interface CGPixelSourceController ()
{
    NSArray *_inputList;
}
@end

@implementation CGPixelSourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"CGPaint";

    _inputList = @[@"camera input", @"data input", @"image input", @"pixel input", @"video input", @"effect"];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"play" style:UIBarButtonItemStyleDone target:self action:@selector(goAction)];
//    self.navigationItem.rightBarButtonItem = item;
}

- (void)goAction {
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _inputList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSInteger index = [indexPath row];
    cell.textLabel.text = _inputList[index];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = _inputList[indexPath.row];
    if ([type isEqualToString:@"camera input"]) {
        CGPixelCameraController *vc = [[CGPixelCameraController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([type isEqualToString:@"data input"]) {
        CGPixelController *vc = [[CGPixelController alloc] init];
        vc.filterType = CG_FILTER;
        vc.inputType = CG_RAWDATA;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([type isEqualToString:@"image input"]) {
        CGPixelController *vc = [[CGPixelController alloc] init];
        vc.filterType = CG_FILTER;
        vc.inputType = CG_IMAGE;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([type isEqualToString:@"pixel input"]) {
        CGPixelController *vc = [[CGPixelController alloc] init];
        vc.filterType = CG_FILTER;
        vc.inputType = CG_PIXELBUFFER;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([type isEqualToString:@"video input"]) {
        CGPixelVideoController *vc = [[CGPixelVideoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([type isEqualToString:@"effect"]) {
        CGPixelListController *vc = [[CGPixelListController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
