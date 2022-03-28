//
//  AddCurrencyViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/22.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AddCurrencyViewController.h"
#import "CurrencyTableViewCell.h"
#import "BackupTipsViewController.h"

@interface AddCurrencyViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *ensureButton;

@property (nonatomic, strong) NSMutableArray *currencyList;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation AddCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isFirstBackup || self.isRecoveryPage) {
        //禁止返回
        id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
        [self.view addGestureRecognizer:pan];
        [self setNavTitle:@"添加币种" isNoLine:NO];
    }else{
        [self setNavTitleWithLeftItem:@"添加币种"];
    }
    
   NSArray *list = @[
        @{
            @"title":@"ETH",
            @"detailText":@"Ethereum",
            @"icon":@"icon_ETH",
            @"isDefault":@"1",
            @"isChecked":@"1"
        },
//        @{
//            @"title":@"BSC",
//            @"detailText":@"bsc",
//            @"icon":@"icon_BSC",
//            @"isDefault":@"1",
//            @"isChecked":@"1"
//        },
//        @{
//            @"title":@"HECO",
//            @"detailText":@"heco",
//            @"icon":@"icon_HECO",
//            @"isDefault":@"1",
//            @"isChecked":@"1"
//        },
        @{
            @"title":@"CVN",
            @"detailText":@"cvn",
            @"icon":@"icon_CVN",
            @"isDefault":@"0",
            @"isChecked":@"0"
        },
    ];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CurrencyInfoModel *model = [CurrencyInfoModel mj_objectWithKeyValues:obj];
        [self.dataList addObject:model];
    }];
    
    //判断是否最初创建钱包的时候，已经有默认的
    NSArray *arr = [[WalletManager shareWalletManager] getOrignWallets];
    for (int i = 0; i<self.dataList.count; i++) {
        CurrencyInfoModel *model = self.dataList[i];
        for (int j = 0; j< arr.count; j++) {
            Wallet *w = arr[j];
            if ([w.type isEqualToString:model.title]) {
                model.isDefault = @"1";
            }
        }
    }

    [self makeViews];
    // Do any additional setup after loading the view.
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor whiteColor];
    self.bottomView = [[UIView alloc] init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(98+kBottomSafeHeight);
    }];
    [self makeBottomView];
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 65;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
    self.tableView.separatorColor = [UIColor mp_lineGrayColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)makeBottomView{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor mp_lineGrayColor];
    [self.bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView);
        make.height.mas_equalTo(1);
    }];
    UILabel *title = [ZZCustomView labelInitWithView:self.bottomView text:@"请添加身份钱包下的币种（多选）" textColor:[UIColor im_textColor_six] font:GCSFontRegular(14)];
    [self.bottomView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(15);
        make.top.equalTo(line.mas_bottom).offset(12);
    }];
    
    self.ensureButton = [ZZCustomView im_ButtonDefaultWithView:self.bottomView title:@"确认" titleFont:GCSFontRegular(16) enable:YES];
    [self.ensureButton addTarget:self action:@selector(ensureButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(CGFloatScale(45));
        make.top.equalTo(title.mas_bottom).offset(12);

    }];
    
    if (self.isAddCurrency) {
        self.ensureButton.backgroundColor = [UIColor im_btnUnSelectColor];
        self.ensureButton.userInteractionEnabled = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"currencyCell";
    
    CurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CurrencyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier isCheck:YES];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CurrencyInfoModel *model = self.dataList[indexPath.row];
    [cell setViewWithData:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencyInfoModel *model = self.dataList[indexPath.row];
    if (![model.isDefault boolValue]) {//不是默认币种
        model.isChecked = !model.isChecked;
        [self currencyWithStatus:model.isChecked];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)currencyWithStatus:(BOOL)isChecked{
    if (self.isAddCurrency) {
        if (isChecked) {
            self.ensureButton.backgroundColor = [UIColor im_btnSelectColor];
            self.ensureButton.userInteractionEnabled = YES;
        }else{
            self.ensureButton.backgroundColor = [UIColor im_btnUnSelectColor];
            self.ensureButton.userInteractionEnabled = NO;
        }
    }
}
//确认按钮
- (void)ensureButtonAction{
    if (self.currencyList.count>0) {
        [self.currencyList removeAllObjects];
    }
    __block BOOL isStop;
    [self.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CurrencyInfoModel *mdl = obj;
        if (mdl.isChecked && ![mdl.isDefault boolValue]) {//选择的币种
            NSString *typeStr = mdl.title;
            [self.currencyList addObject:typeStr];
            isStop = YES;
        }
    }];
    if (isStop) {
        if (self.isAddCurrency) {
            [TokenAlertView showInputPasswordWithTitle:@"钱包密码" ViewWithAction:^(NSInteger index, NSString * _Nonnull inputText) {
                if (![inputText isEqualToString:User_manager.currentUser.user_pass]) {
                    return [self showAlertViewWithText:@"密码不正确" actionText:@"好"];
                }
                [self createWallet];
            }];
        }else{
            [self createWallet];
        }
        
    }else{
        [self jumpToNextStep];
    }

}

- (void)createWallet{
    [self.view showLoadingIndicator];
    //创建单独选择的币种钱包
    [FchainTool genWalletsWithMnemonic:User_manager.currentUser.user_mnemonic createList:self.currencyList block:^(BOOL sucess) {
        [self.view hideLoadingIndicator];
        if (sucess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadWalletNotification" object:nil];
            [self jumpToNextStep];
        }
    }];
}

- (void)jumpToNextStep{
    if (self.isRecoveryPage) {
        [TheAppDelegate switchToTabBarController];
    }else{
        if (self.isAddCurrency) {
            //给钱包添加币种
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            BackupTipsViewController *acVC = [[BackupTipsViewController alloc] init];
            acVC.isFirstBackup = self.isFirstBackup;
            [self.navigationController pushViewController:acVC animated:YES];
        }
    }
}
- (NSMutableArray *)currencyList{
    if (!_currencyList) {
        _currencyList = [[NSMutableArray alloc] init];
    }
    return _currencyList;
}
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
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
