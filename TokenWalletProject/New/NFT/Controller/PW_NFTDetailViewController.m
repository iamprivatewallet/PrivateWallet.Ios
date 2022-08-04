//
//  PW_NFTDetailViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/4.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTDetailViewController.h"
#import "PW_NFTDetailHeaderView.h"
#import "PW_NFTDetailDataSectionHeaderView.h"
#import "PW_NFTDetailOfferSectionHeaderView.h"
#import "PW_NFTDetailDealSectionHeaderView.h"

@interface PW_NFTDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIView *navContentView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) PW_NFTDetailHeaderView *headerView;
@property (nonatomic, assign) NSInteger segmentIndex;

@end

@implementation PW_NFTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self clearBackground];
    [self makeViews];
}
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)collectAction {
    
}
- (void)shareAction {
    
}
- (void)segmentChange:(NSInteger)index {
    self.segmentIndex = index;
    [self.tableView reloadData];
}
#pragma mark - views
- (void)makeViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_equalTo(PW_NavStatusHeight);
    }];
    [self.navContentView addSubview:self.backBtn];
    [self.navContentView addSubview:self.collectBtn];
    [self.navContentView addSubview:self.shareBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.mas_left).offset(-10);
        make.centerY.offset(0);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
}
#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak typeof(self) weakSelf = self;
    if (self.segmentIndex==0) {
        PW_NFTDetailDataSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(PW_NFTDetailDataSectionHeaderView.class)];
        view.index = self.segmentIndex;
        view.segmentIndexBlock = ^(NSInteger index) {
            [weakSelf segmentChange:index];
        };
        return view;
    }else if (self.segmentIndex==1) {
        PW_NFTDetailOfferSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(PW_NFTDetailOfferSectionHeaderView.class)];
        view.index = self.segmentIndex;
        view.segmentIndexBlock = ^(NSInteger index) {
            [weakSelf segmentChange:index];
        };
        return view;
    }
    PW_NFTDetailDealSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(PW_NFTDetailDealSectionHeaderView.class)];
    view.index = self.segmentIndex;
    view.segmentIndexBlock = ^(NSInteger index) {
        [weakSelf segmentChange:index];
    };
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.segmentIndex==0) {
        return 75;
    }
    return 95;
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:PW_NFTDetailDataSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PW_NFTDetailDataSectionHeaderView.class)];
        [_tableView registerClass:PW_NFTDetailOfferSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PW_NFTDetailOfferSectionHeaderView.class)];
        [_tableView registerClass:PW_NFTDetailDealSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PW_NFTDetailDealSectionHeaderView.class)];
//        [_tableView registerClass:[PW_MarketCell class] forCellReuseIdentifier:@"PW_MarketCell"];
        _tableView.rowHeight = 75;
        _tableView.sectionHeaderHeight = 75;
        _tableView.sectionFooterHeight = 5;
        _tableView.tableHeaderView = self.headerView;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, PW_SafeBottomInset, 0);
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}
- (PW_NFTDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PW_NFTDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 430)];
    }
    return _headerView;
}
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] init];
        [_navView addSubview:self.navContentView];
        [self.navContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.mas_equalTo(44);
        }];
    }
    return _navView;
}
- (UIView *)navContentView {
    if (!_navContentView) {
        _navContentView = [[UIView alloc] init];
    }
    return _navContentView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [PW_ViewTool buttonImageName:@"icon_nav_back" target:self action:@selector(backAction)];
    }
    return _backBtn;
}
- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [PW_ViewTool buttonImageName:@"icon_nav_collect" selectedImage:@"icon_nav_collect_selected" target:self action:@selector(collectAction)];
    }
    return _collectBtn;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [PW_ViewTool buttonImageName:@"icon_nav_share" target:self action:@selector(shareAction)];
    }
    return _shareBtn;
}

@end
