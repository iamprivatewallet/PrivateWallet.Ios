//
//  PW_TransferViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/16.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TransferViewController.h"
#import "PW_ChooseCurrencyViewController.h"
#import "PW_SliderView.h"
#import "PW_ScanTool.h"
#import "PW_GasModel.h"
#import "CVNServerMananger.h"
#import "brewchain.h"
#import "PW_AddressBookViewController.h"
#import "PW_ContractTool.h"

static NSInteger SpeedFeeBtnTag = 100;

@interface PW_TransferViewController () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) UILabel *sendAddressLb;

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *sendingView;
@property (nonatomic, strong) UIView *transferCountView;
@property (nonatomic, strong) UIView *receiveAddressView;
@property (nonatomic, strong) UIView *minersFeeView;

@property (nonatomic, strong) UILabel *balanceLb;
@property (nonatomic, strong) UITextField *countTF;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UILabel *minersFeeLb;
@property (nonatomic, strong) UILabel *minersFeeUTLb;
@property (nonatomic, strong) UILabel *gweiLb;
@property (nonatomic, strong) PW_SliderView *sliderView;
@property (nonatomic, strong) UIView *speedFeeView;
@property (nonatomic, strong) UIView *customFeeView;
@property (nonatomic, strong) UITextField *gasPriceTF;
@property (nonatomic, strong) UITextField *gasTF;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, weak) UIButton *selectedSpeedFeeBtn;
@property (nonatomic, assign) NSInteger speedFeeIdx;
@property (nonatomic, assign) BOOL showCustomFee;
@property (nonatomic, strong) PW_GasToolModel *gasToolModel;
@property (nonatomic, strong) PW_GasModel *gasModel;
@property (nonatomic, strong) PW_GasModel *customGasModel;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation PW_TransferViewController

