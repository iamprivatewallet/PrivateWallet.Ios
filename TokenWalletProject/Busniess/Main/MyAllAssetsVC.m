//
//  MyAllAssetsVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MyAllAssetsVC.h"
#import "AllAssetTableCell.h"

@interface MyAllAssetsVC ()

<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sortBtn;
//@property (nonatomic, copy) NSArray *coinList;
@end

@implementation MyAllAssetsVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.coinList = [[WalletCoinListManager shareManager] getCoinListWithWallet:self.currentWallet];

    [self setNavTitleWithLeftItem:@"我的所有资产"];
    [self makeViews];
    // Do any additional setup after loading the view.
}
- (void)makeViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.bottom.equalTo(self.view);
    }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.coinList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AllAssetTableCell";
    AllAssetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AllAssetTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    [cell setViewWithData:self.coinList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor navAndTabBackColor];
        _tableView.rowHeight = CGFloatScale(70);
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.separatorColor = [UIColor im_borderLineColor];
    }
    return _tableView;
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
