//
//  PW_WalletSetViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletSetViewController.h"
#import "PW_WalletSetCell.h"
#import "PW_BackupWalletViewController.h"
#import "PW_ChangeWalletNameViewController.h"
#import "PW_LookPrivateKeyViewController.h"
#import "PW_ChangePwdViewController.h"

@interface PW_WalletSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<PW_WalletSetModel *> *dataList;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation PW_WalletSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_walletSet")];
    [self makeViews];
    [self buildData];
}
- (void)deleteAction {
    if (self.model.isImport==NO&&![User_manager isBackup]) {
        [PW_TipTool showDeleteWalletBackupMnemonicsSureBlock:^{
            PW_BackupWalletViewController *vc = [[PW_BackupWalletViewController alloc] init];
            vc.isFirst = NO;
            vc.wordStr = User_manager.currentUser.user_mnemonic;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        return;
    }
    [PW_TipTool showPayCheckBlock:^(NSString * _Nonnull pwd) {
        if (![pwd isEqualToString:self.model.walletPassword]) {
            return [self showError:LocalizedStr(@"text_pwdError")];
        }
        [self deleteWallet];
    }];
}
- (void)deleteWallet {
    [[PW_WalletManager shared] deleteWallet:self.model];
    if (self.refreshBlock) {
        self.refreshBlock(self.model);
    }
    NSArray *wallets = [[PW_WalletManager shared] getWallets];
    if (wallets.count>0) {
        if ([User_manager.currentUser.chooseWallet_address isEqualToString:self.model.address]) {
            Wallet *wallet = wallets.firstObject;
            [User_manager updateChooseWallet:wallet];
            [[NSNotificationCenter defaultCenter] postNotificationName:kChangeWalletNotification object:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [User_manager logout];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [TheAppDelegate switchToCreateWalletVC];
        });
    }
}
- (void)buildData {
    __weak typeof(self) weakSelf = self;
    PW_WalletSetModel *model1 = [PW_WalletSetModel ModelIconName:@"icon_wallet_name" title:LocalizedStr(@"text_changeWalletName") desc:LocalizedStr(@"text_changeWalletNameWalletDesc") actionBlock:^(PW_WalletSetModel * _Nonnull model) {
        [PW_TipTool showPayCheckBlock:^(NSString * _Nonnull pwd) {
            if (![pwd isEqualToString:weakSelf.model.walletPassword]) {
                return [weakSelf showError:LocalizedStr(@"text_pwdError")];
            }
            PW_ChangeWalletNameViewController *vc = [[PW_ChangeWalletNameViewController alloc] init];
            vc.model = weakSelf.model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }];
    PW_WalletSetModel *model2 = [PW_WalletSetModel ModelIconName:@"icon_wallet_pwd" title:LocalizedStr(@"text_changePwd") desc:LocalizedStr(@"text_changePwdWalletDesc") actionBlock:^(PW_WalletSetModel * _Nonnull model) {
        PW_ChangePwdViewController *vc = [[PW_ChangePwdViewController alloc] init];
        vc.model = weakSelf.model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    PW_WalletSetModel *model3 = [PW_WalletSetModel ModelIconName:@"icon_wallet_mnemonic" title:LocalizedStr(@"text_backupMnemonics") desc:LocalizedStr(@"text_backupMnemonicsWalletDesc") actionBlock:^(PW_WalletSetModel * _Nonnull model) {
        [PW_TipTool showPayCheckBlock:^(NSString * _Nonnull pwd) {
            if (![pwd isEqualToString:weakSelf.model.walletPassword]) {
                return [weakSelf showError:LocalizedStr(@"text_pwdError")];
            }
            PW_BackupWalletViewController *vc = [[PW_BackupWalletViewController alloc] init];
            vc.isFirst = NO;
            vc.wordStr = weakSelf.model.mnemonic;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }];
    PW_WalletSetModel *model4 = [PW_WalletSetModel ModelIconName:@"icon_wallet_privatekey" title:LocalizedStr(@"text_lookPrivateKey") desc:LocalizedStr(@"text_lookPrivateKeyWalletDesc") actionBlock:^(PW_WalletSetModel * _Nonnull model) {
        [PW_TipTool showPayCheckBlock:^(NSString * _Nonnull pwd) {
            if (![pwd isEqualToString:weakSelf.model.walletPassword]) {
                return [weakSelf showError:LocalizedStr(@"text_pwdError")];
            }
            PW_LookPrivateKeyViewController *vc = [[PW_LookPrivateKeyViewController alloc] init];
            vc.model = weakSelf.model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }];
    [self.dataList removeAllObjects];
    if ([self.model.mnemonic isNoEmpty]) {
        [self.dataList addObjectsFromArray:@[model1,model2,model3,model4]];
    }else{
        [self.dataList addObjectsFromArray:@[model1,model2,model4]];
    }
    [self.tableView reloadData];
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
    [contentView addSubview:self.deleteBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.right.offset(0);
        make.bottom.equalTo(self.deleteBtn.mas_top).offset(-10);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(56);
        make.bottomMargin.offset(-30);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_WalletSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_WalletSetCell"];
    cell.model = self.dataList[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_WalletSetModel *model = self.dataList[indexPath.row];
    if (model.actionBlock) {
        model.actionBlock(model);
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 84;
        [_tableView registerClass:[PW_WalletSetCell class] forCellReuseIdentifier:@"PW_WalletSetCell"];
    }
    return _tableView;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [PW_ViewTool buttonTitle:@"Delete Wallet" fontSize:18 titleColor:[UIColor g_grayTextColor] imageName:@"icon_delete_gray" target:self action:@selector(deleteAction)];
        [_deleteBtn setBorderColor:[UIColor g_borderGrayColor] width:1 radius:8];
    }
    return _deleteBtn;
}
- (NSMutableArray<PW_WalletSetModel *> *)dataList {
    if(!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
