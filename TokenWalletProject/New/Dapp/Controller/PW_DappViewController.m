//
//  PW_DappViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappViewController.h"
#import "PW_ScanTool.h"
#import "PW_SearchDappViewController.h"
#import <SDCycleScrollView.h>
#import "PW_DappBrowserCell.h"
#import "PW_DappBrowserModel.h"
#import "PW_TitleHeaderView.h"
#import "PW_SegmentedHeaderView.h"
#import "PW_DappBanner2Cell.h"
#import "PW_WebViewController.h"
#import "PW_Web3ViewController.h"
#import "PW_DappFavoritesViewController.h"
#import "PW_DappRecentBrowseViewController.h"
#import "PW_WalletView.h"
#import "PW_DappCell.h"
#import "PW_DappChainBrowserCell.h"

@interface PW_DappViewController () <SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITextField *searchTf;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *sdScrollView;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) PW_DappBrowserModel *model;

@property (nonatomic, copy) NSArray *dappRecentBrowseArr;

@property (nonatomic, assign) NSInteger section1Idx;

@end

@implementation PW_DappViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:@"" rightImg:@"icon_scan_white" rightAction:@selector(scanAction)];
    [self setupNavBgPurple];
    [self makeViews];
    [self requestData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.tableView.mj_header beginRefreshing];
}
- (void)scanAction {
    [[PW_ScanTool shared] showScanWithResultBlock:^(NSString * _Nonnull result) {
        PW_SearchDappViewController *vc = [[PW_SearchDappViewController alloc] init];
        vc.searchStr = result;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
- (void)searchAction {
    PW_SearchDappViewController *vc = [[PW_SearchDappViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dappRecentBrowseArr = [[PW_DappManager shared] getList];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)makeViews {
    UIButton *searchBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_searchDapp") fontSize:12 titleColor:[UIColor g_whiteTextColor] imageName:@"icon_search_white" target:self action:@selector(searchAction)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"icon_search_bg"] forState:UIControlStateNormal];
    searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.navContentView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-60);
        make.height.offset(40);
        make.centerY.offset(0);
    }];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.right.bottom.offset(0);
    }];
}
- (void)requestData {
    [self pw_requestApi:WalletHomeMain params:nil completeBlock:^(id  _Nonnull data) {
        [self.tableView.mj_header endRefreshing];
        self.model = [PW_DappBrowserModel mj_objectWithKeyValues:data];
        self.sdScrollView.imageURLStringsGroup = [self.model.banner_1_1 valueForKeyPath:@"imgH5"];
        [self.tableView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)openWebWithTitle:(NSString *)title urlStr:(NSString *)urlStr {
    PW_WebViewController *webVc = [[PW_WebViewController alloc] init];
    webVc.titleStr = title;
    webVc.urlStr = urlStr;
    [self.navigationController pushViewController:webVc animated:YES];
}
- (void)openWeb3WithModel:(PW_DappModel *)model {
    if ([model.chainId isNoEmpty]&&![model.chainId isEqualToString:User_manager.currentUser.current_chainId]) {
        [PW_TipTool showDappWalletNotSupportedWithModel:model sureBlock:^{
            [PW_WalletView show];
        }];
    }else{
        [PW_TipTool showDappDisclaimerUrlStr:model.appUrl sureBlock:^{
            PW_Web3ViewController *webVc = [[PW_Web3ViewController alloc] init];
            webVc.model = model;
            [self.navigationController pushViewController:webVc animated:YES];
        }];
    }
}
#pragma mark - delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    PW_DappModel *model = self.model.dappTop[index];
    [self openWeb3WithModel:model];
}
#pragma mark - tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            if (self.section1Idx==0) {//hot
                PW_DappCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_DappCell"];
                if (self.model.dappTop.count>4) {
                    cell.dataArr = [self.model.dappTop subarrayWithRange:NSMakeRange(0, 3)];
                }else{
                    cell.dataArr = self.model.dappTop;
                }
                cell.clickBlock = ^(PW_DappModel * _Nonnull model) {
                    [weakSelf openWeb3WithModel:model];
                };
                return cell;
            }
            PW_DappBrowserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_DappBrowserCell"];
            if (self.section1Idx==1) {//favorites
                cell.dataArr = [[PW_DappFavoritesManager shared] getList];
            }else{
                cell.dataArr = self.dappRecentBrowseArr;
            }
            cell.clickBlock = ^(PW_DappModel * _Nonnull model, NSArray<PW_DappModel *> * _Nonnull dataArr) {
                if (model.isMore) {
                    if (self.section1Idx==1) {
                        PW_DappFavoritesViewController *vc = [[PW_DappFavoritesViewController alloc] init];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else if (self.section1Idx==2) {
                        PW_DappRecentBrowseViewController *vc = [[PW_DappRecentBrowseViewController alloc] init];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                }else{
                    [weakSelf openWeb3WithModel:model];
                }
            };
            return cell;
        }else{
            PW_DappBanner2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_DappBanner2Cell"];
            cell.dataArr = self.model.banner_2_3;
            cell.clickBlock = ^(PW_BannerModel * _Nonnull model) {
                [weakSelf openWebWithTitle:model.title urlStr:model.clickUrl];
            };
            return cell;
        }
    }
    if (indexPath.section==1) {
        PW_DappCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_DappCell"];
        cell.dataArr = self.model.dapp;
        cell.clickBlock = ^(PW_DappModel * _Nonnull model) {
            [weakSelf openWeb3WithModel:model];
        };
        return cell;
    }
    PW_DappChainBrowserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_DappChainBrowserCell"];
    cell.dataArr = self.model.browser;
    cell.clickBlock = ^(PW_DappChainBrowserModel * _Nonnull model) {
        [weakSelf openWebWithTitle:model.appName urlStr:model.appUrl];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 100;
        }
        return [PW_DappBanner2Cell getItemSize].height;
    }
    if (indexPath.section==1) {
        NSArray *dataArr = self.model.dapp;
        if (dataArr) {
            return [PW_DappCell getHeightWithItemCount:dataArr.count];
        }
    }
    if (indexPath.section==2) {
        NSArray *dataArr = self.model.browser;
        if (dataArr) {
            return [PW_DappChainBrowserCell getHeightWithItemCount:dataArr.count];
        }
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        PW_SegmentedHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PW_SegmentedHeaderView"];
        [view configurationItems:@[@"Hot",LocalizedStr(@"text_favorites"),LocalizedStr(@"text_browse")]];
        view.selectedIndex = self.section1Idx;
        __weak typeof(self) weakSelf = self;
        view.clickBlock = ^(NSInteger idx) {
            weakSelf.section1Idx = idx;
            [weakSelf.tableView reloadData];
        };
        return view;
    }else{
        PW_TitleHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PW_TitleHeaderView"];
        if (section==1) {
            view.title = @"Dapp";
        }else{
            view.title = @"Browser";
        }
        return view;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 75;
    }
    return 50;
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PW_DappBrowserCell class] forCellReuseIdentifier:@"PW_DappBrowserCell"];
        [_tableView registerClass:[PW_DappBanner2Cell class] forCellReuseIdentifier:@"PW_DappBanner2Cell"];
        [_tableView registerClass:[PW_DappCell class] forCellReuseIdentifier:@"PW_DappCell"];
        [_tableView registerClass:[PW_DappChainBrowserCell class] forCellReuseIdentifier:@"PW_DappChainBrowserCell"];
        [_tableView registerClass:[PW_SegmentedHeaderView class] forHeaderFooterViewReuseIdentifier:@"PW_SegmentedHeaderView"];
        [_tableView registerClass:[PW_TitleHeaderView class] forHeaderFooterViewReuseIdentifier:@"PW_TitleHeaderView"];
        _tableView.rowHeight = 70;
        _tableView.sectionHeaderHeight = 55;
        _tableView.sectionFooterHeight = 1;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 160)];
        UIView *bodyView = [[UIView alloc] init];
        bodyView.layer.cornerRadius = 8;
        bodyView.backgroundColor = [UIColor g_bgColor];
        [bodyView setShadowColor:[UIColor g_shadowGrayColor] offset:CGSizeMake(0, 3) radius:8];
        [_headerView addSubview:bodyView];
        [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.bottom.offset(-10);
            make.left.offset(36);
            make.right.offset(-36);
        }];
        [bodyView addSubview:self.sdScrollView];
        [self.sdScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(2);
            make.right.bottom.offset(-2);
        }];
    }
    return _headerView;
}
- (SDCycleScrollView *)sdScrollView {
    if (!_sdScrollView) {
        _sdScrollView = [[SDCycleScrollView alloc] init];
        _sdScrollView.placeholderImage = [UIImage imageNamed:@""];
        _sdScrollView.delegate = self;
        _sdScrollView.autoScrollTimeInterval = 3;
        _sdScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _sdScrollView.currentPageDotColor = [UIColor g_primaryColor];
        _sdScrollView.pageDotColor = [UIColor g_bgColor];
        _sdScrollView.backgroundColor = [UIColor g_grayBgColor];
        _sdScrollView.layer.masksToBounds = YES;
        _sdScrollView.layer.cornerRadius = 8;
    }
    return _sdScrollView;
}

@end
