//
//  AssetManagementVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/24.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AssetManagementVC.h"
#import "TransferViewController.h"
#import "CollectionViewController.h"
#import "AssetTopView.h"
#import "AssetBottomView.h"
#import "AssetSortView.h"
#import "AssetTableCell.h"
#import "TransferDetailInfoVC.h"
#import "PW_WalletContractTool.h"

typedef enum : NSUInteger {
    kSortTypeAll,
    kSortTypeOut,
    kSortTypeIn,
    kSortTypeFail
} kSortType;

@interface AssetManagementVC ()
<
UITableViewDelegate,
UITableViewDataSource,
AssetSortViewDelegate
>
@property (nonatomic, strong) AssetTopView *topView;
@property (nonatomic, strong) AssetBottomView *bottomView;
@property (nonatomic, strong) AssetSortView *sortView;
@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray *recordList;
@property (nonatomic, strong) NSMutableArray *outAndInList;

@property (nonatomic, strong) NoDataShowView *noDataView;

@property(nonatomic, assign) NSInteger itemCurrentIndex;

@property(nonatomic, assign) kSortType sortType;

@end

@implementation AssetManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:self.coinModel.tokenName rightImg:@"" rightAction:@selector(navRightItemAction)];
    [self makeViews];
    
    if(![self.coinModel.currentWallet.type isEqualToString:@"CVN"]&&(self.coinModel.decimals==0||![self.coinModel.usableAmount isNoEmpty]||self.coinModel.usableAmount.doubleValue==0)){
        if(![self.coinModel.usableAmount isNoEmpty]||self.coinModel.usableAmount.doubleValue==0){
            [PW_WalletContractTool decimalsContractAddress:self.coinModel.tokenAddress completionHandler:^(NSInteger decimals, NSString * _Nullable errMsg) {
                if(errMsg==nil){
                    self.coinModel.decimals = decimals;
                    [self loadRecordListIsMore:NO sort:0];
                }
                [PW_WalletContractTool balanceOfAddress:User_manager.currentUser.chooseWallet_address contractAddress:self.coinModel.tokenAddress completionHandler:^(NSString * _Nullable amount, NSString * _Nullable errMsg) {
                    if(errMsg==nil){
                        self.coinModel.usableAmount = [amount stringDownDividingBy10Power:decimals];
                        [self.topView setViewWithModel:self.coinModel];
                    }
                }];
            }];
        }else{
            [PW_WalletContractTool decimalsContractAddress:self.coinModel.tokenAddress completionHandler:^(NSInteger decimals, NSString * _Nullable errMsg) {
                if(errMsg==nil){
                    self.coinModel.decimals = decimals;
                    [self loadRecordListIsMore:NO sort:0];
                    [self.topView setViewWithModel:self.coinModel];
                }
            }];
        }
    }else{
        [self loadRecordListIsMore:NO sort:0];
        [self.topView setViewWithModel:self.coinModel];
    }
}
- (void)navRightItemAction{
    
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@90);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

