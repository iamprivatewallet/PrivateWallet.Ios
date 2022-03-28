//
//  CustomCurrencyVC.m
//  TokenWalletProject
//
//  Created by FChain on 2021/9/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "CustomCurrencyVC.h"

@interface CustomCurrencyVC ()
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UITextField *symbolTF;
@property (nonatomic, strong) UITextField *decimalTF;

@end

@implementation CustomCurrencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"自定义代币" rightTitle:@"保存" rightAction:@selector(rightNavItemAction) isNoLine:YES];
    [self.rightBtn setTitleColor:[UIColor im_lightGrayColor] forState:UIControlStateNormal];
    self.rightBtn.userInteractionEnabled = NO;
    [self makeViews];
    // Do any additional setup after loading the view.
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    NSArray *titleList = @[@"代币合约地址",@"Symbol",@"Decimal"];
    UIView *lastView = nil;
    for (int i = 0; i<titleList.count; i++) {
        UILabel *titleLbl = [ZZCustomView labelInitWithView:self.view text:titleList[i] textColor:[UIColor blackColor] font:GCSFontRegular(13)];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(lastView? lastView.mas_bottom : self.view).offset(lastView? 20:25+kNavBarAndStatusBarHeight);
        }];
        
        UITextField *tf = [ZZCustomView textFieldInitFrame:CGRectZero view:self.view placeholder:nil delegate:nil font:GCSFontRegular(14) textColor:[UIColor im_textColor_three] bgColor:[UIColor whiteColor]];
        tf.layer.cornerRadius = 8;
        tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
        tf.leftViewMode = UITextFieldViewModeAlways;
        [tf addTarget:self action:@selector(inputTextFieldAction) forControlEvents:UIControlEventEditingChanged];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.top.equalTo(titleLbl.mas_bottom).offset(10);
            make.height.equalTo(@55);
        }];
        if (i == 0) {
            self.addressTF = tf;
        }else if(i == 1){
            self.symbolTF = tf;
        }else{
            self.decimalTF = tf;
        }
        lastView = tf;
    }
}
- (void)rightNavItemAction{//保存
    NSString *address = self.addressTF.text;
    NSString *symbol = self.symbolTF.text;
    NSString *decimal = self.decimalTF.text;
    if(![address hasPrefix:@"0x"]&&![address hasPrefix:@"CVN"]){
        [self showFailMessage:@"地址错误"];
        return;
    }
    if([symbol isEmptyStr]){
        [self showFailMessage:@"symbol为空"];
        return;
    }
    if(![UITools isNumber:decimal]){
        [self showFailMessage:@"decimal错误"];
        return;
    }
    User *user = User_manager.currentUser;
    AssetCoinModel *exitModel = [[WalletCoinListManager shareManager] isExit:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:address chainId:user.current_chainId];
    if(exitModel){
        [self showFailMessage:@"代币已存在"];
        return;
    }
    AssetCoinModel *model = [[AssetCoinModel alloc] init];
    model.sortIndex = [[WalletCoinListManager shareManager] getMaxIndex]+1;
    model.walletType = user.chooseWallet_type;
    model.walletAddress = user.chooseWallet_address;
    model.tokenContract = address;
    model.tokenSymbol = symbol;
    model.tokenDecimals = decimal;
    NSString *type = [[SettingManager sharedInstance] getChainType];
    model.tokenLogo = AppWalletTokenIconURL(type,address);//NSStringWithFormat(@"icon_%@",type);
    model.tokenChain = user.current_chainId;
    model.createTime = [NSDate new].timeIntervalSince1970;
    [[WalletCoinListManager shareManager] saveCoin:model];
    [self showSuccessMessage:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCoinList_Notification" object:nil];
}
- (void)inputTextFieldAction{
    if (self.addressTF.text.length>0 && self.symbolTF.text.length>0 && self.decimalTF.text.length>0) {
        [self.rightBtn setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
        self.rightBtn.userInteractionEnabled = YES;
    }else{
        [self.rightBtn setTitleColor:[UIColor im_lightGrayColor] forState:UIControlStateNormal];
        self.rightBtn.userInteractionEnabled = NO;
    }
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
