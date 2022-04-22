//
//  PW_MarketViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MarketViewController.h"
#import "PW_MarketMenuView.h"
#import "PW_MarketHeaderView.h"
#import "PW_MarketCell.h"
#import <SocketRocket.h>

@interface PW_MarketViewController () <UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate>

@property (nonatomic, strong) PW_MarketMenuView *menuView;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_MarketModel *> *dataArr;

@property (nonatomic, strong) SRWebSocket *webSocket;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation PW_MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeViews];
    [self buildData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redRoseGreenFellAction) name:kRedRoseGreenFellNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webSocket open];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.webSocket close];
    self.webSocket = nil;
}
- (void)postWebSocketMessage {
    NSString *uuid = [NSString deviceUUID];
    //1.主流币、2.DeFi、3.NFT
    NSDictionary *params = @{@"action":@"market.last.price",@"deviceId":[uuid MD5Hash],@"type":@"0",@"symbol":@""};
    NSError *error = nil;
    [self.webSocket sendString:params.mj_JSONString error:&error];
    NSLog(@"error=%@",error);
}
- (void)redRoseGreenFellAction {
    [self.tableView reloadData];
}
- (void)buildData {
    PW_MarketMenuModel *model1 = [PW_MarketMenuModel ModelTitle:LocalizedStr(@"text_selfSelection")];
    PW_MarketMenuModel *model2 = [PW_MarketMenuModel ModelTitle:LocalizedStr(@"text_mainstreamCurrency")];
    PW_MarketMenuModel *model3 = [PW_MarketMenuModel ModelTitle:@"DeFi"];
    PW_MarketMenuModel *model4 = [PW_MarketMenuModel ModelTitle:@"NFT"];
    self.menuView.dataArr = @[model1,model2,model3,model4];
    __weak typeof(self) weakSelf = self;
    self.menuView.clickBlock = ^(NSInteger idx, PW_MarketMenuModel * _Nonnull model) {
        [weakSelf refreshWithIndex:idx];
    };
    [self refreshWithIndex:1];
}
- (void)refreshWithIndex:(NSInteger)index {
    if (self.selectedIndex==index||self.selectedIndex<0||self.selectedIndex>=self.menuView.dataArr.count) {
        return;
    }
    self.selectedIndex = index;
    for (NSInteger i=0;i<self.menuView.dataArr.count;i++) {
        PW_MarketMenuModel *model = self.menuView.dataArr[i];
        model.selected = i==index;
        if (model.selected) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:model.dataArr];
        }
    }
    self.menuView.dataArr = self.menuView.dataArr;
    [self refreshTableData];
}
- (void)refershDataWithDataArr:(NSArray<PW_MarketModel *> *)array {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    NSMutableArray *selectionArr = [NSMutableArray array];
    for (PW_MarketModel *model in array) {
        model.collection = [[PW_MarketManager shared] isExistWithSymbol:model.symbol]!=nil;
        if (model.type>0&&model.type<self.menuView.dataArr.count) {
            NSArray *array = dataDict[@(model.type).stringValue];
            if (array&&array.count>0) {
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:array];
                [tempArr addObject:model];
                dataDict[@(model.type).stringValue] = tempArr;
            }else{
                NSMutableArray *tempArr = [NSMutableArray array];
                [tempArr addObject:model];
                dataDict[@(model.type).stringValue] = tempArr;
            }
        }
        if (model.collection) {
            [selectionArr addObject:model];
        }
    }
    dataDict[@"0"] = selectionArr;
    for (NSString *key in dataDict.allKeys) {
        if (key.integerValue>=0&&key.integerValue<self.menuView.dataArr.count) {
            self.menuView.dataArr[key.integerValue].dataArr = dataDict[key];
        }
    }
    [self refreshTableData];
}
- (void)refreshTableData {
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:self.menuView.dataArr[self.selectedIndex].dataArr];
    [self.tableView reloadData];
    self.noDataView.hidden = self.dataArr.count>0;
}
- (void)addRemoveSelectionWithModel:(PW_MarketModel *)model {
    NSArray *array = self.menuView.dataArr.firstObject.dataArr;
    NSMutableArray *selectionArr = [NSMutableArray arrayWithArray:array?array:@[]];
    if (model.collection) {
        [[PW_MarketManager shared] saveModel:model];
        if (![selectionArr containsObject:model]) {
            [selectionArr addObject:model];
        }
    }else{
        [[PW_MarketManager shared] deleteModel:model];
        [selectionArr removeObject:model];
    }
    self.menuView.dataArr.firstObject.dataArr = [selectionArr copy];
    [self refreshTableData];
}
- (void)makeViews {
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_market_topBg"]];
    [self.view addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_quotation") fontSize:21 textColor:[UIColor g_boldTextColor]];
    [self.view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(StatusHeight+10);
    }];
    self.menuView = [[PW_MarketMenuView alloc] init];
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(StatusHeight+50);
        make.height.offset(38);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
}
#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_MarketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_MarketCell"];
    cell.model = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.collectionBlock = ^(PW_MarketModel * _Nonnull model) {
        model.collection = !model.collection;
        [weakSelf addRemoveSelectionWithModel:model];
    };
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PW_MarketHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PW_MarketHeaderView"];
    return view;
}
#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    [self postWebSocketMessage];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"error=%@",error);
    _webSocket = nil;
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"error=%@",reason);
    _webSocket = nil;
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(NSString *)string {
    NSDictionary *resultDict = string.mj_JSONObject;
    if ([resultDict isKindOfClass:[NSDictionary class]]) {
        NSArray *array = resultDict[@"data"];
        NSArray *dataArr = [PW_MarketModel mj_objectArrayWithKeyValuesArray:array];
        [self refershDataWithDataArr:dataArr];
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PW_MarketHeaderView class] forHeaderFooterViewReuseIdentifier:@"PW_MarketHeaderView"];
        [_tableView registerClass:[PW_MarketCell class] forCellReuseIdentifier:@"PW_MarketCell"];
        _tableView.rowHeight = 70;
        _tableView.sectionHeaderHeight = 50;
        _tableView.sectionFooterHeight = 5;
    }
    return _tableView;
}
- (NSMutableArray<PW_MarketModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
- (SRWebSocket *)webSocket {
    if (!_webSocket) {
        NSURL *url = [NSURL URLWithString:WalletMarketTickerWS];
        _webSocket = [[SRWebSocket alloc] initWithURL:url];
        _webSocket.delegate = self;
    }
    return _webSocket;
}

@end