//冷钱包 ETH转入转出
- (void)loadRecordListIsMore:(BOOL)isMore sort:(kSortType)sort{
    if (!isMore) {
        self.pageNo = 0;
    }
    BOOL isMain = NO;
    if ([self.coinModel.tokenAddress isEqualToString:self.coinModel.currentWallet.address]) {
        isMain = YES;//是否为主币
    }
    NSString *addr = self.coinModel.currentWallet.address;
    if ([self.coinModel.currentWallet.type isEqualToString:@"CVN"]) {
        //是否为CVN
        if(![self.coinModel.currentWallet.address.lowercaseString hasPrefix:@"cvn"]){
            addr = NSStringWithFormat(@"CVN%@",self.coinModel.currentWallet.address);
        }
    }
    NSString *type = [[SettingManager sharedInstance] getChainType];
    NSDictionary *parm = @{
        @"address":addr,
        @"type":type,
        @"contractAddress":isMain?@"":self.coinModel.tokenAddress,
        @"page":@(self.pageNo),
        @"offset":@"10",
    };
    
    [AFNetworkClient requestPostWithUrl:NSStringWithFormat(@"%@/wallet/getTransactionInfo",APPWalletBaseURL) withParameter:parm withBlock:^(id data, NSError *error) {
        if (!error) {
            if (!isMore) {
                if (self.recordList.count > 0) {
                    [self.recordList removeAllObjects];
                }
            }
            NSArray *list = data[@"data"][@"result"];
            [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                RecordModel *model = [RecordModel mj_objectWithKeyValues:obj];
                model.token_name = self.coinModel.tokenName;
                model.decimals = self.coinModel.decimals;
//                model.value = [model.value stringDownDecimal:self.coinModel.decimals];
                model.is_out = [model.from isEqualToString:self.coinModel.currentWallet.address];
                [self.recordList addObject:model];
            }];

            if (list.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
//            if (self.recordList.count <= 0) {
//                self.nodataView.hidden = NO;
//            }else{
//                self.nodataView.hidden = YES;
//            }
            NSMutableArray *timeList = [NSMutableArray array];
            NSMutableArray *hashList = [NSMutableArray array];
            if (!isMore) {
                if (self.outAndInList.count > 0) {
                    [self.outAndInList removeAllObjects];
                }
            }
            for (RecordModel *model in self.recordList) {
                CGFloat transfer_time = [model.timeStamp doubleValue]/1000;
                [timeList addObject:@(transfer_time)];
                [hashList addObject:[model.hashStr formatDelEth]];
                if (model.is_out) {//转出
                    if (sort == kSortTypeOut) {
                        [self.outAndInList addObject:model];
                    }
                }else{
                    if (sort == kSortTypeIn) {
                        [self.outAndInList addObject:model];
                    }
                }
            }
            
            //冷钱包 比较最新时间的转账记录 是否刷新，没有的话显示缓存记录
            CGFloat maxValue = [[timeList valueForKeyPath:@"@max.doubleValue"] doubleValue];
            NSArray *saveList = [[WalletRecordManager shareRecordManager] getWalletsWithAddress:self.coinModel.currentWallet.address tokenAddr:self.coinModel.tokenAddress];
            [saveList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WalletRecord *record = obj;
                record.is_out = [record.from_addr isEqualToString:self.coinModel.currentWallet.address];
                record.decimals = self.coinModel.decimals;
                if (![record.trade_id isNoEmpty]||[hashList containsObject:[record.trade_id formatDelEth]]) {
                    [[WalletRecordManager shareRecordManager] deleteRecord:record];
                }else{
                    if ([record.create_time doubleValue]/1000 > maxValue) {
                        if(record.status==0){
                            [self loadHashInfoWith:record];
                        }
                        [self.recordList insertObject:record atIndex:0];
                        if ([record.from_addr isEqualToString:self.coinModel.currentWallet.address]){
                            if (sort == kSortTypeOut) {//为转出
                                [self.outAndInList insertObject:record atIndex:0];
                            }
                        }else{//为转入
                            if (sort == kSortTypeIn) {
                                [self.outAndInList insertObject:record atIndex:0];
                            }
                        }
                    }else{
                        [[WalletRecordManager shareRecordManager] deleteRecord:record];
                    }
                }
            }];
            [self sortList];
            [self.tableView reloadData];
            if (isMore) {
                self.pageNo += 1;
            }
        } else {
        }
    }];
}
- (void)sortList {//排序
    [self.outAndInList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *timeStamp1 = nil;
        NSString *timeStamp2 = nil;
        if([obj1 isKindOfClass:[RecordModel class]]){
            timeStamp1 = ((RecordModel *)obj1).timeStamp;
        }else if([obj1 isKindOfClass:[WalletRecord class]]){
            timeStamp1 = ((WalletRecord *)obj1).create_time;
        }
        if([obj2 isKindOfClass:[RecordModel class]]){
            timeStamp2 = ((RecordModel *)obj2).timeStamp;
        }else if([obj2 isKindOfClass:[WalletRecord class]]){
            timeStamp2 = ((WalletRecord *)obj2).create_time;
        }
        if (![timeStamp1 isNoEmpty]||![timeStamp2 isNoEmpty]) {
            return NSOrderedAscending;
        }
        return [timeStamp2 compare:timeStamp1];
    }];
    [self.recordList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *timeStamp1 = nil;
        NSString *timeStamp2 = nil;
        if([obj1 isKindOfClass:[RecordModel class]]){
            timeStamp1 = ((RecordModel *)obj1).timeStamp;
        }else if([obj1 isKindOfClass:[WalletRecord class]]){
            timeStamp1 = ((WalletRecord *)obj1).create_time;
        }
        if([obj2 isKindOfClass:[RecordModel class]]){
            timeStamp2 = ((RecordModel *)obj2).timeStamp;
        }else if([obj2 isKindOfClass:[WalletRecord class]]){
            timeStamp2 = ((WalletRecord *)obj2).create_time;
        }
        if (![timeStamp1 isNoEmpty]||![timeStamp2 isNoEmpty]) {
            return NSOrderedAscending;
        }
        return [timeStamp2 compare:timeStamp1];
    }];
    [self.tableView reloadData];
}
- (void)loadHashInfoWith:(WalletRecord *)record {
    NSString *hash = record.trade_id;
    if([User_manager.currentUser.chooseWallet_type isEqualToString:@"CVN"]){
        NSDictionary *parmDic = @{@"hash":hash};
        [AFNetworkClient requestPostWithUrl:NSStringWithFormat(@"%@/fbs/%@",kCVNRPCUrl,TCT_PBGTH_DO) withParameter:parmDic withBlock:^(id data, NSError *error) {
            if (!error) {
                NSInteger status = 0;
                if(data[@"status"]==nil){
                    status = 0;
                }else if([NSStringWithFormat(@"%@",data[@"status"][@"status"]) isEqualToString:@"0x01"]){
                    status = 1;
                }else if([NSStringWithFormat(@"%@",data[@"status"][@"status"]) isEqualToString:@"0x00"]){
                    status = -1;
                }
                record.status = status;
                [[WalletRecordManager shareRecordManager] updateRecord:record];
                [self.tableView reloadData];
            }
        }];
    }else{
        NSDictionary *parmDic = @{
                    @"id":@"67",
                    @"jsonrpc":@"2.0",
                    @"method":@"eth_getTransactionReceipt",
                    @"params":@[hash]};
        [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
            if (data) {
                NSInteger status = 0;
                if(data[@"result"]==nil){
                    status = 0;
                }else if([NSStringWithFormat(@"%@",data[@"result"][@"status"]) isEqualToString:@"0x1"]){
                    status = 1;
                }else if([NSStringWithFormat(@"%@",data[@"result"][@"status"]) isEqualToString:@"0x0"]){
                    status = -1;
                }
                record.status = status;
                [[WalletRecordManager shareRecordManager] updateRecord:record];
                [self.tableView reloadData];
            }
        }];
    }
}

