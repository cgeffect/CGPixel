//
//  CGPaintSourceController.m
//  CGPaint
//
//  Created by Jason on 2021/5/31.
//

#import "CGPaintSourceController.h"
#import "CGPaintListController.h"

@interface CGPaintSourceController ()
{
    NSArray *_inputList;
}
@end

@implementation CGPaintSourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"CGPaint";

    _inputList = @[@"texture input", @"data input", @"image input", @"pixel input", @"video input"];
    
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
    CGPaintListController *vc = [[CGPaintListController alloc] init];
    NSString *type = _inputList[indexPath.row];
    if ([type isEqualToString:@"texture input"]) {
        vc.inputType = CG_TEXTURE;
    } else if ([type isEqualToString:@"data input"]) {
        vc.inputType = CG_RAWDATA;
    } else if ([type isEqualToString:@"image input"]) {
        vc.inputType = CG_IMAGE;
    } else if ([type isEqualToString:@"pixel input"]) {
        vc.inputType = CG_PIXELBUFFER;
    } else if ([type isEqualToString:@"video input"]) {
        vc.inputType = CG_VIDEO;
    }
    vc.name = type;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
