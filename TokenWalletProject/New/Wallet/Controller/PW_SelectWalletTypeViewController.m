//
//  PW_SelectWalletTypeViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/12.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SelectWalletTypeViewController.h"
#import "CurrencyTableViewCell.h"
#import "PW_AddWalletViewController.h"

@interface PW_SelectWalletTypeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemList;

@end

@implementation PW_SelectWalletTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_addWallet")];
    NSArray *list = @[
         @{
             @"title":@"ETH",
             @"detailText":@"Ethereum",
             @"icon":@"icon_ETH",
             @"isDefault":@"1",
             @"isChecked":@"1"
         },
         @{
             @"title":@"CVN",
             @"detailText":@"cvn",
             @"icon":@"icon_CVN",
             @"isDefault":@"1",
             @"isChecked":@"1"
         }
    ];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CurrencyInfoModel *model = [CurrencyInfoModel mj_objectWithKeyValues:obj];
        [self.itemList addObject:model];
    }];
    [self makeViews];
}
- (void)makeViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(0);
        make.left.right.bottom.offset(0);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"currencyCell";
    CurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CurrencyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier isCheck:NO];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewWithData:self.itemList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencyInfoModel *model = self.itemList[indexPath.row];
    PW_AddWalletViewController *vc = [[PW_AddWalletViewController alloc] init];
    vc.walletType = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 65;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    }
    return _tableView;
}
- (NSMutableArray *)itemList{
    if (!_itemList) {
        _itemList = [[NSMutableArray alloc] init];
    }
    return _itemList;
}

@end