//AssetSortViewDelegate
- (void)clickItemWithIndex:(NSInteger)index{
    //切换 item
    self.sortType = (kSortType)index;
    [self loadRecordListIsMore:NO sort:self.sortType];
}
#pragma mark Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.sortType == kSortTypeAll) {
        if(self.recordList.count==0){
            self.noDataView.hidden = NO;
        }else{
            self.noDataView.hidden = YES;
        }
        return self.recordList.count;
    }
    if(self.outAndInList.count==0){
        self.noDataView.hidden = NO;
    }else{
        self.noDataView.hidden = YES;
    }
    return self.outAndInList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AssetTableCell";
    
    AssetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AssetTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self.sortType == kSortTypeAll) {
        [cell fillData:self.recordList[indexPath.row]];
    }else{
        [cell fillData:self.outAndInList[indexPath.row]];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor im_tableBgColor];

    [view addSubview:self.sortView];
    self.sortView.delegate = self;
    [self.sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(10);
        make.left.right.bottom.equalTo(view);
    }];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferDetailInfoVC *vc = [[TransferDetailInfoVC alloc] init];
    if (self.sortType == kSortTypeAll) {
        vc.recordModel = self.recordList[indexPath.row];
    }else{
        vc.recordModel = self.outAndInList[indexPath.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (AssetSortView *)sortView{
    if (!_sortView) {
        _sortView = [[AssetSortView alloc] init];
    }
    return _sortView;
}
- (AssetTopView *)topView{
    if (!_topView) {
        _topView = [[AssetTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    }
    return _topView;
}
- (AssetBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[AssetBottomView alloc] init];
        [_bottomView clickBtnBlock:^(NSInteger index) {
            switch (index) {
//                case 0:{
//                    //兑换
//                }
//                    break;
                case 0:{
                    //收款
                    CollectionViewController *vc = [[CollectionViewController alloc] init];
                    vc.coinModel = self.coinModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:{
                    //转账
                    TransferViewController *vc = [[TransferViewController alloc] init];
                    vc.coinModel = self.coinModel;
                    vc.transferSuccessBlock = ^{
                        [self loadRecordListIsMore:NO sort:self.sortType];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
            }
        }];
    }
    return _bottomView;
}

- (NSMutableArray *)recordList{
    if (!_recordList) {
        _recordList = [[NSMutableArray alloc] init];
    }
    return _recordList;
}
- (NSMutableArray *)outAndInList{
    if (!_outAndInList) {
        _outAndInList = [[NSMutableArray alloc] init];
    }
    return _outAndInList;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor navAndTabBackColor];
        _tableView.rowHeight = CGFloatScale(85);
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 50, 0, 0)];
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.tableHeaderView = self.topView;
        self.tableView.separatorColor = [UIColor im_borderLineColor];
    }
    return _tableView;
}
- (NoDataShowView *)noDataView {
    if(!_noDataView) {
        _noDataView = [NoDataShowView showView:self.tableView image:@"noResult" text:@"暂无数据" offsetY:self.topView.size.height*0.5];
    }
    return _noDataView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
