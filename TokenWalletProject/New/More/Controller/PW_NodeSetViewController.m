//
//  PW_NodeSetViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NodeSetViewController.h"
#import "PW_NetworkModel.h"
#import "PW_NodeSetCell.h"
#import "PW_NodeListViewController.h"

@interface PW_NodeSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_NetworkModel *> *dataArr;

@end

@implementation PW_NodeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_nodeSet")];
    [self makeViews];
    [self requestData];
}
- (void)requestData {
    [self.view showLoadingIndicator];
    [self pw_requestApi:WalletTokenChainURL params:nil completeBlock:^(id data) {
        [self.view hideLoadingIndicator];
        [self.dataArr removeAllObjects];
        NSArray *array = [PW_NetworkModel mj_objectArrayWithKeyValuesArray:data];
        for (PW_NetworkModel *model in array) {
            PW_NetworkModel *netModel = [[PW_NodeManager shared] getSelectedNodeWithChainId:model.chainId];
            if(netModel){
                model.rpcUrl = netModel.rpcUrl;
            }
            if(![model.rpcUrl isNoEmpty]){
                model.rpcUrl = [[SettingManager sharedInstance] getNodeWithChainId:model.chainId];
            }
            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self.view hideLoadingIndicator];
        [self showError:msg];
    }];
}
- (void)makeViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(20);
        make.left.right.bottom.offset(0);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NodeSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_NodeSetCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NetworkModel *obj = self.dataArr[indexPath.row];
    PW_NodeListViewController *vc = [[PW_NodeListViewController alloc] init];
    vc.model = self.dataArr[indexPath.row];
    vc.changeBlock = ^(PW_NetworkModel * _Nonnull model) {
        obj.rpcUrl = model.rpcUrl;
        [tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 74;
        [_tableView registerClass:[PW_NodeSetCell class] forCellReuseIdentifier:@"PW_NodeSetCell"];
    }
    return _tableView;
}
- (NSMutableArray<PW_NetworkModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
