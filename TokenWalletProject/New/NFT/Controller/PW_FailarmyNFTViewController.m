//
//  PW_FailarmyNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/30.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_FailarmyNFTViewController.h"
#import "PW_AllNftFiltrateViewController.h"
#import "PW_RecommendNFTCell.h"
#import "PW_NFTChainTypeView.h"
#import "PW_FailarmyListNFTViewController.h"

@interface PW_FailarmyNFTViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UILabel *chainNameLb;
@property (nonatomic, weak) UIView *searchView;
@property (nonatomic, copy) NSArray<PW_AllNftFiltrateGroupModel *> *filtrateArr;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, assign) BOOL isSearch;

@end

@implementation PW_FailarmyNFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_NFTFailarmy")];
    [self makeViews];
}
- (void)filtrateAction {
    PW_AllNftFiltrateViewController *vc = [[PW_AllNftFiltrateViewController alloc] init];
    vc.filtrateArr = self.filtrateArr;
    vc.sureBlock = ^(NSArray<PW_AllNftFiltrateGroupModel *> * _Nonnull filtrateArr) {
        self.filtrateArr = filtrateArr;
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)chainAction {
    PW_NFTChainTypeView *view = [[PW_NFTChainTypeView alloc] init];
    view.dataArr = @[@"全部",@"ETH",@"BSC"];
    view.clickBlock = ^{
        
    };
    [view showInView:self.view];
}
- (void)makeViews {
    [self makeChainView];
    [self makeSearchView];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(16);
        make.left.right.bottom.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.left.right.bottom.offset(0);
    }];
}
- (void)makeChainView {
    UIView *chainView = [[UIView alloc] init];
    chainView.backgroundColor = [UIColor g_hex:@"#FFFFFF" alpha:0.2];
    [chainView setCornerRadius:13];
    [chainView addTapTarget:self action:@selector(chainAction)];
    [self.view addSubview:chainView];
    [self.naviBar addSubview:chainView];
    [chainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.centerY.equalTo(self.leftBtn).offset(0);
        make.height.mas_equalTo(26);
    }];
    self.chainNameLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_chainName") fontSize:13 textColor:[UIColor whiteColor]];
    [chainView addSubview:self.chainNameLb];
    [self.chainNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-22);
        make.centerY.offset(0);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down"]];
    [chainView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-8);
        make.centerY.offset(0);
    }];
}
- (void)makeSearchView {
    UIView *searchView = [[UIView alloc] init];
    [self.view addSubview:searchView];
    self.searchView = searchView;
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(10);
        make.left.offset(30);
        make.right.offset(-80);
        make.height.offset(44);
    }];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_bg"]];
    [searchView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIImageView *searchIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_white"]];
    [searchView addSubview:searchIv];
    [searchIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    self.searchTF = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:16] color:[UIColor g_whiteTextColor] placeholder:LocalizedStr(@"text_searchNFTContract")];
    [self.searchTF pw_setPlaceholder:LocalizedStr(@"text_searchNFTContract") color:[UIColor g_placeholderWhiteColor]];
    self.searchTF.delegate = self;
    self.searchTF.borderStyle = UITextBorderStyleNone;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.enablesReturnKeyAutomatically = YES;
    [searchView addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(45);
        make.right.offset(-5);
    }];
    UIButton *filtrateBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_filtrate") fontSize:16 titleColor:[UIColor g_primaryColor] imageName:nil target:self action:@selector(filtrateAction)];
    [self.view addSubview:filtrateBtn];
    [filtrateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-25);
        make.centerY.equalTo(searchView);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_RecommendNFTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_RecommendNFTCell.class)];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_FailarmyListNFTViewController *vc = [[PW_FailarmyListNFTViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 186;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        _tableView.contentOffset = CGPointMake(0, -10);
        [_tableView registerClass:PW_RecommendNFTCell.class forCellReuseIdentifier:NSStringFromClass(PW_RecommendNFTCell.class)];
    }
    return _tableView;
}
- (NSArray<PW_AllNftFiltrateGroupModel *> *)filtrateArr {
    if (!_filtrateArr) {
        _filtrateArr = @[
            [PW_AllNftFiltrateGroupModel modelTitle:LocalizedStr(@"text_time") items:@[
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_latest") value:@""],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_oldest") value:@""]
            ]],
            [PW_AllNftFiltrateGroupModel modelTitle:LocalizedStr(@"text_price") items:@[
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_highToLow") value:@""],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_lowToHigh") value:@""]
            ]],
            [PW_AllNftFiltrateGroupModel modelTitle:LocalizedStr(@"text_state") items:@[
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_onOffer") value:@""],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_onBidding") value:@""],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_unsold") value:@""]
            ]]
        ];
    }
    return _filtrateArr;
}

@end
