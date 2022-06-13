//
//  PW_MessageCenterViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MessageCenterViewController.h"
#import "MessageCenterItemsView.h"
#import "MessageTransferCell.h"
#import "MessageSystemCell.h"
#import "PW_TokenTradeDetailViewController.h"
#import "PW_MessageDetailViewController.h"

@interface PW_MessageCenterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) MessageCenterItemsView *itemView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UITableView *hashTableView;
@property (nonatomic, strong) UITableView *systemTableView;
@property (nonatomic, strong) NSMutableArray *hashArray;
@property (nonatomic, strong) NSMutableArray *systemArray;
@property (nonatomic, strong) NoDataShowView *hashNoDataView;
@property (nonatomic, strong) NoDataShowView *systemNoDataView;

@end

@implementation PW_MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_messageCenter")];
    [self makeViews];
    __weak typeof(self) weakSelf = self;
    self.hashTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    self.systemTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.hashTableView.mj_header beginRefreshing];
}
- (void)makeViews{
    [self.view addSubview:self.itemView];
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.hashTableView];
    [self.contentScrollView addSubview:self.systemTableView];
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.height.equalTo(@35);
    }];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.hashTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.equalTo(self.contentScrollView);
    }];
    [self.systemTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hashTableView.mas_right);
        make.top.width.height.equalTo(self.contentScrollView);
    }];
    self.hashNoDataView = [NoDataShowView showView:self.hashTableView image:@"noResult" text:LocalizedStr(@"text_noData")];
    self.systemNoDataView = [NoDataShowView showView:self.systemTableView image:@"noResult" text:LocalizedStr(@"text_noData")];
}
- (void)loadData {
    NSInteger index = self.index;
    NSString *chainId = User_manager.currentUser.current_chainId;
    NSString *address = User_manager.currentUser.chooseWallet_address;
    NSDictionary *params = @{
        @"chainId":chainId,
        @"fromAddress":address,
        @"pageNumber":@"0",
        @"pageSize":@"20"
    };
    NSString *urlStr = index==0?WalletMessageHashPageURL:WalletMessageSysPageURL;
    [self pw_requestApi:urlStr params:params completeBlock:^(id data) {
        if(index==0){
            [self.hashTableView.mj_header endRefreshing];
            NSArray *array = data[@"content"];
            [self.hashArray removeAllObjects];
            [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PW_TokenDetailModel *model = [[PW_TokenDetailModel alloc] init];
                model.tokenName = obj[@"symbol"];
                model.value = obj[@"amount"];
                model.timeStr = obj[@"createTime"];
                model.contractAddress = obj[@"contract"];
                model.fromAddress = obj[@"fromAddress"];
                model.toAddress = obj[@"toAddress"];
                model.hashStr = obj[@"txHash"];
                model.isOut = [model.fromAddress isEqualToString:address];
                model.transactionStatus = 1;
                [self.hashArray addObject:model];
            }];
            [self.hashTableView reloadData];
            if(self.hashArray.count>0) {
                [self.hashNoDataView dismissView];
            }
        }else{
            [self.systemTableView.mj_header endRefreshing];
            self.systemArray = [MessageSystemModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [self.systemTableView reloadData];
            if(self.systemArray.count>0) {
                [self.systemNoDataView dismissView];
            }
        }
    } errBlock:^(NSString *msg) {
        [self showError:msg];
        if(index==0){
            [self.hashTableView.mj_header endRefreshing];
        }else{
            [self.systemTableView.mj_header endRefreshing];
        }
    }];
}
- (void)itemChangeIndex:(NSInteger)index {
    self.index = index;
    [self.contentScrollView setContentOffset:CGPointMake(index*self.contentScrollView.bounds.size.width, 0) animated:YES];
    if(index==0){
        if(self.hashArray.count==0){
            [self.hashTableView.mj_header beginRefreshing];
        }
    }else{
        if(self.systemArray.count==0){
            [self.systemTableView.mj_header beginRefreshing];
        }
    }
}
#pragma mark - UIScrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView==self.contentScrollView){
        self.index = (int)(scrollView.contentOffset.x/scrollView.bounds.size.width);
        [self.itemView setIndex:self.index];
    }
}
#pragma mark - UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.hashTableView){
        return self.hashArray.count;
    }
    return self.systemArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.hashTableView){
        MessageTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTransferCell"];
        cell.model = self.hashArray[indexPath.row];
        return cell;
    }
    MessageSystemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageSystemCell"];
    cell.model = self.systemArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.hashTableView){
        return [tableView fd_heightForCellWithIdentifier:@"MessageTransferCell" cacheByIndexPath:indexPath configuration:^(MessageTransferCell *cell) {
            cell.model = self.hashArray[indexPath.row];
        }];
    }else{
        return 60;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView==self.hashTableView){
        PW_TokenTradeDetailViewController *vc = [[PW_TokenTradeDetailViewController alloc] init];
        vc.model = self.hashArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MessageSystemModel *model = self.systemArray[indexPath.row];
        PW_MessageDetailViewController *vc = [[PW_MessageDetailViewController alloc] init];
        vc.mid = model.mid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (MessageCenterItemsView *)itemView{
    if (!_itemView) {
        _itemView = [[MessageCenterItemsView alloc] init];
        __weak typeof(self) weakSelf = self;
        _itemView.clickBlock = ^(NSInteger index) {
            [weakSelf itemChangeIndex:index];
        };
    }
    return _itemView;
}
- (UIScrollView *)contentScrollView {
    if(!_contentScrollView){
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.delegate = self;
        _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
    }
    return _contentScrollView;
}
- (UITableView *)hashTableView {
    if(!_hashTableView){
        _hashTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _hashTableView.delegate = self;
        _hashTableView.dataSource = self;
        _hashTableView.rowHeight = 60;
        [_hashTableView registerNib:[UINib nibWithNibName:@"MessageTransferCell" bundle:nil] forCellReuseIdentifier:@"MessageTransferCell"];
    }
    return _hashTableView;
}
- (UITableView *)systemTableView {
    if(!_systemTableView){
        _systemTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _systemTableView.delegate = self;
        _systemTableView.dataSource = self;
        _systemTableView.rowHeight = 60;
        [_systemTableView registerNib:[UINib nibWithNibName:@"MessageSystemCell" bundle:nil] forCellReuseIdentifier:@"MessageSystemCell"];
    }
    return _systemTableView;
}
- (NSMutableArray *)hashArray {
    if(!_hashArray){
        _hashArray = [NSMutableArray array];
    }
    return _hashArray;
}
- (NSMutableArray *)systemArray {
    if(!_systemArray){
        _systemArray = [NSMutableArray array];
    }
    return _systemArray;
}

@end
