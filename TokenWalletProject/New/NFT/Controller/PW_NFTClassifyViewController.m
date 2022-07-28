//
//  PW_NFTClassifyViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTClassifyViewController.h"
#import "PW_NFTClassifyCell.h"

@interface PW_NFTClassifyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;

@end

@implementation PW_NFTClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor g_maskColor];
    [self clearBackground];
    [self makeViews];
}
- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)makeViews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(60);
        make.left.right.bottom.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    UIView *headerView = [[UIView alloc] init];
    [contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24);
        make.left.offset(30);
        make.right.offset(-35);
        make.height.mas_equalTo(25);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_classify") fontSize:15 textColor:[UIColor g_textColor]];
    [headerView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.offset(0);
    }];
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:self action:@selector(closeAction)];
    [headerView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.bottom.offset(0);
    }];
    [contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(70);
        make.left.right.bottom.offset(0);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NFTClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_NFTClassifyCell.class)];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 130;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
        _tableView.contentOffset = CGPointMake(0, -5);
        [_tableView registerClass:PW_NFTClassifyCell.class forCellReuseIdentifier:NSStringFromClass(PW_NFTClassifyCell.class)];
    }
    return _tableView;
}

@end
