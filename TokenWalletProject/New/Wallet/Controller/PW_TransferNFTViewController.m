//
//  PW_TransferNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/3.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TransferNFTViewController.h"
#import "PW_AddressBookViewController.h"
#import "PW_ScanTool.h"
#import "PW_WalletContractTool.h"

static NSInteger SpeedFeeBtnTag = 100;

@interface PW_TransferNFTViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *sendingView;
@property (nonatomic, strong) UIView *transferCountView;
@property (nonatomic, strong) UIView *receiveAddressView;
@property (nonatomic, strong) UIView *minersFeeView;

@property (nonatomic, strong) UILabel *sendAddressLb;
@property (nonatomic, strong) UIImageView *logoIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *tokenIdLb;
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

@end

@implementation PW_TransferNFTViewController

- (PW_GasModel *)getCurrentGasModel {
    if (self.showCustomFee) {
        return self.customGasModel;
    }
    return self.gasModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_transfer")];
    [self makeViews];
    [self requestGasData];
    [self loadDataForNonce];
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
- (void)allAction {
    
}
- (void)addressBookAction {
    PW_AddressBookViewController *vc = [[PW_AddressBookViewController alloc] init];
    vc.chooseBlock = ^(PW_AddressBookModel * _Nonnull model) {
        self.addressTF.text = model.address;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scanAction {
    [[PW_ScanTool shared] showScanWithResultBlock:^(NSString * _Nonnull result) {
        self.addressTF.text = result;
    }];
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
#pragma mark - request
- (void)requestGasData {
//    NSString *tokenAddress = self.model.tokenContract;
    NSString *tokenAddress = @"";
    if (![tokenAddress isNoEmpty]||[tokenAddress.lowercaseString isEqualToString:User_manager.currentUser.chooseWallet_address.lowercaseString]) {
        [PW_WalletContractTool estimateGasToAddress:nil completionHandler:^(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc) {
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
        [PW_WalletContractTool estimateGasTokenToAddress:nil token:tokenAddress completionHandler:^(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc) {
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
- (void)loadDataForNonce {
    NSDictionary *parmDic = @{
                    @"id":@"67",
                    @"jsonrpc":@"2.0",
                    @"method":@"eth_getTransactionCount",
                    @"params":@[User_manager.currentUser.chooseWallet_address,@"latest"]
                    };
    [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
        if (data) {
//            self.model.nonce = data[@"result"];
        }
    }];
}
#pragma mark - views
- (void)makeViews {
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [bodyView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [bodyView addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
        make.bottom.offset(-SafeBottomInset-20);
    }];
    [bodyView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.left.right.offset(0);
        make.bottom.equalTo(self.nextBtn.mas_top).offset(-10);
    }];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.width.mas_equalTo(self.scrollView);
    }];
    [self.contentView addSubview:self.sendingView];
    [self.sendingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(100);
    }];
    [self.contentView addSubview:self.transferCountView];
    [self.contentView addSubview:self.receiveAddressView];
    [self.contentView addSubview:self.minersFeeView];
    [self.transferCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(34);
        make.right.offset(-34);
        make.top.equalTo(self.sendingView.mas_bottom).offset(18);
        make.height.offset(80);
    }];
    [self.receiveAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transferCountView.mas_bottom).offset(18);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.offset(80);
    }];
    [self.minersFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiveAddressView.mas_bottom).offset(18);
        make.left.offset(34);
        make.right.offset(-34);
        make.bottom.offset(-10);
    }];
    [self createSendingAddressItems];
    [self createTransferCountItems];
    [self createReceiveAddressItems];
    [self createMinersFeeItems];
}
- (void)createSendingAddressItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:PW_StrFormat(@"%@：",LocalizedStr(@"text_sendAddress")) fontSize:13 textColor:[UIColor g_textColor]];
    [self.sendingView addSubview:tipLb];
    self.sendAddressLb = [PW_ViewTool labelMediumText:@"--" fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.sendingView addSubview:self.sendAddressLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(12);
    }];
    [self.sendAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipLb);
        make.left.equalTo(tipLb.mas_right);
        make.right.offset(-10);
    }];
    [self.sendingView addSubview:self.logoIv];
    [self.sendingView addSubview:self.nameLb];
    [self.sendingView addSubview:self.tokenIdLb];
    [self.logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.bottom.offset(-15);
        make.left.offset(18);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoIv.mas_right).offset(10);
        make.right.offset(-5);
        make.top.equalTo(self.logoIv);
    }];
    [self.tokenIdLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoIv.mas_right).offset(10);
        make.right.offset(-5);
        make.bottom.equalTo(self.logoIv);
    }];
}
- (void)createTransferCountItems {
    UILabel *tipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_transferCount") fontSize:20 textColor:[UIColor g_textColor]];
    [self.transferCountView addSubview:tipLb];
    self.balanceLb = [PW_ViewTool labelText:NSStringWithFormat(@"%@:%@",LocalizedStr(@"text_balance"),@"0.0") fontSize:14 textColor:[UIColor g_grayTextColor]];
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
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_nextStep") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(nextAction)];
    }
    return _nextBtn;
}
- (UIView *)sendingView {
    if (!_sendingView) {
        _sendingView = [[UIView alloc] init];
        _sendingView.backgroundColor = [UIColor g_bgCardColor];
        [_sendingView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    }
    return _sendingView;
}
- (UIImageView *)logoIv {
    if (!_logoIv) {
        _logoIv = [[UIImageView alloc] init];
    }
    return _logoIv;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:18 textColor:[UIColor g_textColor]];
        _nameLb.numberOfLines = 0;
    }
    return _nameLb;
}
- (UILabel *)tokenIdLb {
    if (!_tokenIdLb) {
        _tokenIdLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
        _tokenIdLb.numberOfLines = 0;
    }
    return _tokenIdLb;
}
- (UIView *)transferCountView {
    if (!_transferCountView) {
        _transferCountView = [[UIView alloc] init];
        _transferCountView.backgroundColor = [UIColor g_bgCardColor];
        [_transferCountView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    }
    return _transferCountView;
}
- (UIView *)receiveAddressView {
    if (!_receiveAddressView) {
        _receiveAddressView = [[UIView alloc] init];
        _receiveAddressView.backgroundColor = [UIColor g_bgCardColor];
        [_receiveAddressView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    }
    return _receiveAddressView;
}
- (UIView *)minersFeeView {
    if (!_minersFeeView) {
        _minersFeeView = [[UIView alloc] init];
        _minersFeeView.backgroundColor = [UIColor g_bgCardColor];
        [_minersFeeView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    }
    return _minersFeeView;
}
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
