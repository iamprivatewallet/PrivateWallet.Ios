//
//  PW_NetworkManageViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NetworkManageViewController.h"
#import "PW_NetworkManageCell.h"
#import "PW_AddCustomNetworkViewController.h"

@interface PW_NetworkManageViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_NetworkModel *> *dataArr;
@property (nonatomic, strong) UIView *addView;

@end

@implementation PW_NetworkManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_networkManage") rightTitle:LocalizedStr(@"text_edit") rightAction:@selector(editAction)];
    [self.rightBtn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateNormal];
    [self makeViews];
    [self requestData];
}
- (void)editAction {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if(self.tableView.editing){
        [self.rightBtn setTitle:LocalizedStr(@"text_finish") forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle:LocalizedStr(@"text_edit") forState:UIControlStateNormal];
        [self sortUpdateDBAction];
    }
    [self.tableView reloadData];
}
- (void)addAction {
    PW_AddCustomNetworkViewController *vc = [[PW_AddCustomNetworkViewController alloc] init];
    vc.saveBlock = ^(PW_NetworkModel * _Nonnull model) {
        [self.dataArr addObject:model];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sortUpdateDBAction {
    for (NSInteger i=0; i<self.dataArr.count; i++) {
        PW_NetworkModel *model = self.dataArr[i];
        [[PW_NetworkManager shared] updateSortIndex:i+1 chainId:model.chainId];
    }
}
- (void)requestData {
    [self.view showLoadingIndicator];
    [self pw_requestApi:WalletTokenChainURL params:nil completeBlock:^(id  _Nonnull data) {
        [self.view hideLoadingIndicator];
        [self.dataArr removeAllObjects];
        NSArray *array = [PW_NetworkModel mj_objectArrayWithKeyValuesArray:data];
        for (PW_NetworkModel *model in array) {
            model.isDefault = YES;
            if(![model.rpcUrl isNoEmpty]){
                model.rpcUrl = [[SettingManager sharedInstance] getNodeWithChainId:model.chainId];
            }
            PW_NetworkModel *exitModel = [[PW_NetworkManager shared] isExistWithChainId:model.chainId];
            if (exitModel==nil) {
                [[PW_NetworkManager shared] saveModel:model];
            }
        }
        NSArray *dbList = [[PW_NetworkManager shared] getList];
        [self.dataArr addObjectsFromArray:dbList];
        [self.tableView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self.view hideLoadingIndicator];
        [self showError:msg];
    }];
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.bottom.right.offset(0);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NetworkManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_NetworkManageCell"];
    cell.model = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.topBlock = ^(PW_NetworkModel * _Nonnull model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.dataArr removeObject:model];
        [strongSelf.dataArr insertObject:model atIndex:0];
        [strongSelf.tableView reloadData];
    };
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NetworkModel *model = self.dataArr[indexPath.row];
    return !model.isDefault;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NetworkModel *model = self.dataArr[indexPath.row];
    return !model.isDefault;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NetworkModel *model = self.dataArr[indexPath.row];
    if (model.isDefault) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        PW_NetworkModel *model = self.dataArr[indexPath.row];
        [[PW_NetworkManager shared] deleteModel:model];
        [self.dataArr removeObject:model];
        [tableView reloadData];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    PW_NetworkModel *destinationModel = self.dataArr[destinationIndexPath.row];
    if(destinationModel.isDefault){
        [tableView reloadData];
        return;
    }
    // 1. 将源从数组中取出
    PW_NetworkModel *source = self.dataArr[sourceIndexPath.row];
    // 2. 将源从数组中删除
    [self.dataArr removeObjectAtIndex:sourceIndexPath.row];
    // 3. 将源插入到数组中的目标位置
    [self.dataArr insertObject:source atIndex:destinationIndexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NetworkModel *model = self.dataArr[indexPath.row];
    PW_AddCustomNetworkViewController *vc = [[PW_AddCustomNetworkViewController alloc] init];
    vc.model = model;
    vc.saveBlock = ^(PW_NetworkModel * _Nonnull model) {
        [tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 72;
        [_tableView registerClass:[PW_NetworkManageCell class] forCellReuseIdentifier:@"PW_NetworkManageCell"];
        _tableView.contentInset = UIEdgeInsetsMake(28, 0, 20, 0);
        _tableView.tableFooterView = self.addView;
    }
    return _tableView;
}
- (UIView *)addView {
    if (!_addView) {
        _addView = [[UIView alloc] init];
        _addView.frame = CGRectMake(0, 0, 0, 54);
        UIButton *addBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_addNetwork") fontSize:15 titleColor:[UIColor g_grayTextColor] imageName:@"icon_add" target:self action:@selector(addAction)];
        addBtn.frame = CGRectMake(20, 10, SCREEN_WIDTH-72, 44);
        [addBtn setDottedLineColor:[UIColor g_dottedColor] lineWidth:1 length:3 space:3 radius:12];
        [_addView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(36);
            make.right.offset(-36);
            make.height.offset(44);
        }];
    }
    return _addView;
}
- (NSMutableArray<PW_NetworkModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
