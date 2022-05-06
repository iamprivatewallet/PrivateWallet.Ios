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

@end

@implementation PW_WalletSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_walletSet")];
    [self makeViews];
    [self buildData];
}
- (void)buildData {
    __weak typeof(self) weakSelf = self;
    PW_WalletSetModel *model1 = [PW_WalletSetModel ModelIconName:@"icon_wallet_name" title:LocalizedStr(@"text_changeWalletName") desc:LocalizedStr(@"text_changeWalletNameWalletDesc") actionBlock:^(PW_WalletSetModel * _Nonnull model) {
        [PW_TipTool showPayPwdSureBlock:^(NSString * _Nonnull pwd) {
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
        PW_BackupWalletViewController *vc = [[PW_BackupWalletViewController alloc] init];
        vc.isFirst = NO;
        vc.wordStr = weakSelf.model.mnemonic;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    PW_WalletSetModel *model4 = [PW_WalletSetModel ModelIconName:@"icon_wallet_privatekey" title:LocalizedStr(@"text_lookPrivateKey") desc:LocalizedStr(@"text_lookPrivateKeyWalletDesc") actionBlock:^(PW_WalletSetModel * _Nonnull model) {
        PW_LookPrivateKeyViewController *vc = [[PW_LookPrivateKeyViewController alloc] init];
        vc.model = weakSelf.model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
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
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(20);
        make.left.right.offset(0);
        make.bottom.offset(-SafeBottomInset);
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
        _tableView.rowHeight = 72;
        [_tableView registerClass:[PW_WalletSetCell class] forCellReuseIdentifier:@"PW_WalletSetCell"];
    }
    return _tableView;
}
- (NSMutableArray<PW_WalletSetModel *> *)dataList {
    if(!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
