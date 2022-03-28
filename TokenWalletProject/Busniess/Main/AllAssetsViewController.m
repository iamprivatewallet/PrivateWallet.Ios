//
//  AllAssetsViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AllAssetsViewController.h"
#import "MainAssetManageVC.h"
#import "MyAllAssetsVC.h"
#import "SearchViewController.h"
#import "CustomCurrencyVC.h"
#import "HotAssetsTableViewCell.h"

@interface AllAssetsViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *titleList;
@property (nonatomic, strong) NSMutableArray *hotAssetsList;

@end

@implementation AllAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleList = @[@"首页资产管理",@"我的所有资产",@"自定义代币"];
    [self setNavTitleWithLeftItem:@""];
    [self makeNavSearchBar];
    [self makeViews];
    [self loadAllCoin];
    // Do any additional setup after loading the view.
}

- (void)loadAllCoin{
    [[AssetCoinListManager sharedInstance] deleteAllCoins];
    NSDictionary *param = @{
        @"tokenChain":User_manager.currentUser.current_chainId,
        @"pageNum":@1,
        @"pageSize":@"1000"
    };
    [AFNetworkClient requestPostWithUrl:NSStringWithFormat(@"%@/wallet/geWattleToken",APPWalletBaseURL) withParameter:param withBlock:^(id data, NSError *error) {
        if (data) {
            if (self.hotAssetsList.count>0) {
                [self.hotAssetsList removeAllObjects];
            }
            NSArray *list = data[@"records"];
            [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[AssetCoinListManager sharedInstance] addCoin:obj];
                AssetCoinModel *model = [AssetCoinModel mj_objectWithKeyValues:obj];
                if ([model.hotTokens isEqualToString:@"1"]) {
                    User *user = User_manager.currentUser;
                    AssetCoinModel *exitModel = [[WalletCoinListManager shareManager] isExit:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
                    model.isExit = exitModel!=nil;
                    [self.hotAssetsList addObject:model];
                }
            }];
            [self.tableView reloadData];
        }
    }];
}

- (void)makeNavSearchBar{
    UIView *bgView = [ZZCustomView viewInitWithView:self.naviBar bgColor:COLORFORRGB(0xf2f3f5)];
    bgView.layer.cornerRadius = 15;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.naviBar).offset(-3);
        make.right.equalTo(self.naviBar).offset(-10);
        make.left.equalTo(self.leftBtn.mas_right).offset(13);
        make.height.equalTo(@35);
    }];
    UIImageView *img = [ZZCustomView imageViewInitView:bgView imageName:@"search"];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(7);
        make.centerY.equalTo(bgView);
        make.width.height.equalTo(@17);
    }];
   
    UITextField *textField = [ZZCustomView textFieldInitFrame:CGRectZero view:bgView placeholder:@"" delegate:nil font:GCSFontRegular(13)];
    NSString *placeholder = @"输入Token名称或合约地址";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:placeholder];
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor im_grayColor]} range:NSMakeRange(0, placeholder.length)];
    textField.attributedPlaceholder = att;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).offset(5);
        make.centerY.equalTo(bgView);
    }];
    [textField addTarget:self action:@selector(textFieldAction) forControlEvents:UIControlEventEditingDidBegin];

}
- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    UIView *bottom = [ZZCustomView viewInitWithView:self.view bgColor:[UIColor im_tableBgColor]];
    [self.view addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(30));
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.bottom.equalTo(bottom.mas_top);
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.titleList.count;
    }
    return self.hotAssetsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell = nil;
    if (indexPath.section == 0) {
        static NSString *identifier = @"AssetTableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            UIImageView *icon = [ZZCustomView imageViewInitView:cell.contentView imageName:@"arrow"];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-15);
                make.centerY.equalTo(cell.contentView);
                make.width.height.equalTo(@17);
            }];
        }
        cell.textLabel.text = self.titleList[indexPath.row];
        cell.textLabel.textColor = [UIColor im_textColor_three];
        cell.textLabel.font = GCSFontRegular(15);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableCell = cell;
    }else{
        static NSString *identifier = @"HotAssetsTableViewCell";
        HotAssetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[HotAssetsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        AssetCoinModel *model = self.hotAssetsList[indexPath.row];
        [cell setViewWithData:model];
        __weak typeof(self) weakSelf = self;
        cell.addBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(model.isExit){
                return;
            }
            User *user = User_manager.currentUser;
            model.sortIndex = [[WalletCoinListManager shareManager] getMaxIndex]+1;
            model.walletType = user.chooseWallet_type;
            model.walletAddress = user.chooseWallet_address;
            model.createTime = [NSDate new].timeIntervalSince1970;
            [[WalletCoinListManager shareManager] saveCoin:model];
            [strongSelf showSuccessMessage:@"添加成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCoinList_Notification" object:nil];
            model.isExit = YES;
            [strongSelf.tableView reloadData];
        };
        tableCell = cell;
    }
    
    return tableCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MainAssetManageVC *vc = [[MainAssetManageVC alloc] init];
            vc.coinList = self.coinList;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1){
            MyAllAssetsVC *vc = [[MyAllAssetsVC alloc] init];
            vc.coinList = self.coinList;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            CustomCurrencyVC *vc = [[CustomCurrencyVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *titleLbl = [ZZCustomView labelInitWithView:view text:@"热门资产" textColor:[UIColor im_textColor_three] font:GCSFontRegular(15)];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(20);
            make.top.equalTo(view).offset(20);
            make.bottom.equalTo(view).offset(-15);
        }];
        
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 55;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 70;
    }
    return 55;
}

- (void)textFieldAction{
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor im_tableBgColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorColor = [UIColor im_borderLineColor];
        
    }
    return _tableView;
}

- (NSMutableArray *)hotAssetsList{
    if (!_hotAssetsList) {
        _hotAssetsList = [[NSMutableArray alloc] init];
    }
    return _hotAssetsList;
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
