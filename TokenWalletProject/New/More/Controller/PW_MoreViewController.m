//
//  PW_MoreViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MoreViewController.h"
#import "PW_MoreModel.h"
#import "PW_MoreCell.h"
#import "PW_MessageCenterViewController.h"
#import "PW_ShareAppTool.h"
#import "PW_WebViewController.h"
#import "PW_AboutUsViewController.h"
#import "PW_SetUpViewController.h"
#import "PW_AddressBookViewController.h"
#import "PW_NetworkManageViewController.h"
#import "PW_WalletManageViewController.h"
#import "PW_AppLockViewController.h"

@interface PW_MoreViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_MoreModel *> *dataArr;

@end

@implementation PW_MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:@"" leftTitle:LocalizedStr(@"tabbar_more") rightImg:@"icon_noti" rightAction:@selector(notiAction)];
    self.leftBtn.titleLabel.font = [UIFont pw_semiBoldFontOfSize:21];
    [self buildData];
    [self makeViews];
}
- (void)notiAction {
    PW_MessageCenterViewController *vc = [PW_MessageCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)buildData {
    __weak typeof(self) weakSelf = self;
    PW_MoreModel *walletModel = [PW_MoreModel MoreIconName:@"icon_more_wallet" title:LocalizedStr(@"text_walletManage") actionBlock:^(PW_MoreModel * _Nonnull model) {
        PW_WalletManageViewController *vc = [[PW_WalletManageViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    PW_MoreModel *networkModel = [PW_MoreModel MoreIconName:@"icon_more_network" title:LocalizedStr(@"text_networkManage") actionBlock:^(PW_MoreModel * _Nonnull model) {
        PW_NetworkManageViewController *vc = [[PW_NetworkManageViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    PW_MoreModel *lockModel = [PW_MoreModel MoreIconName:@"icon_more_lock" title:LocalizedStr(@"text_appLock") actionBlock:^(PW_MoreModel * _Nonnull model) {
        PW_AppLockViewController *vc = [[PW_AppLockViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    PW_MoreModel *addressBookModel = [PW_MoreModel MoreIconName:@"icon_more_addressBook" title:LocalizedStr(@"text_addressBook") actionBlock:^(PW_MoreModel * _Nonnull model) {
        PW_AddressBookViewController *vc = [[PW_AddressBookViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    PW_MoreModel *instructionsModel = [PW_MoreModel MoreIconName:@"icon_more_instructions" title:LocalizedStr(@"text_instructions") actionBlock:^(PW_MoreModel * _Nonnull model) {
        [weakSelf openWebTitle:model.title urlStr:WalletUseDirectionsUrl];
    }];
    PW_MoreModel *adviceModel = [PW_MoreModel MoreIconName:@"icon_more_advice" title:LocalizedStr(@"text_suggestionsFeedback") actionBlock:^(PW_MoreModel * _Nonnull model) {
        [weakSelf openWebTitle:model.title urlStr:WalletFeedbackUrl];
    }];
    PW_MoreModel *agreementModel = [PW_MoreModel MoreIconName:@"icon_more_agreement" title:LocalizedStr(@"text_userAgreement") actionBlock:^(PW_MoreModel * _Nonnull model) {
        [weakSelf openWebTitle:model.title urlStr:WalletUserAgreementUrl];
    }];
    PW_MoreModel *aboutModel = [PW_MoreModel MoreIconName:@"icon_more_abount" title:LocalizedStr(@"text_aboutUs") actionBlock:^(PW_MoreModel * _Nonnull model) {
        PW_AboutUsViewController *vc = [[PW_AboutUsViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    PW_MoreModel *setupModel = [PW_MoreModel MoreIconName:@"icon_more_setup" title:LocalizedStr(@"text_setup") actionBlock:^(PW_MoreModel * _Nonnull model) {
        PW_SetUpViewController *vc = [[PW_SetUpViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    PW_MoreModel *shareModel = [PW_MoreModel MoreIconName:@"icon_more_share" title:LocalizedStr(@"text_shareApp") actionBlock:^(PW_MoreModel * _Nonnull model) {
        [PW_ShareAppTool showShareApp];
    }];
    [self.dataArr addObjectsFromArray:@[walletModel,networkModel,lockModel,addressBookModel,instructionsModel,adviceModel,agreementModel,aboutModel,setupModel,shareModel]];
    [self.tableView reloadData];
}
- (void)openWebTitle:(NSString *)title urlStr:(NSString *)urlStr {
    PW_WebViewController *webVc = [[PW_WebViewController alloc] init];
    webVc.titleStr = title;
    webVc.urlStr = urlStr;
    [self.navigationController pushViewController:webVc animated:YES];
}
- (void)makeViews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.bottom.right.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.bottom.right.offset(0);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_MoreCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_MoreModel *model = self.dataArr[indexPath.row];
    if (model.actionBlock) {
        model.actionBlock(model);
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, SafeBottomInset, 0);
        [_tableView registerClass:[PW_MoreCell class] forCellReuseIdentifier:@"PW_MoreCell"];
    }
    return _tableView;
}
- (NSMutableArray<PW_MoreModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
