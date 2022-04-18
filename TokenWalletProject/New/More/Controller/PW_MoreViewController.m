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
#import "MessageCenterViewController.h"
#import "PW_ShareAppTool.h"
#import "BrowseWebViewController.h"
#import "PW_AboutUsViewController.h"
#import "PW_SetUpViewController.h"
#import "PW_AddressBookViewController.h"

@interface PW_MoreViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_GroupMoreModel *> *dataArr;

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
    MessageCenterViewController *vc = [MessageCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)buildData {
    __weak typeof(self) weakSelf = self;
    PW_GroupMoreModel *g1Model = [[PW_GroupMoreModel alloc] init];
    g1Model.dataArr = @[
        [PW_MoreModel MoreIconName:@"icon_more_wallet" title:LocalizedStr(@"text_walletManage") actionBlock:^(PW_MoreModel * _Nonnull model) {
            
        }]
    ];
    PW_GroupMoreModel *g2Model = [[PW_GroupMoreModel alloc] init];
    g2Model.dataArr = @[
        [PW_MoreModel MoreIconName:@"icon_more_network" title:LocalizedStr(@"text_networkManage") actionBlock:^(PW_MoreModel * _Nonnull model) {
            
        }]
    ];
    PW_GroupMoreModel *g3Model = [[PW_GroupMoreModel alloc] init];
    g3Model.dataArr = @[
        [PW_MoreModel MoreIconName:@"icon_more_lock" title:LocalizedStr(@"text_appLock") actionBlock:^(PW_MoreModel * _Nonnull model) {
            
        }]
    ];
    PW_GroupMoreModel *g4Model = [[PW_GroupMoreModel alloc] init];
    g4Model.dataArr = @[
        [PW_MoreModel MoreIconName:@"icon_more_addressBook" title:LocalizedStr(@"text_addressBook") actionBlock:^(PW_MoreModel * _Nonnull model) {
            PW_AddressBookViewController *vc = [[PW_AddressBookViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }]
    ];
    PW_GroupMoreModel *g5Model = [[PW_GroupMoreModel alloc] init];
    g5Model.dataArr = @[
        [PW_MoreModel MoreIconName:@"icon_more_instructions" title:LocalizedStr(@"text_instructions") actionBlock:^(PW_MoreModel * _Nonnull model) {
            [weakSelf openWebTitle:model.title urlStr:WalletUseDirectionsUrl];
        }],
        [PW_MoreModel MoreIconName:@"icon_more_advice" title:LocalizedStr(@"text_suggestionsFeedback") actionBlock:^(PW_MoreModel * _Nonnull model) {
            [weakSelf openWebTitle:model.title urlStr:WalletFeedbackUrl];
        }],
        [PW_MoreModel MoreIconName:@"icon_more_agreement" title:LocalizedStr(@"text_userAgreement") actionBlock:^(PW_MoreModel * _Nonnull model) {
            [weakSelf openWebTitle:model.title urlStr:WalletUserAgreementUrl];
        }],
        [PW_MoreModel MoreIconName:@"icon_more_abount" title:LocalizedStr(@"text_aboutUs") actionBlock:^(PW_MoreModel * _Nonnull model) {
            PW_AboutUsViewController *vc = [[PW_AboutUsViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }],
    ];
    PW_GroupMoreModel *g6Model = [[PW_GroupMoreModel alloc] init];
    g6Model.dataArr = @[
        [PW_MoreModel MoreIconName:@"icon_more_setup" title:LocalizedStr(@"text_setup") actionBlock:^(PW_MoreModel * _Nonnull model) {
            PW_SetUpViewController *vc = [[PW_SetUpViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }]
    ];
    PW_GroupMoreModel *g7Model = [[PW_GroupMoreModel alloc] init];
    g7Model.dataArr = @[
        [PW_MoreModel MoreIconName:@"icon_more_share" title:LocalizedStr(@"text_shareApp") actionBlock:^(PW_MoreModel * _Nonnull model) {
            [PW_ShareAppTool showShareApp];
        }]
    ];
    [self.dataArr addObjectsFromArray:@[g1Model,g2Model,g3Model,g4Model,g5Model,g6Model,g7Model]];
    [self.tableView reloadData];
}
- (void)openWebTitle:(NSString *)title urlStr:(NSString *)urlStr {
    BrowseWebViewController *webVc = [[BrowseWebViewController alloc] init];
    webVc.title = title;
    webVc.urlStr = urlStr;
    [self.navigationController pushViewController:webVc animated:YES];
}
- (void)makeViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom);
        make.left.bottom.right.offset(0);
    }];
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_MoreCell"];
    cell.dataArr = self.dataArr[indexPath.section].dataArr;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArr[indexPath.section].dataArr.count*45;
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.sectionHeaderHeight = 5;
        _tableView.sectionFooterHeight = 5;
        [_tableView registerClass:[PW_MoreCell class] forCellReuseIdentifier:@"PW_MoreCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSMutableArray<PW_GroupMoreModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
