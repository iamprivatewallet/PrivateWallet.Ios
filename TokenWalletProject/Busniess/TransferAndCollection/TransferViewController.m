//
//  TransferViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/12.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "TransferViewController.h"
#import "MinersfeeSettingVC.h"
#import "AddressBookViewController.h"
#import "TransferView.h"
#import "RiskWarningView.h"
#import "TransferPayView.h"
#import "WBQRCodeVC.h"
#import "AdvancedModeVC.h"
#import "CVNServerMananger.h"
#import "brewchain.h"
#import "CollectionViewController.h"

@interface TransferViewController ()
<
TransferViewDelegate,
TransferPayViewDelegate,
WBQRCodeDelegate,
WKUIDelegate,
WKNavigationDelegate
>
@property (nonatomic, strong) TransferView *transferView;
@property (nonatomic, strong) TransferInputModel *inputModel;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:NSStringWithFormat(@"%@ 转账",self.coinModel.tokenName) rightImg:@"scan" rightAction:@selector(scanRightNavAction)];
    if ([self.coinModel.currentWallet.type isEqualToString:@"CVN"]) {
        [self loadDataForGetCVNNonce];
    }else{
        [self loadDataForNonce];
    }
    [self makeViews];
    [self makeTransferData];
    // Do any additional setup after loading the view.
}
- (void)makeTransferData{
    [self.transferView setViewWithModel:self.coinModel];
    if (self.codeInfoModel) {
        [self.transferView setCodeInfoWithModel:self.codeInfoModel];
    }
    [[PWWalletContractTool shared] estimateGasToAddress:nil completionHandler:^(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc) {
        if(gas){
            GasPriceModel *mdl = [[GasPriceModel alloc] init];
            NSString *gas_gwei = [gasPrice stringDownDividingBy10Power:9];
            mdl.gas_gwei = gas_gwei;
            mdl.gas = gas;
            mdl.all_gasAmount = [[[mdl.gas_gwei stringDownMultiplyingBy:mdl.gas] stringDownDividingBy10Power:9] doubleValue];
            [self.transferView setGasPriceWithData:mdl];
        }
    }];
//    NSDictionary *params = @{
//        @"to":self.inputModel.address,
//        @"value":[self.inputModel.amount stringDownMultiplyingBy10Power:self.coinModel.decimals],
//        @"from":User_manager.currentUser.chooseWallet_address,
//    };
//    NSDictionary *parmDic = @{
//                    @"id":@"67",
//                    @"jsonrpc":@"2.0",
//                    @"method":@"eth_estimateGas",
//                    @"params":@[params]
//                    };
//    [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
//        if (data) {
//            GasPriceModel *mdl = [[GasPriceModel alloc] init];
//            mdl.gas_gwei = @"5";
//            mdl.gas = @([data[@"result"] stringTo10]).stringValue;
//            mdl.all_gasAmount = [[@([mdl.gas_gwei intValue]*[mdl.gas intValue]).stringValue stringDownDividingBy10Power:9] doubleValue];
//            [self.transferView setGasPriceWithData:mdl];
//        }
//    }];
}

- (void)backPrecious{
    if (self.codeInfoModel) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    [self.view addSubview:self.transferView];
    [self.transferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark ETH 转账
- (void)loadDataForNonce {
    //获取 ETH nonce
    NSDictionary *parmDic = @{
                    @"id":@"67",
                    @"jsonrpc":@"2.0",
                    @"method":@"eth_getTransactionCount",
                    @"params":@[self.coinModel.currentWallet.address,@"latest"]
                    };
    [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
        if (data) {
            self.coinModel.nonce = data[@"result"];
        }
    }];
}
// 获取ETH 签名
- (void)loadColdWalletTransferETH{
    if ([self.coinModel.tokenAddress isEqualToString:self.coinModel.currentWallet.address]) {
        NSDictionary *dic = @{
            @"nonce":self.coinModel.nonce,
            @"to_addr":self.inputModel.address,
            @"value":[self.inputModel.amount stringRaisingToPower18],
            @"gas_price":self.inputModel.gas_price,
            @"prikey":self.coinModel.currentWallet.priKey
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
            @"nonce":self.coinModel.nonce,
            @"to_addr":self.inputModel.address,
            @"value":[self.inputModel.amount stringRaisingToPower18],
            @"gas_price":self.inputModel.gas_price,
            @"contract_addr":self.coinModel.tokenAddress,
            @"prikey":self.coinModel.currentWallet.priKey
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
-(void)ETHTransferWithSign:(NSString *)sign{
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
                [UITools showToast:data[@"error"][@"message"]];
            }else{
                SetUserDefaultsForKey(@"0", @"isFirstTransfer");
                [UserDefaults synchronize];
                [self showSuccessMessage:@"交易已广播"];
                [self saveTransferRecordWithHash:data[@"result"]];
                if (self.transferSuccessBlock) {
                    self.transferSuccessBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.codeInfoModel) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
            }
        }else{
            [self showFailMessage:error.localizedDescription];
        }
    }];
}
#pragma mark CVN 转账
- (void)loadDataForGetCVNNonce {
    //获取CVN nonce
    [[CVNServerMananger sharedInstance] fetchBalance:self.coinModel.currentWallet.address contractAddr:@"" resultBlock:^(ETHBalance * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.coinModel.nonce = data.nonce;
        }
    }];
}

