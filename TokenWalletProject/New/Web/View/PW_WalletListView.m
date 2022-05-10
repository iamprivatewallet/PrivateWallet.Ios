//
//  PW_WalletListView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletListView.h"
#import "PW_WalletViewCell.h"

@interface PW_WalletListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *subNameLb;

@property (nonatomic, strong) NSMutableArray<Wallet *> *dataList;


@end

@implementation PW_WalletListView

+ (instancetype)shared {
    static PW_WalletListView *shareObj = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareObj = [[self alloc] init];
    });
    return shareObj;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)refreshData {
    NSString *type = [[SettingManager sharedInstance] getChainType];
    NSString *coinName = [[SettingManager sharedInstance] getChainCoinName];
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:AppWalletTokenIconURL(type,coinName)]];
    self.nameLb.text = type;
    self.subNameLb.text = [type mj_firstCharUpper];
    [self.dataList removeAllObjects];
    NSArray *allList = [[PW_WalletManager shared] selectWalletWithType:User_manager.currentUser.chooseWallet_type];
    [self.dataList addObjectsFromArray:allList];
    [self.tableView reloadData];
}
- (void)closeAction {
    [self removeFromSuperview];
}
- (void)makeViews {
    self.backgroundColor = [UIColor g_maskColor];
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor g_bgColor];
    [self.contentView setRadius:28 corners:(UIRectCornerTopLeft | UIRectCornerTopRight) size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*0.8)];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(SCREEN_HEIGHT*0.6);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_walletList") fontSize:17 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:titleLb];
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:self action:@selector(closeAction)];
    [self.contentView addSubview:closeBtn];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(26);
        make.top.offset(18);
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.top.offset(12);
    }];
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(28);
        make.top.offset(62);
        make.width.height.offset(25);
    }];
    self.nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:self.nameLb];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(10);
        make.centerY.equalTo(self.iconIv);
    }];
    self.subNameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:self.subNameLb];
    [self.subNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subNameLb.mas_right).offset(8);
        make.centerY.equalTo(self.iconIv);
    }];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIv.mas_bottom).offset(20);
        make.left.right.bottom.offset(0);
    }];
}
+ (void)show {
    PW_WalletListView *view = [PW_WalletListView shared];
    [view refreshData];
    [[[UIApplication sharedApplication].delegate window] addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [view layoutIfNeeded];
    view.contentView.transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    [UIView animateWithDuration:0.25 animations:^{
        view.contentView.transform = CGAffineTransformIdentity;
    }];
}
+ (void)dismiss {
    [[PW_WalletListView shared] removeFromSuperview];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_WalletViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_WalletViewCell"];
    cell.wallet = self.dataList[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Wallet *wallet = self.dataList[indexPath.row];
    [User_manager updateChooseWallet:wallet];
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeWalletNotification object:nil];
    [self closeAction];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 74;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[PW_WalletViewCell class] forCellReuseIdentifier:@"PW_WalletViewCell"];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, SafeBottomInset+10, 0);
    }
    return _tableView;
}
- (NSMutableArray<Wallet *> *)dataList {
    if(!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
