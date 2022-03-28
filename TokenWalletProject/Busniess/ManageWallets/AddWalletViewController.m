//
//  AddWalletViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/3.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AddWalletViewController.h"
#import "CreateWalletVC.h"
#import "ImportWalletVC.h"

#import "CurrencyTableViewCell.h"
#import "CreateWalletView.h"
@interface AddWalletViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
CreateWalletViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemList;
@property (nonatomic, copy) NSString *walletType;
@end

@implementation AddWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"添加钱包"];
    
    NSArray *list = @[
         @{
             @"title":@"ETH",
             @"detailText":@"Ethereum",
             @"icon":@"icon_ETH",
             @"isDefault":@"1",
             @"isChecked":@"1"
         },
//         @{
//             @"title":@"BSC",
//             @"detailText":@"bsc",
//             @"icon":@"icon_BSC",
//             @"isDefault":@"1",
//             @"isChecked":@"1"
//         },
//         @{
//             @"title":@"HECO",
//             @"detailText":@"heco",
//             @"icon":@"icon_HECO",
//             @"isDefault":@"1",
//             @"isChecked":@"1"
//         },
         @{
             @"title":@"CVN",
             @"detailText":@"cvn",
             @"icon":@"icon_CVN",
             @"isDefault":@"1",
             @"isChecked":@"1"
         },
     ];
     [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         CurrencyInfoModel *model = [CurrencyInfoModel mj_objectWithKeyValues:obj];
         [self.itemList addObject:model];
     }];
    
    [self makeViews];

    // Do any additional setup after loading the view.
}
- (void)makeViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

}
// MARK: TableViewDelegate & TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    CurrencyInfoModel *mdl = self.itemList[indexPath.row];
    self.walletType = mdl.title;
    CreateWalletView *walletView = [CreateWalletView getCreateWalletViewWithType:self.walletType];
    walletView.delegate = self;
}
// MARK: CreateWalletViewDelegate
- (void)clickCreateWalletItemIndex:(NSInteger)index{
    switch (index) {
        case 0:{//创建钱包
            CreateWalletVC *vc = [[CreateWalletVC alloc] init];
            vc.walletType = self.walletType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1:{//助记词
            ImportWalletVC *vc = [[ImportWalletVC alloc] init];
            vc.importType = kImportWalletTypeMnemonic;
            vc.walletTypeStr = self.walletType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:{//私钥
            ImportWalletVC *vc = [[ImportWalletVC alloc] init];
            vc.importType = kImportWalletTypePrivateKey;
            vc.walletTypeStr = self.walletType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{//Keystore
            ImportWalletVC *vc = [[ImportWalletVC alloc] init];
            vc.importType = kImportWalletTypeKeystore;
            vc.walletTypeStr = self.walletType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 65;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorColor = [UIColor mp_lineGrayColor];
    if (@available(iOS 11.0, *)) {
    
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
    
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   }
    return _tableView;
}
- (NSMutableArray *)itemList{
    if (!_itemList) {
        _itemList = [[NSMutableArray alloc] init];
    }
    return _itemList;
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
