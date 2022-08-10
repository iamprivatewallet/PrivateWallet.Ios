//
//  PW_CurrencyManageViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/15.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_CurrencyManageViewController.h"
#import "PW_CurrencyManageCell.h"

@interface PW_CurrencyManageViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_TokenModel *> *coinList;

@end

@implementation PW_CurrencyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_currencyManage") rightTitle:LocalizedStr(@"text_save") rightAction:@selector(finishAction)];
    [self.rightBtn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateNormal];
    [self makeViews];
}
- (void)finishAction {
    [self sortUpdateDBAction];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeViews {
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
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coinList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_CurrencyManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_CurrencyManageCell"];
    cell.model = self.coinList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.topBlock = ^(PW_TokenModel * _Nonnull model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(model.isDefault){return;}
        [strongSelf.coinList removeObject:model];
        [strongSelf.coinList insertObject:model atIndex:[strongSelf getFirstNoDefaultIndex]];
        [strongSelf.tableView reloadData];
    };
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_TokenModel *model = self.coinList[indexPath.row];
    return !model.isDefault;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    PW_TokenModel *model = self.coinList[indexPath.row];
    if (model.isDefault) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    PW_TokenModel *model = self.coinList[indexPath.row];
    return !model.isDefault;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PW_TokenModel *model = self.coinList[indexPath.row];
        if(model.isDefault){return;}
        [self.coinList removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        User *user = User_manager.currentUser;
        [[PW_TokenManager shared] deleteCoinWalletAddress:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCoinListNotification object:nil];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 界面数据UITableView已经完成了
    PW_TokenModel *destinationModel = self.coinList[destinationIndexPath.row];
    if(destinationModel.isDefault){
        [tableView reloadData];
        return;
    }
    // 1. 将源从数组中取出
    PW_TokenModel *source = self.coinList[sourceIndexPath.row];
    // 2. 将源从数组中删除
    [self.coinList removeObjectAtIndex:sourceIndexPath.row];
    // 3. 将源插入到数组中的目标位置
    [self.coinList insertObject:source atIndex:destinationIndexPath.row];
}
- (void)sortUpdateDBAction {
    User *user = User_manager.currentUser;
    for (NSInteger i=0; i<self.coinList.count; i++) {
        PW_TokenModel *model = self.coinList[i];
        [[PW_TokenManager shared] updateSortIndex:i+1 address:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCoinListNotification object:nil];
}
- (NSInteger)getFirstNoDefaultIndex {
    for (NSInteger i=0; i<self.coinList.count; i++) {
        PW_TokenModel *model = self.coinList[i];
        if (!model.isDefault) {
            return i;
        }
    }
    return -1;
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 74;
        _tableView.editing = YES;
        [_tableView registerClass:[PW_CurrencyManageCell class] forCellReuseIdentifier:@"PW_CurrencyManageCell"];
    }
    return _tableView;
}
- (NSMutableArray<PW_TokenModel *> *)coinList {
    if (!_coinList) {
        _coinList = [NSMutableArray arrayWithArray:[PW_GlobalData shared].coinList];
    }
    return _coinList;
}

@end
