//
//  PW_NFTClassifyViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTClassifyViewController.h"
#import "PW_NFTClassifyCell.h"
#import "PW_AllNFTViewController.h"

@interface PW_NFTClassifyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSArray<PW_NFTClassifyModel *> *dataArr;

@end

@implementation PW_NFTClassifyViewController

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
    [self requestData];
}
- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)requestData {
    if (self.dataArr!=nil&&self.dataArr.count>0) {
        return;
    }
    [self showLoading];
    [self pw_requestNFTApi:NFTSearchCategoryURL params:nil completeBlock:^(id  _Nonnull data) {
        [self dismissLoading];
        self.dataArr = [PW_NFTClassifyModel mj_objectArrayWithKeyValuesArray:data];
        [PW_GlobalData shared].nftClassifyArr = self.dataArr;
        [self.tableView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self dismissLoading];
    }];
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
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NFTClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_NFTClassifyCell.class)];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:NO completion:nil];
    PW_AllNFTViewController *vc = [[PW_AllNFTViewController alloc] init];
    vc.model = self.dataArr[indexPath.row];
    [[PW_APPDelegate getRootCurrentNavc] pushViewController:vc animated:YES];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 130;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 10, 0);
        _tableView.contentOffset = CGPointMake(0, -5);
        [_tableView registerClass:PW_NFTClassifyCell.class forCellReuseIdentifier:NSStringFromClass(PW_NFTClassifyCell.class)];
    }
    return _tableView;
}
- (NSArray<PW_NFTClassifyModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [PW_GlobalData shared].nftClassifyArr;
    }
    return _dataArr;
}

@end