//CVN主币 转账
- (void)loadTransferCVNMain{
    [self.view showLoadingIndicator];
    NSMutableString *args = [NSMutableString new];
    JKBigDecimal *big = [[JKBigDecimal alloc]initWithString:@"1000000000000000000"];
    JKBigDecimal *result =  [big multiply:[[JKBigDecimal alloc]initWithString:self.inputModel.amount]];
    NSString *str = [result stringValue];
    NSArray *arr = [str componentsSeparatedByString:@"."];
    [args appendFormat:@"[{\"address\":\"%@\",\"amount\":\"%@\"}]",[self.inputModel.address formatDelCVN],arr[0]];
    NSData *tipData = [self.inputModel.tips dataUsingEncoding:NSUTF8StringEncoding];
    NSString *results = [CWVChainUtils signTransferAddress:[User_manager.currentUser.chooseWallet_address formatDelCVN] prikey:self.coinModel.currentWallet.priKey nonce:self.coinModel.nonce exdata:[tipData toHexStr] args:args];
    @weakify(self);
    [[CVNServerMananger sharedInstance] transfer:results resultBlock:^(id  _Nullable data, NSError * _Nullable error) {
        [self.view hideLoadingIndicator];
        if (data) {
            if ([data[@"retCode"]intValue] == 1) {
                @strongify(self);
                SetUserDefaultsForKey(@"0", @"isFirstTransfer");
                [UserDefaults synchronize];
                [self showSuccessMessage:@"交易已广播"];
                [self saveTransferRecordWithHash:data[@"hash"]];
                if (self.transferSuccessBlock) {
                    self.transferSuccessBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [UITools showToast:data[@"retMsg"]];
            }
        }else{
            [UITools showToast:@"网络错误，请重试"];
        }
    }];
}
//CVN代币 通过web代理
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if ([self.coinModel.currentWallet.type isEqualToString:@"CVN"]) {
        if (![self.coinModel.tokenAddress isEqualToString:self.coinModel.currentWallet.address]) {
            JKBigDecimal *big = [[JKBigDecimal alloc]initWithString:@"1000000000000000000"];
            JKBigDecimal *result =  [big multiply:[[JKBigDecimal alloc]initWithString:self.inputModel.amount]];
            NSString *str = [result stringValue];
            NSArray *arr = [str componentsSeparatedByString:@"."];
            //获取签名
            NSString *keystoreJs = NSStringWithFormat(@"getTransactionC20Tx(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",self.coinModel.currentWallet.priKey,self.coinModel.nonce, [self.inputModel.address formatDelCVN], self.coinModel.tokenAddress,arr[0]);
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
                [self showSuccessMessage:@"交易已广播"];
                [self saveTransferRecordWithHash:data[@"hash"]];
                if (self.transferSuccessBlock) {
                    self.transferSuccessBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [UITools showToast:data[@"retMsg"]];
            }
        }else{
            [UITools showToast:@"网络错误，请重试"];
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
    NSString *timeStr = NSStringWithFormat(@"%.0f",[[NSDate new] timeIntervalSince1970]*1000);
    NSDictionary *dic = @{
        @"amount":self.inputModel.amount,
        @"from_addr":self.coinModel.currentWallet.address,
        @"to_addr":self.inputModel.address,
        @"token_name":self.coinModel.tokenName,
        @"token_address":self.coinModel.tokenAddress,
        @"create_time":timeStr,
        @"trade_id":hash,
        @"gas_price":self.inputModel.gas_price,
        @"gas":self.inputModel.gas,
    };
    WalletRecord *record = [WalletRecord mj_objectWithKeyValues:dic];
    [[WalletRecordManager shareRecordManager] saveRecord:record];
}
//扫一扫
- (void)scanRightNavAction{
    //扫描
    if (![CATCommon isHaveAuthorForCamer]) {
        return;
    }
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    WBVC.delegate = self;
    WBVC.zh_showCustomNav = YES;
    [UITools QRCodeFromVC:self scanVC:WBVC];
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
#pragma mark Delegate
//转账下一步
- (void)nextStepActionWithData:(TransferInputModel *)data{
    self.inputModel = data;
    NSString *isFirstTransfer = GetUserDefaultsForKey(@"isFirstTransfer");
    if ([isFirstTransfer boolValue]) {
        [RiskWarningView getRiskWarningViewWithAction:^{
            [self showTransferPayView];
        }];
    }else{
        [self showTransferPayView];
    }
}
- (void)showTransferPayView{
    [TransferPayView showView:self.view inputData:self.inputModel walletData:self.coinModel isDAppsShow:NO delegate:self];
}
//密码支付 转账
- (void)transferPayAction{
    [self makeTransfer];
}
//跳过输入密码，FaceID 支付
- (void)secretFreePaymentAction{
    UnlockSupportType type = [SWFingerprintLock checkUnlockSupportType];
    if (type != JUnlockType_None) {
        [SWFingerprintLock unlockWithResultBlock:^(UnlockResult result, NSString * _Nonnull errMsg) {
            if (result == JUnlockSuccess) {
                [self makeTransfer];
            }else{
                [self showFailMessage:errMsg];
            }
        }];
    }
}
//分类型转账
- (void)makeTransfer{
    if ([self.coinModel.currentWallet.type isEqualToString:@"CVN"]) {
        if ([self.coinModel.tokenAddress isEqualToString:self.coinModel.currentWallet.address]) {
            [self loadTransferCVNMain];
        }else{
            [self loadTransferDai];
        }
    }else{
        [self loadColdWalletTransferETH];
    }
}

//地址本
- (void)addressAction{
    AddressBookViewController *vc = [[AddressBookViewController alloc] init];
    vc.isChooseAddr = YES;
    vc.chooseAddressBlock = ^(NSString * _Nonnull addr) {
        //选择地址
        self.transferView.addrTF.text = addr;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)minersfeeAction{
    //矿工费设置
    MinersfeeSettingVC *vc = [[MinersfeeSettingVC alloc] init];
    NSDictionary *dic = @{
        @"to":self.inputModel.address,
        @"value":[self.inputModel.amount stringDownMultiplyingBy10Power:self.coinModel.decimals],
        @"from":User_manager.currentUser.chooseWallet_address,
    };
    vc.params = dic;
    vc.chooseGasPriceBlock = ^(GasPriceModel * _Nonnull gasPriceModel) {
        [self.transferView setGasPriceWithData:gasPriceModel];;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)advancedModeAction {
    //高级模式
    AdvancedModeVC *vc = [[AdvancedModeVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)exchangeAction {
    //兑换
    CollectionViewController *vc = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK: WBQRCodeDelegate
- (void)scanResult:(NSString*)result{
    NSString *ethKey = @"ethereum:";
//    NSString *contractKey = @"contractAddress=";
    NSString *valueKey = @"value=";
    if ([result containsString:ethKey]) {
        NSString *addrStr = [UITools subRangeStr:result fromStart:ethKey toEnd:@"?"];
        self.transferView.addrTF.text = addrStr;
        NSRange range = [result rangeOfString:valueKey];
        NSString *amount = [result substringFromIndex:range.location+valueKey.length];
        if ([amount isEqualToString:@"0"]) {
            self.transferView.amountTF.text = @"";
        }else{
            self.transferView.amountTF.text = amount;
        }
    }else{
        if ([result hasPrefix:@"0x"] && result.length == 42) {
            self.transferView.addrTF.text = result;
        }else{
            [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"地址格式有误" toView:self.view];
        }
    }
}
- (TransferView *)transferView{
    if (!_transferView) {
        _transferView = [[TransferView alloc] init];
        _transferView.delegate = self;
    }
    return _transferView;
}

@end
