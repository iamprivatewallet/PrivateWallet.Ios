//
//  PW_WalletView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/11.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletView.h"
#import "PW_SwitchNetworkView.h"
#import "PW_SelectWalletTypeViewController.h"

@interface PW_WalletView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UIView *networkView;
@property (nonatomic, strong) UILabel *netNameLb;
@property (nonatomic, strong) UILabel *netSubNameLb;
@property (nonatomic, strong) UIView *addWalletView;

@property (nonatomic, strong) NSMutableArray<Wallet *> *dataList;

@end

@implementation PW_WalletView

+ (instancetype)shared {
    static PW_WalletView *shareObj = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareObj = [[PW_WalletView alloc] init];
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
- (void)addWalletAction {
    [self closeAction];
    [TheAppDelegate.rootNavigationController pushViewController:[PW_SelectWalletTypeViewController new] animated:YES];
}
- (void)changeNetAction {
    [self closeAction];
    [PW_SwitchNetworkView show];
}
- (void)refreshData {
    self.netNameLb.text = User_manager.currentUser.current_name;
    self.netSubNameLb.text = User_manager.currentUser.current_Node;
    [self.dataList removeAllObjects];
    NSArray *orignList = [[WalletManager shareWalletManager] getOrignWallets];
    [self.dataList addObjectsFromArray:orignList];
    NSArray *importList = [[WalletManager shareWalletManager] getImportWallets];
    [self.dataList addObjectsFromArray:importList];
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
        make.height.offset(SCREEN_HEIGHT*0.8);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"tabbar_wallet") fontSize:17 textColor:[UIColor g_boldTextColor]];
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
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(60);
        make.left.right.offset(0);
        make.bottom.offset(-SafeBottomInset);
    }];
}
+ (void)show {
    PW_WalletView *view = [PW_WalletView shared];
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
    [[PW_WalletView shared] removeFromSuperview];
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
        _tableView.tableHeaderView = self.networkView;
        _tableView.tableFooterView = self.addWalletView;
    }
    return _tableView;
}
- (NSMutableArray<Wallet *> *)dataList {
    if(!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}
- (UIView *)networkView {
    if (!_networkView) {
        _networkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 74)];
        UIView *contentView = [[UIView alloc] init];
        [contentView setShadowColor:[UIColor g_hex:@"#00A4B8" alpha:0.4] offset:CGSizeMake(0, 5) radius:5];
        contentView.layer.cornerRadius = 8;
        [contentView addTapTarget:self action:@selector(changeNetAction)];
        [_networkView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.right.offset(-20);
            make.top.offset(0);
            make.bottom.offset(-12);
        }];
        UIImage *bgImage = [UIImage pw_imageGradientSize:CGSizeMake(SCREEN_WIDTH-40, 74) gradientColors:@[[UIColor g_hex:@"#00D5E9"],[UIColor g_hex:@"#00A4B9"]] gradientType:PW_GradientLeftToRight cornerRadius:8];
        UIImageView *bgIv = [[UIImageView alloc] initWithImage:bgImage];
        [contentView addSubview:bgIv];
        [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        self.netNameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor whiteColor]];
        [contentView addSubview:self.netNameLb];
        self.netSubNameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
        [contentView addSubview:self.netSubNameLb];
        UILabel *changeTipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_switchNetwork") fontSize:13 textColor:[UIColor whiteColor]];
        [contentView addSubview:changeTipLb];
        UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_light"]];
        [contentView addSubview:arrowIv];
        [self.netNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(12);
            make.left.offset(20);
        }];
        [self.netSubNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.netNameLb.mas_bottom).offset(4);
            make.left.offset(20);
        }];
        [changeTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.equalTo(arrowIv.mas_left).offset(-10);
        }];
        [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-22);
            make.centerY.offset(0);
        }];
    }
    return _networkView;
}
- (UIView *)addWalletView {
    if (!_addWalletView) {
        _addWalletView = [[UIView alloc] init];
        _addWalletView.frame = CGRectMake(0, 0, 0, 44);
        UIButton *addBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_addWallet") fontSize:15 titleColor:[UIColor g_grayTextColor] imageName:@"icon_add" target:self action:@selector(addWalletAction)];
        addBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        [addBtn setDottedLineColor:[UIColor g_dottedColor] lineWidth:1 length:3 space:3 radius:12];
        [_addWalletView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.offset(20);
            make.right.offset(-20);
        }];
    }
    return _addWalletView;
}

@end

@interface PW_WalletViewCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *addressLb;
@property (nonatomic, strong) UILabel *stateLb;
@property (nonatomic, strong) UIButton *copyBtn;

@end

@implementation PW_WalletViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}
- (void)setWallet:(Wallet *)wallet {
    _wallet = wallet;
    self.nameLb.text = wallet.walletName;
    self.addressLb.text = [wallet.address showShortAddress];
    self.stateLb.hidden = ![User_manager.currentUser.chooseWallet_address isEqualToString:wallet.address];
}
- (void)copyAction {
    [self.wallet.address pasteboardToast:YES];
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.addressLb];
    [self.bodyView addSubview:self.stateLb];
    [self.bodyView addSubview:self.copyBtn];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-12);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(20);
    }];
    [self.stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(12);
        make.right.offset(-18);
    }];
    [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLb.mas_bottom).offset(4);
        make.left.offset(20);
    }];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLb.mas_right).offset(8);
        make.centerY.equalTo(self.addressLb);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if(!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.backgroundColor = [UIColor g_bgColor];
        [_bodyView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
        _bodyView.layer.cornerRadius = 8;
    }
    return _bodyView;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    }
    return _nameLb;
}
- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    }
    return _addressLb;
}
- (UILabel *)stateLb {
    if (!_stateLb) {
        _stateLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_current") fontSize:13 textColor:[UIColor g_primaryColor]];
        _stateLb.hidden = YES;
    }
    return _stateLb;
}
- (UIButton *)copyBtn {
    if (!_copyBtn) {
        _copyBtn = [PW_ViewTool buttonImageName:@"icon_copyAndBg" target:self action:@selector(copyAction)];
    }
    return _copyBtn;
}

@end