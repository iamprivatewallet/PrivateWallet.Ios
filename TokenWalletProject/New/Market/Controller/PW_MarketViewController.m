//
//  PW_MarketViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MarketViewController.h"
#import "PW_MarketHeaderView.h"
#import "PW_MarketCell.h"
#import <SocketRocket.h>
#import "PW_MarketMenuModel.h"

@interface PW_MarketViewController () <UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_MarketModel *> *dataArr;

@property (nonatomic, strong) SRWebSocket *webSocket;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) NSArray<PW_MarketMenuModel *> *menuArr;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation PW_MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_markets")];
    [self setupNavBgGreen];
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
- (void)menuChangeAction {
    [self refreshWithIndex:self.segmentedControl.selectedSegmentIndex];
}
- (void)buildData {
    [self refreshWithIndex:1];
}
- (void)refreshWithIndex:(NSInteger)index {
    self.segmentedControl.selectedSegmentIndex = index;
    NSInteger selectedIndex = index;
    if (selectedIndex<0||selectedIndex>=self.menuArr.count) {
        return;
    }
    for (NSInteger i=0;i<self.menuArr.count;i++) {
        PW_MarketMenuModel *model = self.menuArr[i];
        model.selected = i==index;
        if (model.selected) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:model.dataArr];
        }
    }
    [self refreshTableData];
}
- (void)refershDataWithDataArr:(NSArray<PW_MarketModel *> *)array {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    NSMutableArray *selectionArr = [NSMutableArray array];
    for (PW_MarketModel *model in array) {
        model.collection = [[PW_MarketManager shared] isExistWithSymbol:model.symbol]!=nil;
        if (model.type>0&&model.type<self.menuArr.count) {
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
        if (key.integerValue>=0&&key.integerValue<self.menuArr.count) {
            self.menuArr[key.integerValue].dataArr = dataDict[key];
        }
    }
    [self refreshTableData];
}
- (void)refreshTableData {
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:self.menuArr[self.segmentedControl.selectedSegmentIndex].dataArr];
    [self.tableView reloadData];
    self.noDataView.hidden = self.dataArr.count>0;
}
- (void)addRemoveSelectionWithModel:(PW_MarketModel *)model {
    NSArray *array = self.menuArr.firstObject.dataArr;
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
    self.menuArr.firstObject.dataArr = [selectionArr copy];
    [self refreshTableData];
}
- (void)makeViews {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [self.contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [self.contentView addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
        make.left.offset(36);
        make.height.offset(38);
    }];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom).offset(20);
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
        [self showSuccess:LocalizedStr(model.collection?@"text_addFavorites":@"text_removeFavorites")];
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
        _tableView.rowHeight = 75;
        _tableView.sectionHeaderHeight = 30;
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
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor g_bgColor];
    }
    return _contentView;
}
- (NSArray<PW_MarketMenuModel *> *)menuArr {
    if (!_menuArr) {
        PW_MarketMenuModel *model1 = [PW_MarketMenuModel ModelTitle:LocalizedStr(@"text_selfSelection")];
        PW_MarketMenuModel *model2 = [PW_MarketMenuModel ModelTitle:LocalizedStr(@"text_mainstreamCurrency")];
        PW_MarketMenuModel *model3 = [PW_MarketMenuModel ModelTitle:@"DeFi"];
        PW_MarketMenuModel *model4 = [PW_MarketMenuModel ModelTitle:@"NFT"];
        _menuArr = @[model1,model2,model3,model4];
    }
    return _menuArr;
}
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        NSMutableArray *titles = [NSMutableArray array];
        for (int i=0; i<self.menuArr.count; i++) {
            [titles addObject:self.menuArr[i].title];
        }
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:titles];
        _segmentedControl.apportionsSegmentWidthsByContent = YES;
        [_segmentedControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentedControl setBackgroundImage:[UIImage imageWithColor:[UIColor g_hex:@"#7221F4"] size:CGSizeMake(1, 1)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        UIImage *dividerImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
        [_segmentedControl setDividerImage:dividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        _segmentedControl.tintColor = [UIColor g_hex:@"#7221F4"];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        [_segmentedControl setBorderColor:[UIColor g_hex:@"#7221F4"] width:1 radius:8];
        if (@available(iOS 13.0, *)) {
            _segmentedControl.selectedSegmentTintColor = [UIColor g_hex:@"#7221F4"];
        } else {
            // Fallback on earlier versions
        }
        [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont pw_mediumFontOfSize:18],NSForegroundColorAttributeName:[UIColor g_textColor]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont pw_mediumFontOfSize:18],NSForegroundColorAttributeName:[UIColor g_whiteTextColor]} forState:UIControlStateSelected];
        [_segmentedControl addTarget:self action:@selector(menuChangeAction) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

@end
