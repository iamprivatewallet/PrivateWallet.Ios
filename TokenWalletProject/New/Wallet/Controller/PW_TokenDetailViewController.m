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
#import "PW_TokenInfoViewController.h"
#import "PW_TokenTradeDetailViewController.h"

typedef enum : NSUInteger {
    kFilterTypeAll=0,
    kFilterTypeIn,
    kFilterTypeOut,
} kFilterType;

@interface PW_TokenDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, weak) UIButton *selectedBtn;

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *amountLb;
@property (nonatomic, strong) UILabel *fullNameLb;
@property (nonatomic, strong) UILabel *costLb;

@property (nonatomic, strong) NSMutableArray<PW_TokenDetailModel *> *dataList;
@property (nonatomic, strong) NSMutableArray<PW_TokenDetailModel *> *showList;
@property (nonatomic, assign) kFilterType filterType;

@end

@implementation PW_TokenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_tokenDetail") rightImg:@"icon_question" rightAction:@selector(infoAction)];
    [self makeViews];
    self.noDataView.offsetY = 100;
    if(![User_manager.currentUser.chooseWallet_type isEqualToString:@"CVN"]&&(self.model.tokenDecimals==0||[self.model.tokenAmount isEmptyStr]||self.model.tokenAmount.doubleValue==0)){
        if(self.model.tokenDecimals==0&&([self.model.tokenAmount isEmptyStr]||self.model.tokenAmount.doubleValue==0)){
            [MOSWalletContractTool getDecimalsERC20WithContractAddress:self.model.tokenContract completionBlock:^(NSInteger decimals, NSString * _Nullable errMsg) {
                if(errMsg==nil){
                    self.model.tokenDecimals = decimals;
                    [self requestData];
                    [MOSWalletContractTool getBalanceERC20WithContractAddress:self.model.tokenContract completionBlock:^(NSString * _Nullable amount, NSString * _Nullable errMsg) {
                        if(errMsg==nil){
                            self.model.tokenAmount = [amount stringDownDividingBy10Power:decimals];
                            [self refreshTopData];
                        }
                    }];
                }
            }];
        }else if(self.model.tokenDecimals==0){
            [MOSWalletContractTool getDecimalsERC20WithContractAddress:self.model.tokenContract completionBlock:^(NSInteger decimals, NSString * _Nullable errMsg) {
                if(errMsg==nil){
                    self.model.tokenDecimals = decimals;
                    [self requestData];
                }
            }];
        }else{
            [self requestData];
            [MOSWalletContractTool getBalanceERC20WithContractAddress:self.model.tokenContract completionBlock:^(NSString * _Nullable amount, NSString * _Nullable errMsg) {
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
- (void)transferAction {
    
}
- (void)collectionAction {
    PW_CollectionViewController *vc = [PW_CollectionViewController new];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)headerBtnAction:(UIButton *)btn {
    self.selectedBtn.selected = NO;
    self.selectedBtn = btn;
    self.selectedBtn.selected = YES;
    self.filterType = btn.tag;
    [self refreshData];
}
- (void)requestData {
    NSString *contractAddress = self.model.tokenContract;
    NSString *currentAddr = User_manager.currentUser.chooseWallet_address;
    if ([self.model.tokenContract isEqualToString:currentAddr]) {
        contractAddress = @"";
    }
    if ([User_manager.currentUser.chooseWallet_type isEqualToString:@"CVN"]) {
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
            if ([obj.hashStr isEmptyStr]||[hashList containsObject:[obj.hashStr formatDelEth]]) {
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
    if([User_manager.currentUser.chooseWallet_type isEqualToString:@"CVN"]){
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
        if ([timeStamp1 isEmptyStr]||[timeStamp2 isEmptyStr]) {
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
    self.costLb.text = [self.model.tokenAmount isNoEmpty]?NSStringWithFormat(@"$%@",[self.model.tokenAmount stringDownMultiplyingBy:self.model.price decimal:8]):@"--";
}
- (void)makeViews {
    self.topView = [[UIView alloc] init];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(210);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(40);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
    [self createTopItems];
    [self createHeaderItems];
}
- (void)createTopItems {
    self.iconIv = [[UIImageView alloc] init];
    [self.topView addSubview:self.iconIv];
    self.nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    [self.topView addSubview:self.nameLb];
    self.amountLb = [PW_ViewTool labelMediumText:@"--" fontSize:24 textColor:[UIColor g_boldTextColor]];
    [self.topView addSubview:self.amountLb];
    self.fullNameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.topView addSubview:self.fullNameLb];
    self.costLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.topView addSubview:self.costLb];
    UIView *transferView = [[UIView alloc] init];
    [transferView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [transferView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [transferView addTapTarget:self action:@selector(transferAction)];
    [self.topView addSubview:transferView];
    UIView *collectionView = [[UIView alloc] init];
    [collectionView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [collectionView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [collectionView addTapTarget:self action:@selector(collectionAction)];
    [self.topView addSubview:collectionView];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.left.offset(25);
        make.width.height.offset(55);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(14);
        make.top.equalTo(self.iconIv).offset(8);
    }];
    [self.amountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-25);
        make.top.equalTo(self.iconIv).offset(3);
    }];
    [self.fullNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(14);
        make.bottom.equalTo(self.iconIv.mas_bottom).offset(-8);
    }];
    [self.costLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-25);
        make.bottom.equalTo(self.iconIv.mas_bottom).offset(-3);
    }];
    [transferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIv.mas_bottom).offset(25);
        make.left.offset(25);
        make.height.offset(86);
    }];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIv.mas_bottom).offset(25);
        make.left.equalTo(transferView.mas_right).offset(15);
        make.right.offset(-25);
        make.height.offset(86);
        make.width.equalTo(transferView);
    }];
    UIImageView *transferIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_transfer_big"]];
    [transferView addSubview:transferIv];
    UILabel *transferLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_transfer") fontSize:15 textColor:[UIColor g_boldTextColor]];
    [transferView addSubview:transferLb];
    UIImageView *collectionIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collection_big"]];
    [collectionView addSubview:collectionIv];
    UILabel *collectionLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_collection") fontSize:15 textColor:[UIColor g_boldTextColor]];
    [collectionView addSubview:collectionLb];
    [transferIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.centerX.offset(0);
    }];
    [transferLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-15);
        make.centerX.offset(0);
    }];
    [collectionIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.centerX.offset(0);
    }];
    [collectionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-15);
        make.centerX.offset(0);
    }];
}
- (void)createHeaderItems {
    UIButton *allBtn = [self createHeaderBtnTitle:LocalizedStr(@"text_all") action:@selector(headerBtnAction:)];
    allBtn.tag = kFilterTypeAll;
    allBtn.selected = YES;
    [self.headerView addSubview:allBtn];
    self.selectedBtn = allBtn;
    UIButton *collectionBtn = [self createHeaderBtnTitle:LocalizedStr(@"text_collection") action:@selector(headerBtnAction:)];
    collectionBtn.tag = kFilterTypeIn;
    [self.headerView addSubview:collectionBtn];
    UIButton *transferBtn = [self createHeaderBtnTitle:LocalizedStr(@"text_transfer") action:@selector(headerBtnAction:)];
    transferBtn.tag = kFilterTypeOut;
    [self.headerView addSubview:transferBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.centerY.offset(0);
        make.top.bottom.offset(0);
    }];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(allBtn.mas_right).offset(20);
        make.centerY.offset(0);
        make.top.bottom.offset(0);
    }];
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collectionBtn.mas_right).offset(20);
        make.centerY.offset(0);
        make.top.bottom.offset(0);
    }];
}
- (UIButton *)createHeaderBtnTitle:(NSString *)title action:(SEL)action {
    PW_Button *btn = [PW_Button buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor g_grayTextColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor g_boldTextColor] forState:UIControlStateSelected];
    btn.normalFont = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    btn.selectedFont = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
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
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PW_TokenDetailCell class] forCellReuseIdentifier:@"PW_TokenDetailCell"];
        _tableView.rowHeight = 70;
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

@end