- (PW_GasModel *)getCurrentGasModel {
    if (self.showCustomFee) {
        return self.customGasModel;
    }
    return self.gasModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_transfer")];
    self.speedFeeIdx = 1;
    if (self.model==nil) {
        self.model = [PW_GlobalData shared].mainTokenModel;
    }
    [self makeViews];
    [self refreshUI];
    [self requestGasData];
    if ([User_manager.currentUser.chooseWallet_type isEqualToString:kWalletTypeCVN]) {
        [self loadDataForGetCVNNonce];
    }else{
        [self loadDataForNonce];
    }
    __weak typeof(self) weakSelf = self;
    [RACObserve(self, showCustomFee) subscribeNext:^(NSNumber * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf refreshGasUI];
        strongSelf.customFeeView.hidden = !x.boolValue;
        if(x.boolValue){
            [strongSelf.customFeeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(strongSelf.speedFeeView.mas_bottom).offset(0);
                make.left.offset(18);
                make.right.offset(-18);
                make.bottom.offset(-20);
            }];
        }else{
            [strongSelf.customFeeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(strongSelf.speedFeeView.mas_bottom).offset(0);
                make.left.offset(18);
                make.right.offset(-18);
            }];
        }
    }];
    [RACObserve(self, speedFeeIdx) subscribeNext:^(NSNumber * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(x.integerValue==0){
            strongSelf.gasModel = strongSelf.gasToolModel.slowModel;
        }else if(x.integerValue==1){
            strongSelf.gasModel = strongSelf.gasToolModel.recommendModel;
        }else if(x.integerValue==2){
            strongSelf.gasModel = strongSelf.gasToolModel.fastModel;
        }else if(x.integerValue==3){
            strongSelf.gasModel = strongSelf.gasToolModel.soonModel;
        }
        [strongSelf refreshGasUI];
    }];
    [RACObserve(self, customGasModel) subscribeNext:^(id  _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.gasPriceTF.text = strongSelf.customGasModel.gas_gwei;
        [strongSelf.gasPriceTF pw_setPlaceholder:strongSelf.customGasModel.gas_gwei];
        strongSelf.gasTF.text = strongSelf.customGasModel.gas;
        [strongSelf.gasTF pw_setPlaceholder:strongSelf.customGasModel.gas];
    }];
    [self.gasPriceTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (![x isFloat]) {
            if (x.length==0) {
                return;
            }
            strongSelf.gasPriceTF.text = strongSelf.customGasModel.gas_gwei;
            return;
        }
        strongSelf.customGasModel.gas_price = [x stringDownMultiplyingBy10Power:9 scale:0];
        [strongSelf refreshGasUI];
    }];
    [self.gasTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (![x isInt]) {
            if (x.length==0) {
                return;
            }
            strongSelf.gasTF.text = strongSelf.customGasModel.gas;
            return;
        }
        strongSelf.customGasModel.gas = x;
        [strongSelf refreshGasUI];
    }];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)scanAction {
    [[PW_ScanTool shared] showScanWithResultBlock:^(NSString * _Nonnull result) {
        self.addressTF.text = result;
    }];
}
- (void)allAction {
    self.countTF.text = self.model.tokenAmount;
}
- (void)addressBookAction {
    PW_AddressBookViewController *vc = [[PW_AddressBookViewController alloc] init];
    vc.chooseBlock = ^(PW_AddressBookModel * _Nonnull model) {
        self.addressTF.text = model.address;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)customFeeAction {
    self.showCustomFee = !self.showCustomFee;
}
- (void)sliderValueChange:(PW_SliderView *)slider {
    
}
- (void)changeSpeedAction:(UIButton *)btn {
    self.speedFeeIdx = btn.tag-SpeedFeeBtnTag;
    self.selectedSpeedFeeBtn.selected = NO;
    btn.selected = YES;
    self.selectedSpeedFeeBtn = btn;
}
- (void)nextAction {
    NSString *countStr = [self.countTF.text trim];
    if (![countStr isFloat]) {
        [self showError:LocalizedStr(@"text_pleaseEnterQuantity")];
        return;
    }
    CGFloat count = [countStr doubleValue];
    if (count<=0) {
        [self showError:LocalizedStr(@"text_pleaseEnterQuantity")];
        return;
    }
    if (count>[self.model.tokenAmount doubleValue]) {
        [self showError:LocalizedStr(@"text_balanceLack")];
        return;
    }
    NSString *address = [self.addressTF.text trim];
    if (![address isNoEmpty]) {
        [self showError:LocalizedStr(@"text_pleaseEnterAddress")];
        return;
    }
    if (![address isContract]) {
        [self showError:LocalizedStr(@"text_addressError")];
        return;
    }
    self.amount = countStr;
    self.address = address;
    [PW_TipTool showPayCheckBlock:^(NSString * _Nonnull pwd) {
        if (![pwd isEqualToString:User_manager.currentUser.user_pass]) {
            return [self showError:LocalizedStr(@"text_pwdError")];
        }
        [self transferAction];
    }];
}
- (void)transferAction {
    User *user = User_manager.currentUser;
    if ([user.chooseWallet_type isEqualToString:kWalletTypeCVN]) {
        if ([self.model.tokenContract isEqualToString:user.chooseWallet_address]) {
            [self loadTransferCVNMain];
        }else{
            [self loadTransferDai];
        }
    }else if ([user.chooseWallet_type isEqualToString:kWalletTypeETH]) {
        [self loadColdWalletTransferETH];
    }
}
- (void)changeTokenAction {
    PW_ChooseCurrencyViewController *vc = [[PW_ChooseCurrencyViewController alloc] init];
    vc.selectedTokenContract = self.model.tokenContract;
    vc.chooseBlock = ^(PW_TokenModel * _Nonnull model) {
        self.model = model;
        [self refreshUI];
        [self requestGasData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshUI {
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:self.model.tokenLogo] placeholderImage:[UIImage imageNamed:@"icon_token_default"]];
    self.nameLb.text = self.model.tokenName;
    User *user = User_manager.currentUser;
    NSString *walletAddress = user.chooseWallet_address;
    self.sendAddressLb.text = [walletAddress showShortAddress];
    self.addressTF.text = self.toAddress;
    PW_TokenModel *model = self.model;
    if ([self.model.tokenAmount isNoEmpty]) {
        self.balanceLb.text = NSStringWithFormat(@"%@:%@",LocalizedStr(@"text_balance"),model.tokenAmount);
    }else{
        self.balanceLb.text = NSStringWithFormat(@"%@:--",LocalizedStr(@"text_balance"));
    }
    if ([user.chooseWallet_type isEqualToString:kWalletTypeETH]) {
        [PW_ContractTool loadETHBalance:model completion:^(NSString * _Nonnull amount) {
            model.tokenAmount = amount;
            self.balanceLb.text = NSStringWithFormat(@"%@:%@",LocalizedStr(@"text_balance"),model.tokenAmount);
        }];
    }else if([user.chooseWallet_type isEqualToString:kWalletTypeCVN]) {
        [PW_ContractTool loadCVNBalance:model completion:^(NSString * _Nonnull amount) {
            model.tokenAmount = amount;
            self.balanceLb.text = NSStringWithFormat(@"%@:%@",LocalizedStr(@"text_balance"),model.tokenAmount);
        }];
    }
}
- (void)refreshGasUI {
    PW_GasModel *gasModel = [self getCurrentGasModel];
    if (![gasModel.gas_price isNoEmpty]) {
        return;
    }
    self.sliderView.value = [gasModel.gas_price doubleValue];
    self.minersFeeLb.text = NSStringWithFormat(@"%@%@",gasModel.gas_amount,[[SettingManager sharedInstance] getChainCoinName]);
    self.minersFeeUTLb.text = NSStringWithFormat(@" ≈ $%@",gasModel.gas_ut_amout);
    self.gweiLb.text = NSStringWithFormat(@"%@ GWEI",gasModel.gas_gwei);
}
- (void)requestGasData {
    NSString *tokenAddress = self.model.tokenContract;
    if (![tokenAddress isNoEmpty]||[tokenAddress.lowercaseString isEqualToString:User_manager.currentUser.chooseWallet_address.lowercaseString]) {
        [[PWWalletContractTool shared] estimateGasToAddress:nil completionHandler:^(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc) {
            if(gas){
                self.gasToolModel.gas_price = gasPrice;
                self.gasToolModel.gas = gas;
                self.gasToolModel.price = [PW_GlobalData shared].mainTokenModel.price;
                self.gasModel = self.gasToolModel.recommendModel;;
                self.customGasModel = [self.gasModel mutableCopy];
                self.sliderView.minimumValue = [self.gasToolModel.slowModel.gas_price doubleValue];
                self.sliderView.maximumValue = [self.gasToolModel.soonModel.gas_price doubleValue];
                [self refreshGasUI];
            }
        }];
    }else{
        [[PWWalletContractTool shared] estimateGasTokenToAddress:nil token:tokenAddress completionHandler:^(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc) {
            if(gas){
                self.gasToolModel.gas_price = gasPrice;
                self.gasToolModel.gas = gas;
                self.gasToolModel.price = [PW_GlobalData shared].mainTokenModel.price;
                self.gasModel = self.gasToolModel.recommendModel;;
                self.customGasModel = [self.gasModel mutableCopy];
                self.sliderView.minimumValue = [self.gasToolModel.slowModel.gas_price doubleValue];
                self.sliderView.maximumValue = [self.gasToolModel.soonModel.gas_price doubleValue];
                [self refreshGasUI];
            }
        }];
    }
}
- (void)loadDataForGetCVNNonce {//CVN nonce
    [[CVNServerMananger sharedInstance] fetchBalance:User_manager.currentUser.chooseWallet_address contractAddr:@"" resultBlock:^(ETHBalance * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.model.nonce = data.nonce;
        }
    }];
}
//CVN主币 转账
- (void)loadTransferCVNMain {
    Wallet *wallet = [[SettingManager sharedInstance] getCurrentWallet];
    NSMutableString *args = [NSMutableString new];
    JKBigDecimal *big = [[JKBigDecimal alloc]initWithString:@"1000000000000000000"];
    JKBigDecimal *result =  [big multiply:[[JKBigDecimal alloc]initWithString:self.amount]];
    NSString *str = [result stringValue];
    NSArray *arr = [str componentsSeparatedByString:@"."];
    [args appendFormat:@"[{\"address\":\"%@\",\"amount\":\"%@\"}]",[self.address formatDelCVN],arr[0]];
    NSData *tipData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *results = [CWVChainUtils signTransferAddress:[User_manager.currentUser.chooseWallet_address formatDelCVN] prikey:wallet.priKey nonce:self.model.nonce exdata:[tipData toHexStr] args:args];
    [self.view showLoadingIndicator];
    self.nextBtn.enabled = NO;
    [[CVNServerMananger sharedInstance] transfer:results resultBlock:^(id  _Nullable data, NSError * _Nullable error) {
        self.nextBtn.enabled = YES;
        [self.view hideLoadingIndicator];
        if (data) {
            if ([data[@"retCode"]intValue] == 1) {
                SetUserDefaultsForKey(@"0", @"isFirstTransfer");
                [UserDefaults synchronize];
                [self showSuccess:LocalizedStr(@"text_transactionBroadcast")];
                [self saveTransferRecordWithHash:data[@"hash"]];
                if (self.transferSuccessBlock) {
                    self.transferSuccessBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self showError:data[@"retMsg"]];
            }
        }else{
            [self showError:LocalizedStr(@"text_error")];
        }
    }];
}
//冷钱包转账后临时保存当前的转账记录
- (void)saveTransferRecordWithHash:(NSString *)hash{
    if(![hash isNoEmpty]){
        return;
    }
    if(![hash hasPrefix:@"0x"]){
        hash = NSStringWithFormat(@"0x%@",hash);
    }
    PW_TokenDetailModel *model = [[PW_TokenDetailModel alloc] init];
    model.value = self.amount;
    model.fromAddress = User_manager.currentUser.chooseWallet_address;
    model.contractAddress = self.model.tokenContract;
    model.toAddress = self.address;
    model.tokenName = self.model.tokenName;
    model.timeStamp = [[NSDate new] timeIntervalSince1970]*1000;
    model.hashStr = hash;
    PW_GasModel *gasModel = [self getCurrentGasModel];
    model.gasPrice = gasModel.gas_price;
    model.gas = gasModel.gas;
    [[PW_TokenTradeRecordManager shared] saveRecord:model];
}
//CVN代币 通过web代理
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    User *user = User_manager.currentUser;
    Wallet *wallet = [[SettingManager sharedInstance] getCurrentWallet];
    if ([user.chooseWallet_type isEqualToString:kWalletTypeCVN]) {
        if (![self.model.tokenContract isEqualToString:user.chooseWallet_address]) {
            JKBigDecimal *big = [[JKBigDecimal alloc]initWithString:@"1000000000000000000"];
            JKBigDecimal *result =  [big multiply:[[JKBigDecimal alloc]initWithString:self.amount]];
            NSString *str = [result stringValue];
            NSArray *arr = [str componentsSeparatedByString:@"."];
            //获取签名
            NSString *keystoreJs = NSStringWithFormat(@"getTransactionC20Tx(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",wallet.priKey,self.model.nonce, [self.address formatDelCVN], self.model.tokenContract,arr[0]);
            [webView evaluateJavaScript:keystoreJs completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                if (response) {
                    [self transferDaiWithTx:response];
                }
            }];
        }
    }
}
//CVN代币 转账
- (void)transferDaiWithTx:(NSString *)txStr{
    [self.view showLoadingIndicator];
    self.nextBtn.enabled = NO;
    [[CVNServerMananger sharedInstance]transfer:txStr resultBlock:^(id  _Nullable data, NSError * _Nullable error) {
        self.nextBtn.enabled = YES;
        [self.view hideLoadingIndicator];
        if (data) {
            if ([data[@"retCode"]intValue] == 1) {
                SetUserDefaultsForKey(@"0", @"isFirstTransfer");
                [UserDefaults synchronize];
                [self showSuccess:LocalizedStr(@"text_transactionBroadcast")];
                [self saveTransferRecordWithHash:data[@"hash"]];
                if (self.transferSuccessBlock) {
                    self.transferSuccessBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self showError:data[@"retMsg"]];
            }
        }else{
            [self showError:LocalizedStr(@"text_error")];
        }
    }];
}
- (void)loadDataForNonce {//ETH nonce
    NSDictionary *parmDic = @{
                    @"id":@"67",
                    @"jsonrpc":@"2.0",
                    @"method":@"eth_getTransactionCount",
                    @"params":@[User_manager.currentUser.chooseWallet_address,@"latest"]
                    };
    [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
        if (data) {
            self.model.nonce = data[@"result"];
        }
    }];
}
// 获取ETH 签名
- (void)loadColdWalletTransferETH {
    PW_GasModel *gasModel = [self getCurrentGasModel];
    Wallet *wallet = [[SettingManager sharedInstance] getCurrentWallet];
    if ([self.model.tokenContract isEqualToString:User_manager.currentUser.chooseWallet_address]) {
        NSDictionary *dic = @{
            @"nonce":self.model.nonce,
            @"to_addr":self.address,
            @"value":[self.amount stringRaisingToPower18],
            @"gas_price":gasModel.gas_price,
            @"gas":gasModel.gas,
            @"prikey":wallet.priKey
        };
        @weakify(self);
        [FchainTool genETHTransactionSign:dic isToken:NO block:^(NSString * _Nonnull result) {
            @strongify(self);
            NSString *sign = NSStringWithFormat(@"0x%@",result);
            [self ETHTransferWithSign:sign];
        }];
    }else{//ETH代币
        NSDictionary *dic = @{
            @"nonce":self.model.nonce,
            @"to_addr":self.address,
            @"value":[self.amount stringDownMultiplyingBy10Power:self.model.tokenDecimals],
            @"gas_price":gasModel.gas_price,
            @"gas":gasModel.gas,
            @"contract_addr":self.model.tokenContract,
            @"prikey":wallet.priKey
        };
        @weakify(self);
        [FchainTool genETHTransactionSign:dic isToken:YES block:^(NSString * _Nonnull result) {
            @strongify(self);
            NSString *sign = NSStringWithFormat(@"0x%@",result);
            [self ETHTransferWithSign:sign];
        }];
    }
}
//ETH 转账
-(void)ETHTransferWithSign:(NSString *)sign {
    NSDictionary *parmDic = @{
                @"id":@"67",
                @"jsonrpc":@"2.0",
                @"method":@"eth_sendRawTransaction",
                @"params":@[sign]
                };
    [self.view showLoadingIndicator];
    self.nextBtn.enabled = NO;
    [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
        self.nextBtn.enabled = YES;
        [self.view hideLoadingIndicator];
        if (data) {
            if (data[@"error"]) {
                NSNumber *code = data[@"error"][@"code"];
                if ([code.stringValue isEqualToString:@"-32000"]) {
                    [self loadDataForNonce];
                }
                [self showError:data[@"error"][@"message"]];
            }else{
                SetUserDefaultsForKey(@"0", @"isFirstTransfer");
                [UserDefaults synchronize];
                [self showSuccess:LocalizedStr(@"text_transactionBroadcast")];
                [self saveTransferRecordWithHash:data[@"result"]];
                if (self.transferSuccessBlock) {
                    self.transferSuccessBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if (self.codeInfoModel) {
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
//                    }
                });
            }
        }else{
            [self loadDataForNonce];
            [self showError:error.localizedDescription];
        }
    }];
}
- (void)loadTransferDai{
    self.webView = [[WKWebView alloc] init];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURL *pathURL = [NSURL fileURLWithPath:bundleStr];
    if (@available(iOS 9.0, *)) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:pathURL]];
    }
    [self.view addSubview:self.webView];
}
- (void)makeViews {
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [bodyView setRadius:28 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    self.nextBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_nextStep") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(nextAction)];
    [bodyView addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
        make.bottom.offset(-SafeBottomInset-20);
    }];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [bodyView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.bottom.equalTo(self.nextBtn.mas_top).offset(-10);
    }];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.width.equalTo(scrollView);
    }];
    UIView *coinSendView = [[UIView alloc] init];
    coinSendView.backgroundColor = [UIColor g_bgCardColor];
    [coinSendView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:coinSendView];
    [coinSendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(36);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.mas_equalTo(110);
    }];
    UIView *tokenView = [[UIView alloc] init];
    tokenView.backgroundColor = [UIColor g_darkBgColor];
    [tokenView addTapTarget:self action:@selector(changeTokenAction)];
    [coinSendView addSubview:tokenView];
    [tokenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(38);
    }];
    self.iconIv = [[UIImageView alloc] init];
    [tokenView addSubview:self.iconIv];
    self.nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:14 textColor:[UIColor g_whiteTextColor]];
    [tokenView addSubview:self.nameLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_small"]];
    [tokenView addSubview:arrowIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.centerY.offset(0);
        make.width.height.mas_equalTo(18);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(18);
        make.centerY.offset(0);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-18);
    }];
    self.sendingView = [[UIView alloc] init];
    self.sendingView.backgroundColor = [UIColor g_bgCardColor];
    [coinSendView addSubview:self.sendingView];
    [self.sendingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tokenView.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
    self.transferCountView = [[UIView alloc] init];
    self.transferCountView.backgroundColor = [UIColor g_bgCardColor];
    [self.transferCountView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.transferCountView];
    self.receiveAddressView = [[UIView alloc] init];
    self.receiveAddressView.backgroundColor = [UIColor g_bgCardColor];
    [self.receiveAddressView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.receiveAddressView];
    self.minersFeeView = [[UIView alloc] init];
    self.minersFeeView.backgroundColor = [UIColor g_bgCardColor];
    [self.minersFeeView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.minersFeeView];
    [self.transferCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.equalTo(coinSendView.mas_bottom).offset(18);
        make.height.offset(80);
    }];
    [self.receiveAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transferCountView.mas_bottom).offset(18);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(80);
    }];
    [self.minersFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiveAddressView.mas_bottom).offset(18);
        make.left.offset(36);
        make.right.offset(-36);
        make.bottom.offset(-10);
    }];
    [self createSendingAddressItems];
    [self createTransferCountItems];
    [self createReceiveAddressItems];
    [self createMinersFeeItems];
}
- (void)createSendingAddressItems {
    UILabel *tipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_sendAddress") fontSize:20 textColor:[UIColor g_textColor]];
    [self.sendingView addSubview:tipLb];
    self.sendAddressLb = [PW_ViewTool labelMediumText:@"--" fontSize:14 textColor:[UIColor g_grayTextColor]];
    [self.sendingView addSubview:self.sendAddressLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.bottom.equalTo(self.sendingView.mas_centerY).offset(-2);
    }];
    [self.sendAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendingView.mas_centerY).offset(2);
        make.left.equalTo(tipLb);
    }];
}
- (void)createTransferCountItems {
    UILabel *tipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_transferCount") fontSize:20 textColor:[UIColor g_textColor]];
    [self.transferCountView addSubview:tipLb];
    self.balanceLb = [PW_ViewTool labelText:NSStringWithFormat(@"%@:%@",LocalizedStr(@"text_balance"),self.model.tokenAmount) fontSize:14 textColor:[UIColor g_grayTextColor]];
    [self.transferCountView addSubview:self.balanceLb];
    self.countTF = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:22] color:[UIColor g_primaryColor] placeholder:@"0.0"];
    self.countTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.transferCountView addSubview:self.countTF];
    UIButton *allBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_all") fontSize:18 titleColor:[UIColor g_primaryColor] imageName:nil target:self action:@selector(allAction)];
    [allBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [allBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.transferCountView addSubview:allBtn];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(14);
    }];
    [self.balanceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-18);
        make.centerY.equalTo(tipLb);
    }];
    [self.countTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.bottom.offset(-10);
        make.height.offset(35);
        make.right.equalTo(allBtn.mas_left).offset(-10);
    }];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-18);
        make.centerY.equalTo(self.countTF);
    }];
}
- (void)createReceiveAddressItems {
    UILabel *tipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_receiveAddress") fontSize:20 textColor:[UIColor g_textColor]];
    [self.receiveAddressView addSubview:tipLb];
    UIButton *addressBookBtn = [PW_ViewTool buttonImageName:@"icon_addressBook" target:self action:@selector(addressBookAction)];
    [self.receiveAddressView addSubview:addressBookBtn];
    UIButton *scanBtn = [PW_ViewTool buttonImageName:@"icon_scan_black" target:self action:@selector(scanAction)];
    [self.receiveAddressView addSubview:scanBtn];
    self.addressTF = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:@"Input"];
    self.addressTF.keyboardType = UIKeyboardTypeAlphabet;
    [self.receiveAddressView addSubview:self.addressTF];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(14);
        make.left.offset(18);
    }];
    [addressBookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(12);
        make.right.equalTo(scanBtn.mas_left).offset(-18);
    }];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(12);
        make.right.offset(-20);
    }];
    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.bottom.offset(-10);
        make.height.offset(30);
        make.right.offset(-18);
    }];
}
- (void)createMinersFeeItems {
    UILabel *tipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_minersFee") fontSize:20 textColor:[UIColor g_textColor]];
    [self.minersFeeView addSubview:tipLb];
    UIButton *customBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_custom") fontSize:14 titleColor:[UIColor g_textColor] imageName:nil target:self action:@selector(customFeeAction)];
    [self.minersFeeView addSubview:customBtn];
    self.minersFeeLb = [PW_ViewTool labelText:@"--" fontSize:14 textColor:[UIColor g_grayTextColor]];
    [self.minersFeeView addSubview:self.minersFeeLb];
    self.minersFeeUTLb = [PW_ViewTool labelText:@"--" fontSize:14 textColor:[UIColor g_grayTextColor]];
    [self.minersFeeView addSubview:self.minersFeeUTLb];
    self.gweiLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_textColor]];
    [self.minersFeeView addSubview:self.gweiLb];
    [self.minersFeeView addSubview:self.sliderView];
    self.speedFeeView = [[UIView alloc] init];
    [self.minersFeeView addSubview:self.speedFeeView];
    NSArray *titleArr = @[LocalizedStr(@"text_slow"),LocalizedStr(@"text_avg"),LocalizedStr(@"text_fast"),LocalizedStr(@"text_soon")];
    UIView *lastBtn = nil;
    for (NSInteger i=0;i<titleArr.count;i++) {
        NSString *text = titleArr[i];
        UIButton *btn = [PW_ViewTool buttonSemiboldTitle:text fontSize:14 titleColor:[UIColor g_grayTextColor] cornerRadius:14 backgroundColor:nil target:self action:@selector(changeSpeedAction:)];
        btn.tag = SpeedFeeBtnTag+i;
        [btn setTitleColor:[UIColor g_whiteTextColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor g_hex:@"#E6E6E6"] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor g_hex:@"#333333"] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        if(i==self.speedFeeIdx){
            btn.selected = YES;
            self.selectedSpeedFeeBtn = btn;
        }
        [self.speedFeeView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastBtn){
                make.left.equalTo(lastBtn.mas_right).offset(15);
                make.width.equalTo(lastBtn);
            }else{
                make.left.offset(0);
            }
            make.top.bottom.offset(0);
            if(i==titleArr.count-1){
                make.right.offset(0);
            }
        }];
        lastBtn = btn;
    }
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(14);
        make.left.offset(18);
    }];
    [customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipLb);
        make.right.offset(-18);
    }];
    [self.minersFeeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.equalTo(tipLb.mas_bottom).offset(8);
    }];
    [self.minersFeeUTLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minersFeeLb.mas_right).offset(0);
        make.centerY.equalTo(self.minersFeeLb);
    }];
    [self.gweiLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.minersFeeLb.mas_bottom).offset(8);
    }];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.equalTo(self.gweiLb.mas_bottom).offset(4);
    }];
    [self.speedFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sliderView.mas_bottom).offset(6);
        make.left.offset(18);
        make.right.offset(-18);
        make.height.offset(28);
        make.bottom.offset(-20).priorityMedium();
    }];
    self.customFeeView = [[UIView alloc] init];
    [self.minersFeeView addSubview:self.customFeeView];
    UILabel *gasPriceLb = [PW_ViewTool labelMediumText:@"Gas Price" fontSize:20 textColor:[UIColor g_textColor]];
    [self.customFeeView addSubview:gasPriceLb];
    UILabel *gasLb = [PW_ViewTool labelMediumText:@"Gas Limit" fontSize:20 textColor:[UIColor g_textColor]];
    [self.customFeeView addSubview:gasLb];
    UIView *gasPriceView = [[UIView alloc] init];
    [gasPriceView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.customFeeView addSubview:gasPriceView];
    UIView *gasView = [[UIView alloc] init];
    [gasView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.customFeeView addSubview:gasView];
    UILabel *gasPriceGweiLb = [PW_ViewTool labelBoldText:@"GWEI" fontSize:14 textColor:[UIColor g_grayTextColor]];
    [gasPriceGweiLb setRequiredHorizontal];
    [gasPriceView addSubview:gasPriceGweiLb];
    self.gasPriceTF = [PW_ViewTool textFieldFont:[UIFont pw_mediumFontOfSize:14] color:[UIColor g_textColor] placeholder:@"0.0"];
    self.gasPriceTF.keyboardType = UIKeyboardTypeNumberPad;
    [gasPriceView addSubview:self.gasPriceTF];
    self.gasTF = [PW_ViewTool textFieldFont:[UIFont pw_mediumFontOfSize:14] color:[UIColor g_textColor] placeholder:@"0.0"];
    self.gasTF.keyboardType = UIKeyboardTypeNumberPad;
    [gasView addSubview:self.gasTF];
    [self.customFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speedFeeView.mas_bottom).offset(0);
        make.left.offset(18);
        make.right.offset(-18);
        make.bottom.offset(-20);
    }];
    [gasPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.left.offset(0);
    }];
    [gasLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gasPriceLb);
        make.left.equalTo(self.minersFeeView.mas_centerX).offset(7);
    }];
    [gasPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(gasPriceLb.mas_bottom).offset(15);
        make.height.offset(28);
        make.bottom.offset(0);
    }];
    [self.gasPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.offset(0);
        make.right.equalTo(gasPriceGweiLb.mas_left).offset(-5);
    }];
    [gasPriceGweiLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-14);
        make.centerY.offset(0);
    }];
    [gasView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gasPriceView.mas_right).offset(14);
        make.top.width.height.equalTo(gasPriceView);
        make.right.offset(0);
    }];
    [self.gasTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.right.offset(0);
    }];
}

#pragma mark - lazy
- (PW_SliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[PW_SliderView alloc] init];
        [_sliderView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        _sliderView.maximumValue = 100;
        _sliderView.minimumValue = 0;
        _sliderView.continuous = NO;
        _sliderView.userInteractionEnabled = NO;
    }
    return _sliderView;
}
- (PW_GasToolModel *)gasToolModel {
    if (!_gasToolModel) {
        _gasToolModel = [[PW_GasToolModel alloc] init];
    }
    return _gasToolModel;
}
- (PW_GasModel *)gasModel {
    if (!_gasModel) {
        _gasModel = self.gasToolModel.recommendModel;
    }
    return _gasModel;
}
- (PW_GasModel *)customGasModel {
    if (!_customGasModel) {
        _customGasModel = [[PW_GasModel alloc] init];
    }
    return _customGasModel;
}

@end
