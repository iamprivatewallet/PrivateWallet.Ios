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

static NSInteger SpeedFeeBtnTag = 100;

@interface PW_TransferViewController () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) UIImageView *topBgIv;

@property (nonatomic, strong) UILabel *sendAddressLb;

@property (nonatomic, strong) UIView *tokenView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *subNameLb;

@property (nonatomic, strong) UIView *contentView;
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

@property (nonatomic, weak) UIButton *selectedSpeedFeeBtn;
@property (nonatomic, assign) NSInteger speedFeeIdx;
@property (nonatomic, assign) BOOL showCustomFee;
@property (nonatomic, strong) PW_GasToolModel *gasToolModel;
@property (nonatomic, strong) PW_GasModel *gasModel;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation PW_TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_transfer") rightImg:@"icon_scan_white" rightAction:@selector(scanAction)];
    [self setupWhiteNavBarTint];
    self.speedFeeIdx = 1;
    [self makeViews];
    [self refreshUI];
    [self requestGasData];
    if ([User_manager.currentUser.chooseWallet_type isEqualToString:WalletTypeCVN]) {
        [self loadDataForGetCVNNonce];
    }else{
        [self loadDataForNonce];
    }
    __weak typeof(self) weakSelf = self;
    [RACObserve(self, showCustomFee) subscribeNext:^(NSNumber * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
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
        strongSelf.selectedSpeedFeeBtn.selected = NO;
        strongSelf.selectedSpeedFeeBtn.layer.borderWidth = 1;
        strongSelf.selectedSpeedFeeBtn.layer.borderColor = [[UIColor g_borderColor] CGColor];
        UIButton *btn = [strongSelf.speedFeeView viewWithTag:SpeedFeeBtnTag+x.integerValue];
        btn.selected = YES;
        btn.layer.borderWidth = 2;
        btn.layer.borderColor = [[UIColor g_primaryColor] CGColor];
        strongSelf.selectedSpeedFeeBtn = btn;
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
//    self.showCustomFee = !self.showCustomFee;
}
- (void)sliderValueChange:(PW_SliderView *)slider {
    
}
- (void)changeSpeedAction:(UIButton *)btn {
    self.speedFeeIdx = btn.tag-SpeedFeeBtnTag;
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
    [PW_TipTool showPayPwdSureBlock:^(NSString * _Nonnull pwd) {
        if (![pwd isEqualToString:User_manager.currentUser.user_pass]) {
            return [self showError:LocalizedStr(@"text_pwdError")];
        }
        [self transferAction];
    }];
}
- (void)transferAction {
    User *user = User_manager.currentUser;
    if ([user.chooseWallet_type isEqualToString:WalletTypeCVN]) {
        if ([self.model.tokenContract isEqualToString:user.chooseWallet_address]) {
            [self loadTransferCVNMain];
        }else{
            [self loadTransferDai];
        }
    }else{
        [self loadColdWalletTransferETH];
    }
}
- (void)changeTokenAction {
    PW_ChooseCurrencyViewController *vc = [[PW_ChooseCurrencyViewController alloc] init];
    vc.selectedTokenContract = self.model.tokenContract;
    vc.chooseBlock = ^(PW_TokenModel * _Nonnull model) {
        self.model = model;
        [self refreshUI];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshUI {
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:self.model.tokenLogo] placeholderImage:[UIImage imageNamed:@"icon_token_default"]];
    self.nameLb.text = self.model.tokenName;
    self.subNameLb.text = [self.model.tokenName lowercaseString];
    NSString *walletAddress = User_manager.currentUser.chooseWallet_address;
    self.sendAddressLb.text = [walletAddress showShortAddress];
}
- (void)refreshGasUI {
    if (![self.gasModel.gas_price isNoEmpty]) {
        return;
    }
    self.sliderView.value = [self.gasModel.gas_price doubleValue];
    self.minersFeeLb.text = NSStringWithFormat(@"%@%@",self.gasModel.gas_amount,[[SettingManager sharedInstance] getChainCoinName]);
    self.minersFeeUTLb.text = NSStringWithFormat(@"≈ $%@",self.gasModel.gas_ut_amout);
    self.gweiLb.text = NSStringWithFormat(@"%@ GWEI",self.gasModel.gas_gwei);
}
- (void)requestGasData {
    [MOSWalletContractTool estimateGasToAddress:nil value:nil completionBlock:^(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc) {
        if(gas){
            self.gasToolModel.gas_price = gasPrice;
            self.gasToolModel.gas = gas;
            self.gasToolModel.price = [PW_GlobalData shared].mainTokenModel.price;
            self.gasModel = self.gasToolModel.recommendModel;;
            self.sliderView.minimumValue = [self.gasToolModel.slowModel.gas_price doubleValue];
            self.sliderView.maximumValue = [self.gasToolModel.soonModel.gas_price doubleValue];
            [self refreshGasUI];
        }
    }];
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
    [[CVNServerMananger sharedInstance] transfer:results resultBlock:^(id  _Nullable data, NSError * _Nullable error) {
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
    model.toAddress = self.address;
    model.tokenName = self.model.tokenName;
    model.timeStamp = [[NSDate new] timeIntervalSince1970]*1000;
    model.hashStr = hash;
    model.gasPrice = self.gasModel.gas_price;
    model.gas = self.gasModel.gas;
    [[PW_TokenTradeRecordManager shared] saveRecord:model];
}
//CVN代币 通过web代理
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    User *user = User_manager.currentUser;
    Wallet *wallet = [[SettingManager sharedInstance] getCurrentWallet];
    if ([user.chooseWallet_type isEqualToString:WalletTypeCVN]) {
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
    [[CVNServerMananger sharedInstance]transfer:txStr resultBlock:^(id  _Nullable data, NSError * _Nullable error) {
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
    Wallet *wallet = [[SettingManager sharedInstance] getCurrentWallet];
    if ([self.model.tokenContract isEqualToString:User_manager.currentUser.chooseWallet_address]) {
        NSDictionary *dic = @{
            @"nonce":self.model.nonce,
            @"to_addr":self.address,
            @"value":[self.amount stringRaisingToPower18],
            @"gas_price":self.gasModel.gas_price,
            @"prikey":wallet.priKey
        };
        @weakify(self);
        [FchainTool genETHTransactionSign:dic isToken:NO block:^(NSString * _Nonnull result) {
            @strongify(self);
            NSString *sign = NSStringWithFormat(@"0x%@",result);
            [self ETHTransferWithSign:sign];
        }];
    }else{
        //ETH代币
        NSDictionary *dic = @{
            @"nonce":self.model.nonce,
            @"to_addr":self.address,
            @"value":[self.amount stringRaisingToPower18],
            @"gas_price":self.gasModel.gas_price,
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
    [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
        if (data) {
            if (data[@"error"]) {
                if ([data[@"error"][@"code"] isEqualToString:@"-32000"]) {
                    [self loadDataForNonce];
                }
                [self showToast:data[@"error"][@"message"]];
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
            [self showFailMessage:error.localizedDescription];
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
    self.topBgIv = [[UIImageView alloc] init];
    self.topBgIv.image = [UIImage pw_imageGradientSize:CGSizeMake(SCREEN_WIDTH, 248) gradientColors:@[[UIColor g_hex:@"#2A8094"],[UIColor g_hex:@"#195179"]] gradientType:PW_GradientLeftToRight];
    [self.view insertSubview:self.topBgIv atIndex:0];
    self.tokenView = [[UIView alloc] init];
    self.tokenView.backgroundColor = [UIColor g_bgColor];
    [self.tokenView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    self.tokenView.layer.cornerRadius = 21;
    [self.tokenView addTapTarget:self action:@selector(changeTokenAction)];
    [self.view addSubview:self.tokenView];
    [self.topBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(248);
    }];
    [self.tokenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(20);
        make.left.offset(20);
        make.height.offset(42);
    }];
    [self createTokenItems];
    [self createSendTipView];
    [self createBodyView];
}
- (void)createTokenItems {
    self.iconIv = [[UIImageView alloc] init];
    [self.tokenView addSubview:self.iconIv];
    self.nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    [self.tokenView addSubview:self.nameLb];
    self.subNameLb = [PW_ViewTool labelMediumText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.tokenView addSubview:self.subNameLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_dark"]];
    [self.tokenView addSubview:arrowIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(25);
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(10);
        make.centerY.offset(0);
    }];
    [self.subNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.mas_right).offset(5);
        make.bottom.equalTo(self.nameLb);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subNameLb.mas_right).offset(18);
        make.centerY.offset(0);
        make.right.offset(-20);
    }];
}
- (void)createSendTipView {
    UILabel *tipLb = [PW_ViewTool labelText:NSStringWithFormat(@"%@：",LocalizedStr(@"text_sendAddress")) fontSize:14 textColor:[UIColor whiteColor]];
    [self.view addSubview:tipLb];
    self.sendAddressLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:14 textColor:[UIColor whiteColor]];
    [self.view addSubview:self.sendAddressLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(24);
        make.top.equalTo(self.tokenView.mas_bottom).offset(14);
    }];
    [self.sendAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLb.mas_right).offset(0);
        make.centerY.equalTo(tipLb);
    }];
}
- (void)createBodyView {
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgIv.mas_bottom).offset(-32);
        make.left.right.bottom.offset(0);
    }];
    [bodyView setRadius:32 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    UIButton *nextBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_nextStep") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(nextAction)];
    [bodyView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
        make.bottom.offset(-SafeBottomInset-20);
    }];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [bodyView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(34);
        make.left.right.offset(0);
        make.bottom.equalTo(nextBtn.mas_top).offset(-10);
    }];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.width.equalTo(scrollView);
    }];
    self.transferCountView = [[UIView alloc] init];
    [self.transferCountView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.transferCountView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [self.contentView addSubview:self.transferCountView];
    self.receiveAddressView = [[UIView alloc] init];
    [self.receiveAddressView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.receiveAddressView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [self.contentView addSubview:self.receiveAddressView];
    self.minersFeeView = [[UIView alloc] init];
    [self.minersFeeView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.minersFeeView];
    [self.transferCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.offset(0);
        make.height.offset(80);
    }];
    [self.receiveAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transferCountView.mas_bottom).offset(18);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(80);
    }];
    [self.minersFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiveAddressView.mas_bottom).offset(18);
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-10);
    }];
    [self createTransferCountItems];
    [self createReceiveAddressItems];
    [self createMinersFeeItems];
}
- (void)createTransferCountItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_transferCount") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.transferCountView addSubview:tipLb];
    self.balanceLb = [PW_ViewTool labelText:NSStringWithFormat(@"%@：%@",LocalizedStr(@"text_balance"),self.model.tokenAmount) fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.transferCountView addSubview:self.balanceLb];
    self.countTF = [[UITextField alloc] init];
    self.countTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.countTF pw_setPlaceholder:@"0.00"];
    self.countTF.font = [UIFont pw_mediumFontOfSize:28];
    [self.transferCountView addSubview:self.countTF];
    UIButton *allBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_all") fontSize:13 titleColor:[UIColor g_primaryColor] imageName:nil target:self action:@selector(allAction)];
    [allBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [allBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.transferCountView addSubview:allBtn];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(14);
    }];
    [self.balanceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-18);
        make.top.offset(14);
    }];
    [self.countTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.bottom.offset(-10);
        make.height.offset(38);
        make.right.equalTo(allBtn.mas_left).offset(-10);
    }];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-18);
        make.centerY.equalTo(self.countTF);
    }];
}
- (void)createReceiveAddressItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_receiveAddress") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.receiveAddressView addSubview:tipLb];
    UIButton *addressBookBtn = [PW_ViewTool buttonImageName:@"icon_addressBook" target:self action:@selector(addressBookAction)];
    [self.receiveAddressView addSubview:addressBookBtn];
    self.addressTF = [[UITextField alloc] init];
    self.addressTF.keyboardType = UIKeyboardTypeAlphabet;
    [self.addressTF pw_setPlaceholder:NSStringWithFormat(@"%@%@",User_manager.currentUser.chooseWallet_type,LocalizedStr(@"text_walletAddress"))];
    self.addressTF.font = [UIFont pw_regularFontOfSize:16];
    [self.receiveAddressView addSubview:self.addressTF];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(14);
        make.left.offset(18);
    }];
    [addressBookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.right.offset(-22);
    }];
    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.bottom.offset(-10);
        make.height.offset(30);
        make.right.offset(-18);
    }];
}
- (void)createMinersFeeItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_minersFee") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.minersFeeView addSubview:tipLb];
    UIButton *customBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_custom") fontSize:13 titleColor:[UIColor g_textColor] imageName:nil target:self action:@selector(customFeeAction)];
    [self.minersFeeView addSubview:customBtn];
    self.minersFeeLb = [PW_ViewTool labelText:@"--" fontSize:15 textColor:[UIColor g_textColor]];
    [self.minersFeeView addSubview:self.minersFeeLb];
    self.minersFeeUTLb = [PW_ViewTool labelText:@"--" fontSize:15 textColor:[UIColor g_grayTextColor]];
    [self.minersFeeView addSubview:self.minersFeeUTLb];
    self.gweiLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.minersFeeView addSubview:self.gweiLb];
    [self.minersFeeView addSubview:self.sliderView];
    self.speedFeeView = [[UIView alloc] init];
    [self.minersFeeView addSubview:self.speedFeeView];
    NSArray *titleArr = @[LocalizedStr(@"text_slow"),LocalizedStr(@"text_avg"),LocalizedStr(@"text_fast"),LocalizedStr(@"text_soon")];
    UIView *lastBtn = nil;
    for (NSInteger i=0;i<titleArr.count;i++) {
        NSString *text = titleArr[i];
        UIButton *btn = [PW_ViewTool buttonSemiboldTitle:text fontSize:14 titleColor:[UIColor g_textColor] cornerRadius:17.5 backgroundColor:nil target:self action:@selector(changeSpeedAction:)];
        btn.tag = SpeedFeeBtnTag+i;
        [btn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateSelected];
        [btn setBorderColor:[UIColor g_borderColor] width:1 radius:17.5];
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
        make.top.offset(14);
        make.right.offset(-18);
    }];
    [self.minersFeeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.equalTo(tipLb.mas_bottom).offset(8);
    }];
    [self.minersFeeUTLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minersFeeLb.mas_right).offset(10);
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
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(35);
        make.bottom.offset(-20).priorityMedium();
    }];
    self.customFeeView = [[UIView alloc] init];
    [self.minersFeeView addSubview:self.customFeeView];
    UILabel *gasPriceLb = [PW_ViewTool labelBoldText:@"Gas Price" fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.customFeeView addSubview:gasPriceLb];
    UILabel *gasLb = [PW_ViewTool labelBoldText:@"Gas" fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.customFeeView addSubview:gasLb];
    UIView *gasPriceView = [[UIView alloc] init];
    gasPriceView.backgroundColor = [UIColor g_grayBgColor];
    [gasPriceView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.customFeeView addSubview:gasPriceView];
    UIView *gasView = [[UIView alloc] init];
    gasView.backgroundColor = [UIColor g_grayBgColor];
    [gasView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.customFeeView addSubview:gasView];
    UILabel *gasPriceGweiLb = [PW_ViewTool labelBoldText:@"GWEI" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [gasPriceGweiLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [gasPriceGweiLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [gasView addSubview:gasPriceGweiLb];
    UILabel *gasGweiLb = [PW_ViewTool labelBoldText:@"GWEI" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [gasGweiLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [gasGweiLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [gasView addSubview:gasGweiLb];
    self.gasPriceTF = [[UITextField alloc] init];
    self.gasPriceTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.gasPriceTF pw_setPlaceholder:@"0.00"];
    self.gasPriceTF.font = [UIFont pw_mediumFontOfSize:14];
    self.gasPriceTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [gasPriceView addSubview:self.gasPriceTF];
    self.gasTF = [[UITextField alloc] init];
    self.gasTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.gasTF pw_setPlaceholder:@"0.00"];
    self.gasTF.font = [UIFont pw_mediumFontOfSize:14];
    self.gasTF.clearButtonMode = UITextFieldViewModeWhileEditing;
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
        make.height.offset(45);
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
        make.top.width.equalTo(gasPriceView);
        make.right.offset(0);
        make.height.offset(45);
    }];
    [self.gasTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.offset(0);
        make.right.equalTo(gasGweiLb.mas_left).offset(-5);
    }];
    [gasGweiLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-14);
        make.centerY.offset(0);
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

@end
