//
//  PW_ChooseAddressTypeViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ChooseAddressTypeViewController.h"
#import "PW_ChooseAddressTypeCell.h"

@interface PW_ChooseAddressTypeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_ChooseAddressTypeModel *> *dataArr;

@end

@implementation PW_ChooseAddressTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_selectAddressType")];
    [self makeViews];
    [self buildData];
}
- (void)buildData {
    PW_ChooseAddressTypeModel *ethModel = [PW_ChooseAddressTypeModel IconName:@"icon_ETH" title:@"ETH" subTitle:@"Ethereum" chainId:kETHChainId selected:[self.selectedChainId isEqualToString:kETHChainId]];
    PW_ChooseAddressTypeModel *cvnModel = [PW_ChooseAddressTypeModel IconName:@"icon_CVN" title:@"CVN" subTitle:@"Cvn" chainId:kCVNChainId selected:[self.selectedChainId isEqualToString:kCVNChainId]];
    [self.dataArr addObjectsFromArray:@[ethModel,cvnModel]];
    [self.tableView reloadData];
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
    PW_ChooseAddressTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_ChooseAddressTypeCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.chooseBlock) {
        self.chooseBlock(self.dataArr[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 72;
        [_tableView registerClass:[PW_ChooseAddressTypeCell class] forCellReuseIdentifier:@"PW_ChooseAddressTypeCell"];
    }
    return _tableView;
}
- (NSMutableArray<PW_ChooseAddressTypeModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
