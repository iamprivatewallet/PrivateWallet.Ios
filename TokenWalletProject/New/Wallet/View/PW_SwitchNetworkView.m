//
//  PW_SwitchNetworkView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/11.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SwitchNetworkView.h"

@interface PW_SwitchNetworkView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_NetworkModel *> *dataList;

@end

@implementation PW_SwitchNetworkView

+ (instancetype)shared {
    static PW_SwitchNetworkView *shareObj = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareObj = [[PW_SwitchNetworkView alloc] init];
    });
    return shareObj;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)refreshData {
    [self showLoadingIndicator];
    [NetworkTool requestApi:WalletTokenChainURL params:nil completeBlock:^(id  _Nonnull data) {
        [self hideLoadingIndicator];
        [self.dataList removeAllObjects];
        NSMutableArray *allList = [NSMutableArray array];
        NSArray *array = [PW_NetworkModel mj_objectArrayWithKeyValuesArray:data];
        NSString *walletType = User_manager.currentUser.chooseWallet_type;
        for (PW_NetworkModel *model in array) {
            PW_NetworkModel *exitModel = [[PW_NetworkManager shared] isExistWithChainId:model.chainId];
            if (exitModel==nil) {
                [allList addObject:model];
            }
        }
        NSArray *dbList = [[PW_NetworkManager shared] getList];
        [allList addObjectsFromArray:dbList];
        for (PW_NetworkModel *model in allList) {
            PW_NetworkModel *netModel = [[PW_NodeManager shared] getSelectedNodeWithChainId:model.chainId];
            if(netModel){
                model.rpcUrl = netModel.rpcUrl;
            }
            if(![model.rpcUrl isNoEmpty]){
                model.rpcUrl = [[SettingManager sharedInstance] getNodeWithChainId:model.chainId];
            }
            if ([walletType isEqualToString:WalletTypeETH]) {
                if(![model.chainId isEqualToString:@"168"]){
                    [self.dataList addObject:model];
                }
            }else if([walletType isEqualToString:WalletTypeCVN]) {
                if([model.chainId isEqualToString:@"168"]){
                    [self.dataList addObject:model];
                }
            }else{
                [self.dataList addObject:model];
            }
        }
        [self.tableView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self hideLoadingIndicator];
        [PW_ToastTool showError:msg];
    }];
}
- (void)closeAction {
    [self removeFromSuperview];
}
- (void)makeViews {
    self.backgroundColor = [UIColor g_maskColor];
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor g_bgColor];
    [self.contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight) size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*0.8)];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(SCREEN_HEIGHT*0.8);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_switchNetwork") fontSize:17 textColor:[UIColor g_boldTextColor]];
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
    PW_SwitchNetworkView *view = [PW_SwitchNetworkView shared];
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
    [[PW_SwitchNetworkView shared] removeFromSuperview];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_SwitchNetworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_SwitchNetworkCell"];
    cell.model = self.dataList[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NetworkModel *model = self.dataList[indexPath.row];
    Wallet *wallet = nil;
    if ([model.title isEqualToString:WalletTypeCVN]||[model.chainId isEqualToString:kCVNChainId]) {
        wallet = [[PW_WalletManager shared] getOriginWalletWithType:WalletTypeCVN];
    }else{
        wallet = [[PW_WalletManager shared] getOriginWalletWithType:WalletTypeETH];
    }
    if (wallet&&![wallet.type isEqualToString:User_manager.currentUser.chooseWallet_type]) {
        [User_manager updateChooseWallet:wallet];
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeWalletNotification object:nil];
    }
    [User_manager updateCurrentNode:model.rpcUrl chainId:model.chainId name:model.title];
    [[NSNotificationCenter defaultCenter] postNotificationName:kChainNodeUpdateNotification object:nil];
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
        [_tableView registerClass:[PW_SwitchNetworkCell class] forCellReuseIdentifier:@"PW_SwitchNetworkCell"];
    }
    return _tableView;
}
- (NSMutableArray<PW_NetworkModel *> *)dataList {
    if(!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end

@interface PW_SwitchNetworkCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *subNameLb;
@property (nonatomic, strong) UILabel *stateLb;

@end

@implementation PW_SwitchNetworkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_NetworkModel *)model {
    _model = model;
    self.nameLb.text = model.title;
    self.subNameLb.text = model.rpcUrl;
    self.stateLb.hidden = ![User_manager.currentUser.current_chainId isEqualToString:model.chainId];
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.subNameLb];
    [self.bodyView addSubview:self.stateLb];
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
    [self.subNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLb.mas_bottom).offset(4);
        make.left.offset(20);
        make.right.offset(-20);
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
- (UILabel *)subNameLb {
    if (!_subNameLb) {
        _subNameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
        _subNameLb.numberOfLines = 1;
    }
    return _subNameLb;
}
- (UILabel *)stateLb {
    if (!_stateLb) {
        _stateLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_current") fontSize:13 textColor:[UIColor g_primaryColor]];
        _stateLb.hidden = YES;
    }
    return _stateLb;
}

@end
