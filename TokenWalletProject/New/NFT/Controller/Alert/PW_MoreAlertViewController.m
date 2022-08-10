//
//  PW_MoreAlertViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MoreAlertViewController.h"
#import "PW_MoreAlertCell.h"

@interface PW_MoreAlertViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;

@end

@implementation PW_MoreAlertViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor g_maskColor];
    [self clearBackground];
    [self makeViews];
}
- (void)show {
    [[PW_APPDelegate getRootCurrentNavc] presentViewController:self animated:NO completion:nil];
}
- (void)closeAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self closeAction];
}
- (void)makeViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(PW_NavStatusHeight);
        make.right.offset(-12);
        make.width.mas_equalTo(145);
        make.height.mas_equalTo(self.dataArr.count*52+12);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_MoreAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_MoreAlertCell.class)];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self closeAction];
    PW_MoreAlertModel *model = self.dataArr[indexPath.row];
    if (model.didClick) {
        model.didClick(model);
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 52;
        _tableView.contentInset = UIEdgeInsetsMake(6, 0, 6, 0);
        _tableView.scrollEnabled = NO;
        [_tableView setCornerRadius:10];
        _tableView.backgroundColor = [UIColor g_bgColor];
        [_tableView registerClass:PW_MoreAlertCell.class forCellReuseIdentifier:NSStringFromClass(PW_MoreAlertCell.class)];
    }
    return _tableView;
}

@end
