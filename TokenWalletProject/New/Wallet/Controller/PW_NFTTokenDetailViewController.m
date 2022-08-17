//
//  PW_NFTTokenDetailViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/2.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTTokenDetailViewController.h"
#import "PW_NFTTokenDetailHeaderView.h"
#import "PW_NFTTokenDetailSectionHeaderView.h"
#import "PW_NFTTokenDetailCell.h"
#import "PW_TransferNFTViewController.h"
#import "PW_NFTTradeDetailViewController.h"
#import "PW_ConfirmNFTAlertViewController.h"
#import "PW_NFTDetailViewController.h"

@interface PW_NFTTokenDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) PW_NFTTokenDetailHeaderView *headerView;
@property (nonatomic, strong) UIView *marketSeeView;

@property (nonatomic, strong) PW_NFTDetailModel *detailModel;

@end

@implementation PW_NFTTokenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_tokenDetail")];
    [self clearBackground];
    [self makeViews];
    [self requestData];
}
- (void)marketSeeAction {
    PW_NFTDetailViewController *vc = [[PW_NFTDetailViewController alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)transferAction {
    PW_TransferNFTViewController *vc = [[PW_TransferNFTViewController alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addRemoveMarketAction {
    PW_ConfirmNFTAlertViewController *vc = [[PW_ConfirmNFTAlertViewController alloc] init];
//    vc.titleStr = LocalizedStr(@"text_add");
//    vc.descStr = PW_StrFormat(LocalizedStr(@"text_addNFTMarketTip"),@"");
    vc.titleStr = LocalizedStr(@"text_remove");
    vc.descStr = PW_StrFormat(LocalizedStr(@"text_removeNFTMarketTip"),@"");
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshUI {
//    self.marketSeeView.hidden = self.detailModel.;
    self.headerView.model = self.detailModel;
    [self.tableView reloadData];
}
#pragma mark - api
- (void)requestData {
    User *user = User_manager.currentUser;
    [self showLoading];
    [self pw_requestNFTApi:NFTAssetItemURL params:@{
        @"chainId":user.current_chainId,
        @"tokenId":self.model.tokenId,
        @"assetContract":self.model.assetContract,
        @"address":user.chooseWallet_address,
    } completeBlock:^(id  _Nonnull data) {
        [self dismissLoading];
        self.detailModel = [PW_NFTDetailModel mj_objectWithKeyValues:data];
        [self refreshUI];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self dismissLoading];
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NFTTokenDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_NFTTokenDetailCell.class)];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(PW_NFTTokenDetailSectionHeaderView.class)];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NFTTradeDetailViewController *vc = [[PW_NFTTradeDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat hiddenHeight = 64;
    CGFloat alpha = scrollView.contentOffset.y/hiddenHeight;
    alpha = MIN(1,MAX(0,alpha));
    self.navBar.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
}
#pragma mark - views
- (void)makeViews {
    [self.navContentView addSubview:self.marketSeeView];
    [self.marketSeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.centerY.offset(0);
        make.height.mas_equalTo(26);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.sectionHeaderHeight = 45;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_tableView registerClass:PW_NFTTokenDetailSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PW_NFTTokenDetailSectionHeaderView.class)];
        [_tableView registerClass:PW_NFTTokenDetailCell.class forCellReuseIdentifier:NSStringFromClass(PW_NFTTokenDetailCell.class)];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}
- (PW_NFTTokenDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PW_NFTTokenDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 755)];
        __weak typeof(self) weakSelf = self;
        _headerView.transferBlock = ^{
            [weakSelf transferAction];
        };
        _headerView.addRemoveMarketBlock = ^{
            [weakSelf addRemoveMarketAction];
        };
    }
    return _headerView;
}
- (UIView *)marketSeeView {
    if (!_marketSeeView) {
        _marketSeeView = [[UIView alloc] init];
        _marketSeeView.hidden = YES;
        [_marketSeeView addTapTarget:self action:@selector(marketSeeAction)];
        [_marketSeeView setBorderColor:[UIColor colorWithWhite:1 alpha:0.2] width:1 radius:13];
        UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_marketToSee") fontSize:12 textColor:[UIColor whiteColor]];
        [_marketSeeView addSubview:titleLb];
        UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_triangle_right"]];
        [_marketSeeView addSubview:arrowIv];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.offset(0);
        }];
        [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLb.mas_right).offset(6);
            make.centerY.offset(0);
            make.right.offset(-10);
        }];
    }
    return _marketSeeView;
}

@end
