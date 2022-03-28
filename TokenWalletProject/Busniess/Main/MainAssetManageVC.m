//
//  MainAssetManageVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MainAssetManageVC.h"
#import "AssetEditCell.h"
#import "SearchViewController.h"

static NSString * kSortIndexKey = @"SortIndexKey";

@interface MainAssetManageVC ()

<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sortBtn;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, strong) NSArray *sortTitleArr;
@end

@implementation MainAssetManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"首页资产管理" rightImg:@"searchBlack" rightAction:@selector(navRightItemAction)];
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:kSortIndexKey];
    self.sortIndex = index==0?1:index;
    self.sortTitleArr = @[@"默认排序",@"价值排序",@"名称排序"];
    [self makeViews];
    [self.tableView setEditing:YES animated:YES];
    [self.dataList addObjectsFromArray:self.coinList];
    [self.tableView reloadData];
}
- (void)navRightItemAction{
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)makeViews{
    self.view.backgroundColor = [UIColor im_tableBgColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight+45);
        make.bottom.equalTo(self.view);
    }];
    self.sortBtn = [ZZCustomView buttonInitWithView:self.view title:@"" titleColor:[UIColor im_textColor_nine] titleFont:GCSFontRegular(13)];
    [self.view addSubview:self.sortBtn];
    [self updateSortTitle];
    [self.sortBtn setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    self.sortBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 90, 0, 0);
    self.sortBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.sortBtn addTarget:self action:@selector(sortBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.tableView.mas_top).offset(-5);
        make.height.equalTo(@(30));
        make.width.equalTo(@(100));
    }];
}
- (void)updateSortTitle {
    NSString *title = self.sortTitleArr.firstObject;
    if(self.sortIndex>0&&self.sortIndex<=self.sortTitleArr.count){
        title = self.sortTitleArr[self.sortIndex-1];
    }
    [self.sortBtn setTitle:title forState:UIControlStateNormal];
}
- (void)sortCoinAmountList{
    NSArray *sortedArray = [self.dataList sortedArrayUsingComparator:^NSComparisonResult(WalletCoinModel *obj1, WalletCoinModel *obj2) {
        if (obj1.isDefault) {
            return NSOrderedAscending;
        }
        if ([obj1.usableAmount doubleValue]<[obj2.usableAmount doubleValue]) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
    [self sortUpdateDBAction];
}

- (void)sortCoinNameList{
//    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataList];
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"tokenName" ascending:YES];
//    [array sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSArray *sortedArray = [self.dataList sortedArrayUsingComparator:^NSComparisonResult(WalletCoinModel *obj1, WalletCoinModel *obj2) {
        if (obj1.isDefault) {
            return NSOrderedAscending;
        }
        if (obj1.tokenName>obj2.tokenName) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
    [self sortUpdateDBAction];
}
- (void)sortUpdateDBAction {
    User *user = User_manager.currentUser;
    for (NSInteger i=0; i<self.dataList.count; i++) {
        WalletCoinModel *model = self.dataList[i];
        [[WalletCoinListManager shareManager] updateSortIndex:i+1 address:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenAddress chainId:model.chainId];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:self.sortIndex forKey:kSortIndexKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCoinList_Notification" object:nil];
}
- (void)sortBtnAction{
    [WarningAlertSheetView showSortViewWithAction:^(NSInteger index) {
        self.sortIndex = index;
        [self updateSortTitle];
        if (index == 1) {//默认
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:self.coinList];
            [self.tableView reloadData];
            [self sortUpdateDBAction];
        }else if(index == 2){
            [self sortCoinAmountList];
        }else if(index == 3){
            [self sortCoinNameList];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 70;
    }
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AssetEditCell";
    AssetEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AssetEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setViewWithData:self.dataList[indexPath.row]];
    if (indexPath.row == 0) {
        [cell hiddenEditView];
    }
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletCoinModel *model = self.dataList[indexPath.row];
    if (model.isDefault)  {
        return NO;  /*第一行不能进行编辑*/
    } else {
        return YES;
    }
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletCoinModel *model = self.dataList[indexPath.row];
    if (model.isDefault)  {
        return NO;  /*第一行不能进行编辑*/
    } else {
        return YES;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WalletCoinModel *model = self.dataList[indexPath.row];
        [self.dataList removeObjectAtIndex:indexPath.row];
        //刷新
        [self.tableView reloadData];
        User *user = User_manager.currentUser;
        [[WalletCoinListManager shareManager] deleteCoin:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenAddress chainId:model.chainId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCoinList_Notification" object:nil];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 界面数据UITableView已经完成了
    WalletCoinModel *destinationModel = self.dataList[destinationIndexPath.row];
    if(destinationModel.isDefault){
        [tableView reloadData];
        return;
    }
    // 1. 将源从数组中取出
    WalletCoinModel *source = self.dataList[sourceIndexPath.row];
    // 2. 将源从数组中删除
    [self.dataList removeObjectAtIndex:sourceIndexPath.row];
    NSLog(@"%@", self.dataList);
    // 3. 将源插入到数组中的目标位置
    [self.dataList insertObject:source atIndex:destinationIndexPath.row];
    [self sortUpdateDBAction];
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor navAndTabBackColor];
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.separatorColor = [UIColor im_borderLineColor];
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
