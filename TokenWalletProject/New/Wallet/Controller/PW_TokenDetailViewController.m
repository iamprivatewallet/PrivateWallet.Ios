//
//  PW_TokenDetailViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/5.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TokenDetailViewController.h"
#import "PW_TokenDetailCell.h"
#import "PW_CollectionViewController.h"
#import "PW_TransferViewController.h"
#import "PW_TokenInfoViewController.h"
#import "PW_TokenTradeDetailViewController.h"

typedef enum : NSUInteger {
    kFilterTypeAll=0,
    kFilterTypeIn=2,
    kFilterTypeOut=1,
} kFilterType;

@interface PW_TokenDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *amountLb;
@property (nonatomic, strong) UILabel *fullNameLb;
@property (nonatomic, strong) UILabel *costLb;

@property (nonatomic, strong) UISegmentedControl *menuControl;

@property (nonatomic, strong) NSMutableArray<PW_TokenDetailModel *> *dataList;
@property (nonatomic, strong) NSMutableArray<PW_TokenDetailModel *> *showList;
@property (nonatomic, assign) kFilterType filterType;

@end

@implementation PW_TokenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_tokenDetail") rightImg:@"icon_info_primary" rightAction:@selector(infoAction)];
    [self makeViews];
    self.noDataView.offsetY = 100;
    User *user = User_manager.currentUser;
    if(![user.chooseWallet_type isEqualToString:kWalletTypeCVN]&&(self.model.tokenDecimals==0||![self.model.tokenAmount isNoEmpty]||self.model.tokenAmount.doubleValue==0)){
        if(self.model.tokenDecimals==0&&(![self.model.tokenAmount isNoEmpty]||self.model.tokenAmount.doubleValue==0)){
            [[PWWalletContractTool shared] decimalsERC20WithContractAddress:self.model.tokenContract completionHandler:^(NSInteger decimals, NSString * _Nullable errMsg) {
                if(errMsg==nil){
                    self.model.tokenDecimals = decimals;
                    [self requestData];
                    [[PWWalletContractTool shared] balanceERC20WithAddress:user.chooseWallet_address contractAddress:self.model.tokenContract completionHandler:^(NSString * _Nullable amount, NSString * _Nullable errMsg) {
                        if(errMsg==nil){
                            self.model.tokenAmount = [amount stringDownDividingBy10Power:decimals];
                            [self refreshTopData];
                        }
                    }];
                }
            }];
        }else if(self.model.tokenDecimals==0){
            [[PWWalletContractTool shared] decimalsERC20WithContractAddress:self.model.tokenContract completionHandler:^(NSInteger decimals, NSString * _Nullable errMsg) {
                if(errMsg==nil){
                    self.model.tokenDecimals = decimals;
                    [self requestData];
                }
            }];
        }else{
            [self requestData];
            [[PWWalletContractTool shared] balanceERC20WithAddress:user.chooseWallet_address contractAddress:self.model.tokenContract completionHandler:^(NSString * _Nullable amount, NSString * _Nullable errMsg) {
                if(errMsg==nil){
                    self.model.tokenAmount = [amount stringDownDividingBy10Power:self.model.tokenDecimals];
                    [self refreshTopData];
                }
            }];
        }
    }else{
        [self requestData];
    }
    [self refreshTopData];
}
- (void)infoAction {
    PW_TokenInfoViewController *vc = [[PW_TokenInfoViewController alloc] init];
    vc.tokenId = self.model.tId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)menuChangeAction {
    self.filterType = self.menuControl.selectedSegmentIndex;
    [self refreshData];
}
- (void)transferAction {
    PW_TransferViewController *vc = [PW_TransferViewController new];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)collectionAction {
    PW_CollectionViewController *vc = [PW_CollectionViewController new];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)headerBtnAction:(UIButton *)btn {
    
}
- (void)requestData {
    NSString *contractAddress = self.model.tokenContract;
    NSString *currentAddr = User_manager.currentUser.chooseWallet_address;
    if ([self.model.tokenContract isEqualToString:currentAddr]) {
        contractAddress = @"";
    }
    if ([User_manager.currentUser.chooseWallet_type isEqualToString:kWalletTypeCVN]) {
        if(![currentAddr.lowercaseString hasPrefix:@"cvn"]){
            currentAddr = NSStringWithFormat(@"CVN%@",currentAddr);
        }
    }
    NSString *type = [[SettingManager sharedInstance] getChainType];
    NSDictionary *params = @{
        @"address":currentAddr,
        @"type":type,
        @"contractAddress":contractAddress,
        @"page":@"0",
        @"offset":@"20",
    };
    [self.view showLoadingIndicator];
    [self pw_requestWallet:WalletTokenDetailURL params:params completeBlock:^(id  _Nonnull data) {
        [self.view hideLoadingIndicator];
        [self.dataList removeAllObjects];
        [self.showList removeAllObjects];
        self.dataList = [PW_TokenDetailModel mj_objectArrayWithKeyValuesArray:data];
        NSMutableArray *timeList = [NSMutableArray array];
        NSMutableArray *hashList = [NSMutableArray array];
        [self.dataList enumerateObjectsUsingBlock:^(PW_TokenDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.tokenName = self.model.tokenName;
            obj.tokenDecimals = self.model.tokenDecimals;
            obj.tokenLogo = self.model.tokenLogo;
            obj.transactionStatus = 1;
            obj.value = [obj.value stringDownDividingBy10Power:self.model.tokenDecimals];
            obj.isOut = [obj.fromAddress isEqualToString:currentAddr];
            CGFloat transfer_time = obj.timeStamp/1000;
            [timeList addObject:@(transfer_time)];
            [hashList addObject:[obj.hashStr formatDelEth]];
        }];
        //冷钱包 比较最新时间的转账记录 是否刷新，没有的话显示缓存记录
        CGFloat maxValue = [[timeList valueForKeyPath:@"@max.doubleValue"] doubleValue];
        NSArray *saveList = [[PW_TokenTradeRecordManager shared] getWalletsWithAddress:currentAddr tokenAddr:self.model.tokenContract];
        [saveList enumerateObjectsUsingBlock:^(PW_TokenDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.tokenName = self.model.tokenName;
            obj.tokenDecimals = self.model.tokenDecimals;
            obj.isOut = [obj.fromAddress isEqualToString:currentAddr];
            if (![obj.hashStr isNoEmpty]||[hashList containsObject:[obj.hashStr formatDelEth]]) {
                [[PW_TokenTradeRecordManager shared] deleteRecord:obj];
            }else{
                if (obj.timeStamp/1000 > maxValue) {
                    if(obj.transactionStatus==0){
                        [self loadHashInfoWith:obj];
                    }
                    [self.dataList insertObject:obj atIndex:0];
                }else{
                    [[PW_TokenTradeRecordManager shared] deleteRecord:obj];
                }
            }
        }];
        [self refreshData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self.view hideLoadingIndicator];
    }];
}
- (void)loadHashInfoWith:(PW_TokenDetailModel *)model {
    NSString *hashStr = model.hashStr;
    if([User_manager.currentUser.chooseWallet_type isEqualToString:kWalletTypeCVN]){
        NSDictionary *parmDic = @{@"hash":hashStr};
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
                model.transactionStatus = status;
                [[PW_TokenTradeRecordManager shared] updateRecord:model];
                [self.tableView reloadData];
            }
        }];
    }else{
        NSDictionary *parmDic = @{
                    @"id":@"67",
                    @"jsonrpc":@"2.0",
                    @"method":@"eth_getTransactionReceipt",
                    @"params":@[hashStr]};
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
                model.transactionStatus = status;
                [[PW_TokenTradeRecordManager shared] updateRecord:model];
                [self.tableView reloadData];
            }
        }];
    }
}
- (void)refreshData {
    [self.showList removeAllObjects];
    if(self.filterType == kFilterTypeIn||self.filterType == kFilterTypeOut){
        for (PW_TokenDetailModel *model in self.dataList) {
            if (model.isOut) {
                if (self.filterType == kFilterTypeOut) {
                    [self.showList addObject:model];
                }
            }else if (self.filterType == kFilterTypeIn) {
                [self.showList addObject:model];
            }
        }
    }else{
        [self.showList addObjectsFromArray:self.dataList];
    }
    self.noDataView.hidden = self.showList.count>0;
    [self sortShowList];
}
- (void)sortShowList {
    [self.showList sortUsingComparator:^NSComparisonResult(PW_TokenDetailModel * _Nonnull obj1, PW_TokenDetailModel * _Nonnull obj2) {
        NSString *timeStamp1 = @(obj1.timeStamp).stringValue;
        NSString *timeStamp2 = @(obj1.timeStamp).stringValue;
        if (![timeStamp1 isNoEmpty]||![timeStamp2 isNoEmpty]) {
            return NSOrderedAscending;
        }
        return [timeStamp2 compare:timeStamp1];
    }];
    [self.tableView reloadData];
}
- (void)refreshTopData {
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:self.model.tokenLogo] placeholderImage:[UIImage imageNamed:@"icon_token_default"]];
    self.nameLb.text = self.model.tokenName;
    self.amountLb.text = self.model.tokenAmount;
    self.fullNameLb.text = self.model.tokenName;
    self.costLb.text = [self.model.tokenAmount isNoEmpty]?NSStringWithFormat(@"≈ $%@",[self.model.tokenAmount stringDownMultiplyingBy:self.model.price decimal:8]):@"--";
}
- (void)makeViews {
    self.topView = [[UIView alloc] init];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.right.offset(0);
        make.height.offset(90);
    }];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(5);
        make.left.bottom.right.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [contentView addSubview:self.menuControl];
    [contentView addSubview:self.tableView];
    [self.menuControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(36);
        make.left.offset(36);
        make.right.mas_lessThanOrEqualTo(-36);
        make.height.offset(38);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuControl.mas_bottom).offset(10);
        make.left.right.bottom.offset(0);
    }];
    [self createTopItems];
}
- (void)createTopItems {
    self.iconIv = [[UIImageView alloc] init];
    [self.topView addSubview:self.iconIv];
    self.nameLb = [PW_ViewTool labelText:@"--" fontSize:14 textColor:[UIColor g_whiteTextColor]];
    [self.topView addSubview:self.nameLb];
    self.amountLb = [PW_ViewTool labelMediumText:@"--" fontSize:23 textColor:[UIColor g_whiteTextColor]];
    [self.topView addSubview:self.amountLb];
    self.costLb = [PW_ViewTool labelText:@"--" fontSize:14 textColor:[UIColor g_whiteTextColor]];
    [self.topView addSubview:self.costLb];
    UIButton *transferBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_transfer") fontSize:14 titleColor:[UIColor g_whiteTextColor] imageName:@"icon_transfer" target:self action:@selector(transferAction)];
    [self.topView addSubview:transferBtn];
    UIButton *collectionBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_collection") fontSize:14 titleColor:[UIColor g_whiteTextColor] imageName:@"icon_collection" target:self action:@selector(collectionAction)];
    [self.topView addSubview:collectionBtn];
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.mas_centerY).offset(-6);
        make.right.offset(-18);
    }];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-18);
        make.top.equalTo(self.topView.mas_centerY).offset(6);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(10);
        make.width.height.offset(80);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.amountLb);
        make.bottom.equalTo(self.amountLb.mas_top).offset(2);
    }];
    [self.amountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(8);
        make.centerY.offset(0);
    }];
    [self.costLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.amountLb);
        make.top.equalTo(self.amountLb.mas_bottom).offset(2);
    }];
}
#pragma make - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_TokenDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_TokenDetailCell"];
    NSAssert(cell, @"cell is nil");
    cell.model = self.showList[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_TokenTradeDetailViewController *vc = [[PW_TokenTradeDetailViewController alloc] init];
    vc.model = self.showList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma make - lazy
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PW_TokenDetailCell class] forCellReuseIdentifier:@"PW_TokenDetailCell"];
        _tableView.rowHeight = 76;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSMutableArray<PW_TokenDetailModel *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
- (NSMutableArray<PW_TokenDetailModel *> *)showList {
    if (!_showList) {
        _showList = [NSMutableArray array];
    }
    return _showList;
}
- (UISegmentedControl *)menuControl {
    if (!_menuControl) {
        NSArray *titles = @[LocalizedStr(@"text_all"),LocalizedStr(@"text_transfer"),LocalizedStr(@"text_collection")];
        _menuControl = [PW_ViewTool segmentedControlWithTitles:titles];
        _menuControl.selectedSegmentIndex = 0;
        [_menuControl addTarget:self action:@selector(menuChangeAction) forControlEvents:UIControlEventValueChanged];
    }
    return _menuControl;
}

@end
