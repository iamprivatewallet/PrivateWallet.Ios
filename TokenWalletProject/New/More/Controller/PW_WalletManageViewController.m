//
//  PW_WalletManageViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletManageViewController.h"
#import "PW_SelectWalletTypeViewController.h"
#import "PW_SwitchNetworkView.h"
#import "PW_WalletManageCell.h"
#import "PW_WalletSetViewController.h"
#import "PW_BackupWalletViewController.h"

@interface PW_WalletManageViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<Wallet *> *dataList;

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UIView *networkView;
@property (nonatomic, strong) UILabel *netNameLb;
@property (nonatomic, strong) UILabel *netSubNameLb;
@property (nonatomic, strong) UIView *addWalletView;

@end

@implementation PW_WalletManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_walletManage") rightTitle:LocalizedStr(@"text_edit") rightAction:@selector(editAction)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kChainNodeUpdateNotification object:nil];
    [self makeViews];
    [self refreshData];
}
- (void)editAction {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if(self.tableView.editing){
        [self.rightBtn setTitle:LocalizedStr(@"text_finish") forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle:LocalizedStr(@"text_edit") forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor g_textColor] forState:UIControlStateNormal];
        [self sortUpdateDBAction];
    }
    [self.tableView reloadData];
}
- (void)sortUpdateDBAction {
    for (NSInteger i=0; i<self.dataList.count; i++) {
        Wallet *model = self.dataList[i];
        [[PW_WalletManager shared] updateSortIndex:i+1 address:model.address type:model.type];
    }
}
- (void)addWalletAction {
    [self.navigationController pushViewController:[[PW_SelectWalletTypeViewController alloc] init] animated:YES];
}
- (void)changeNetAction {
    [PW_SwitchNetworkView show];
}
- (void)refreshData {
    self.netNameLb.text = User_manager.currentUser.current_name;
    self.netSubNameLb.text = User_manager.currentUser.current_Node;
    [self.dataList removeAllObjects];
    NSArray *allList = [[PW_WalletManager shared] getWallets];
    [self.dataList addObjectsFromArray:allList];
    [self.tableView reloadData];
}
- (void)makeViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.right.offset(0);
        make.bottom.offset(-SafeBottomInset);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_WalletManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_WalletManageCell"];
    cell.isEdit = tableView.isEditing;
    cell.model = self.dataList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.topBlock = ^(Wallet * _Nonnull model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.dataList removeObject:model];
        [strongSelf.dataList insertObject:model atIndex:0];
        [strongSelf.tableView reloadData];
    };
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        Wallet *model = self.dataList[indexPath.row];
        if (model.isImport==NO&&![User_manager isBackup]) {
            [PW_AlertTool showAlertTitle:LocalizedStr(@"text_prompt") desc:LocalizedStr(@"text_noBackupTip") sureBlock:^{
                PW_BackupWalletViewController *vc = [[PW_BackupWalletViewController alloc] init];
                vc.isFirst = NO;
                vc.wordStr = User_manager.currentUser.user_mnemonic;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            return;
        }
        [[PW_WalletManager shared] deleteWallet:model];
        [self.dataList removeObject:model];
        [tableView reloadData];
        if (self.dataList.count>0) {
            if ([User_manager.currentUser.chooseWallet_address isEqualToString:model.address]) {
                Wallet *wallet = self.dataList.firstObject;
                [User_manager updateChooseWallet:wallet];
            }
        }else{
            [User_manager logout];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [TheAppDelegate switchToCreateWalletVC];
            });
        }
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Wallet *source = self.dataList[sourceIndexPath.row];
    [self.dataList removeObjectAtIndex:sourceIndexPath.row];
    [self.dataList insertObject:source atIndex:destinationIndexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing==NO) {
        Wallet *model = self.dataList[indexPath.row];
        PW_WalletSetViewController *vc = [[PW_WalletSetViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 74;
        [_tableView registerClass:[PW_WalletManageCell class] forCellReuseIdentifier:@"PW_WalletManageCell"];
        _tableView.tableHeaderView = self.networkView;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _tableView.tableFooterView = self.addWalletView;
    }
    return _tableView;
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
            make.bottom.offset(-6);
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
        self.netSubNameLb.numberOfLines = 1;
        [contentView addSubview:self.netSubNameLb];
        UILabel *changeTipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_switchNetwork") fontSize:13 textColor:[UIColor whiteColor]];
        [contentView addSubview:changeTipLb];
        UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_light"]];
        [contentView addSubview:arrowIv];
        [self.netNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(contentView.mas_centerY);
            make.left.offset(20);
        }];
        [self.netSubNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_centerY).offset(6);
            make.left.offset(20);
            make.right.offset(-20);
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
        _addWalletView.frame = CGRectMake(0, 0, 0, 54);
        UIButton *addBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_addWallet") fontSize:15 titleColor:[UIColor g_grayTextColor] imageName:@"icon_add" target:self action:@selector(addWalletAction)];
        addBtn.frame = CGRectMake(0, 5, SCREEN_WIDTH-40, 44);
        [addBtn setDottedLineColor:[UIColor g_dottedColor] lineWidth:1 length:3 space:3 radius:12];
        [_addWalletView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.bottom.offset(-5);
            make.left.offset(20);
            make.right.offset(-20);
        }];
    }
    return _addWalletView;
}
- (NSMutableArray<Wallet *> *)dataList {
    if(!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
