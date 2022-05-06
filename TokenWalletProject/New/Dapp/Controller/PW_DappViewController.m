//
//  PW_DappViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappViewController.h"
#import "PW_ScanTool.h"
#import "PW_SearchDappCurrencyViewController.h"
#import <SDCycleScrollView.h>
#import "PW_DappBrowserCell.h"
#import "PW_DappBrowserModel.h"
#import "PW_TitlesHeaderView.h"
#import "PW_DappChainCell.h"
#import "PW_DappBanner2Cell.h"
#import "PW_WebViewController.h"
#import "PW_Web3ViewController.h"
#import "PW_DappRecentBrowseViewController.h"
#import "PW_WalletListView.h"

@interface PW_DappViewController () <SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITextField *searchTf;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *sdScrollView;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) PW_DappBrowserModel *model;

@property (nonatomic, copy) NSArray *dappRecentBrowseArr;

@property (nonatomic, assign) NSInteger section1Idx;
@property (nonatomic, assign) NSInteger section2Idx;

@end

@implementation PW_DappViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:@"" rightImg:@"icon_scan" rightAction:@selector(scanAction) isWhiteBg:NO];
    [self makeViews];
    [self requestData];
}
- (void)scanAction {
    [[PW_ScanTool shared] showScanWithResultBlock:^(NSString * _Nonnull result) {
        PW_SearchDappCurrencyViewController *vc = [[PW_SearchDappCurrencyViewController alloc] init];
        vc.searchStr = result;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
- (void)searchAction {
    PW_SearchDappCurrencyViewController *vc = [[PW_SearchDappCurrencyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dappRecentBrowseArr = [[PW_DappManager shared] getList];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)makeViews {
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"first_bg"]];
    [self.view insertSubview:bgIv atIndex:0];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
    }];
    UIButton *searchBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_searchDappCurrency") fontSize:12 titleColor:[UIColor g_grayTextColor] imageName:@"icon_search" target:self action:@selector(searchAction)];
    searchBtn.layer.cornerRadius = 17.5;
    searchBtn.backgroundColor = [UIColor g_bgColor];
    searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.naviBar addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-60);
        make.height.offset(35);
        make.bottom.offset(-5);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
}
- (void)requestData {
    [self.view showLoadingIndicator];
    [self pw_requestApi:WalletHomeMain params:nil completeBlock:^(id  _Nonnull data) {
        [self.view hideLoadingIndicator];
        self.model = [PW_DappBrowserModel mj_objectWithKeyValues:data];
        self.sdScrollView.imageURLStringsGroup = [self.model.banner_1_1 valueForKeyPath:@"imgH5"];
        [self.tableView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self.view hideLoadingIndicator];
    }];
}
- (void)openWebWithTitle:(NSString *)title urlStr:(NSString *)urlStr {
    PW_WebViewController *webVc = [[PW_WebViewController alloc] init];
    webVc.title = title;
    webVc.urlStr = urlStr;
    [self.navigationController pushViewController:webVc animated:YES];
}
- (void)openWeb3WithModel:(PW_DappModel *)model {
    if (![model.chainId isEqualToString:User_manager.currentUser.current_chainId]) {
        [PW_TipTool showDappWalletNotSupportedWithModel:model sureBlock:^{
            [PW_WalletListView show];
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
    return 2;
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
            PW_DappBrowserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_DappBrowserCell"];
            if (self.section1Idx==0) {
                if (self.model.dappTop.count>5) {
                    cell.dataArr = [self.model.dappTop subarrayWithRange:NSMakeRange(0, 4)];
                }else{
                    cell.dataArr = self.model.dappTop;
                }
            }else{
                cell.dataArr = self.dappRecentBrowseArr;
            }
            cell.clickBlock = ^(PW_DappModel * _Nonnull model, NSArray<PW_DappModel *> * _Nonnull dataArr) {
                if (model.isMore) {
                    PW_DappRecentBrowseViewController *vc = [[PW_DappRecentBrowseViewController alloc] init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
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
    PW_DappChainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_DappChainCell"];
    if (self.section2Idx==0) {
        cell.dataArr = self.model.dapp_1;
    }else if (self.section2Idx==1) {
        cell.dataArr = self.model.dapp_56;
    }else if (self.section2Idx==2) {
        cell.dataArr = self.model.dapp_128;
    }
    cell.clickBlock = ^(PW_DappModel * _Nonnull model) {
        [weakSelf openWeb3WithModel:model];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 80;
    }
    NSArray *dataArr = @[];
    if (self.section2Idx==0) {
        dataArr = self.model.dapp_1;
    }else if (self.section2Idx==1) {
        dataArr = self.model.dapp_56;
    }else if (self.section2Idx==2) {
        dataArr = self.model.dapp_128;
    }
    if (dataArr&&dataArr.count>0) {
        NSInteger column = 2;
        NSInteger row = ((NSInteger)dataArr.count/column)+(dataArr.count%column>0?1:0);
        return row*56+(row-1)*12;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PW_TitlesHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PW_TitlesHeaderView"];
    if (section==0) {
        view.titleArr = @[LocalizedStr(@"text_recommend"),LocalizedStr(@"text_browse")];
        view.selectedIndex = self.section1Idx;
    }else{
        view.titleArr = @[@"ETH",@"BSC",@"HECO"];
        view.selectedIndex = self.section2Idx;
    }
    __weak typeof(self) weakSelf = self;
    view.clickBlock = ^(NSInteger idx) {
        if (section==0) {
            if (weakSelf.section1Idx != idx) {
                weakSelf.section1Idx = idx;
                [weakSelf.tableView reloadData];
            }
        }else{
            if (weakSelf.section2Idx != idx) {
                weakSelf.section2Idx = idx;
                [weakSelf.tableView reloadData];
            }
        }
    };
    return view;
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
        [_tableView registerClass:[PW_DappChainCell class] forCellReuseIdentifier:@"PW_DappChainCell"];
        [_tableView registerClass:[PW_TitlesHeaderView class] forHeaderFooterViewReuseIdentifier:@"PW_TitlesHeaderView"];
        _tableView.rowHeight = 70;
        _tableView.sectionHeaderHeight = 55;
        _tableView.sectionFooterHeight = 5;
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 140)];
        [_headerView addSubview:self.sdScrollView];
        [self.sdScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.offset(25);
            make.right.offset(-25);
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
        _sdScrollView.layer.cornerRadius = 15;
    }
    return _sdScrollView;
}

@end
