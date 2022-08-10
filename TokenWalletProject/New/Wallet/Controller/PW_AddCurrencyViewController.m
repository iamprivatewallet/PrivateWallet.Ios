//
//  PW_AddCurrencyViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddCurrencyViewController.h"
#import "PW_AddCurrencyCell.h"

@interface PW_AddCurrencyViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *ensureButton;

@property (nonatomic, strong) NSMutableArray *currencyList;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation PW_AddCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_addCurrency")];
    [self makeViews];
    NSArray *list = @[
            @{
                @"title":kWalletTypeETH,
                @"desc":@"Ethereum",
                @"icon":@"icon_type_ETH",
                @"isDefault":@"1",
                @"isChecked":@"1"
            },
            @{
                @"title":kWalletTypeCVN,
                @"desc":@"cvn",
                @"icon":@"icon_type_CVN",
                @"isDefault":@"0",
                @"isChecked":@"0"
            },
//            @{
//                @"title":kWalletTypeTron,
//                @"detailText":@"tron",
//                @"icon":@"icon_type_TRON",
//                @"isDefault":@"0",
//                @"isChecked":@"0"
//            }
//            @{
//             @"title":kWalletTypeSolana,
//             @"detailText":@"solana",
//             @"icon":@"icon_type_SOLANA",
//             @"isDefault":@"0",
//             @"isChecked":@"0"
//            }
     ];
     [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         PW_AddCurrencyModel *model = [PW_AddCurrencyModel mj_objectWithKeyValues:obj];
         [self.dataList addObject:model];
     }];
     NSArray *arr = [[PW_WalletManager shared] getOrignWallets];
     for (int i = 0; i<self.dataList.count; i++) {
         PW_AddCurrencyModel *model = self.dataList[i];
         for (int j = 0; j< arr.count; j++) {
             Wallet *w = arr[j];
             if ([w.type isEqualToString:model.title]) {
                 model.isDefault = YES;
             }
         }
     }
    [self.tableView reloadData];
}
- (void)makeViews{
    self.bottomView = [[UIView alloc] init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(98+kBottomSafeHeight);
    }];
    [self makeBottomView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)makeBottomView{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor g_lineColor];
    [self.bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView);
        make.height.mas_equalTo(1);
    }];
    UILabel *titleLb = [PW_ViewTool labelText:LocalizedStr(@"text_addCurrencyWalletTip") fontSize:14 textColor:[UIColor g_grayTextColor]];
    [self.bottomView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(15);
        make.top.equalTo(line.mas_bottom).offset(12);
    }];
    self.ensureButton = [PW_ViewTool buttonTitle:LocalizedStr(@"text_confirm") fontSize:16 weight:UIFontWeightBold titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(ensureButtonAction)];
    self.ensureButton.enabled = NO;
    [self.bottomView addSubview:self.ensureButton];
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(CGFloatScale(45));
        make.top.equalTo(titleLb.mas_bottom).offset(12);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PW_AddCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_AddCurrencyCell"];
    cell.model = self.dataList[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PW_AddCurrencyModel *model = self.dataList[indexPath.row];
    if (!model.isDefault) {
        model.isChecked = !model.isChecked;
        [self checkWithStatus];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)checkWithStatus {
    BOOL isSelected = NO;
    for (PW_AddCurrencyModel *model in self.dataList) {
        if(model.isChecked&&!model.isDefault){
            isSelected = YES;
            break;
        }
    }
    self.ensureButton.enabled = isSelected;
}
- (void)ensureButtonAction{
    [self.currencyList removeAllObjects];
    [self.dataList enumerateObjectsUsingBlock:^(PW_AddCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isChecked && !obj.isDefault) {
            [self.currencyList addObject:obj.title];
        }
    }];
    if (self.currencyList.count>0) {
        [PW_TipTool showPayCheckBlock:^(NSString * _Nonnull pwd) {
            if (![pwd isEqualToString:User_manager.currentUser.user_pass]) {
                return [self showError:LocalizedStr(@"text_pwdError")];
            }
            [self createWallet];
        }];
    }
}
- (void)createWallet{
    [self.view showLoadingIndicator];
    self.ensureButton.userInteractionEnabled = NO;
    NSString *user_mnemonic = User_manager.currentUser.user_mnemonic;
    if ([user_mnemonic isNoEmpty]) {
        [FchainTool genWalletsWithMnemonic:user_mnemonic createList:self.currencyList block:^(BOOL sucess) {
            self.ensureButton.userInteractionEnabled = YES;
            [self.view hideLoadingIndicator];
            if (sucess) {
                [self showSuccess:LocalizedStr(@"text_addSuccess")];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWalletNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showError:LocalizedStr(@"text_addFailure")];
            }
        }];
    }else{
        Wallet *wallet = [[PW_WalletManager shared] getOrignWallets].firstObject;
        [FchainTool genWalletsWithPrivateKey:wallet.priKey createList:self.currencyList block:^(BOOL sucess) {
            self.ensureButton.userInteractionEnabled = YES;
            [self.view hideLoadingIndicator];
            if (sucess) {
                [self showSuccess:LocalizedStr(@"text_addSuccess")];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWalletNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showError:LocalizedStr(@"text_addFailure")];
            }
        }];
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PW_AddCurrencyCell class] forCellReuseIdentifier:@"PW_AddCurrencyCell"];
        _tableView.rowHeight = 65;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
    }
    return _tableView;
}
- (NSMutableArray *)currencyList {
    if (!_currencyList) {
        _currencyList = [[NSMutableArray alloc] init];
    }
    return _currencyList;
}
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
