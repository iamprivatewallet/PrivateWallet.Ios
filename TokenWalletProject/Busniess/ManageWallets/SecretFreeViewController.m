//
//  SecretFreeViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/9.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "SecretFreeViewController.h"

@interface SecretFreeViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SecretFreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"免密支付"];
    [self makeViews];
    // Do any additional setup after loading the view.
}
- (void)backPrecious{
    if (self.isPresentShow) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)makeViews{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, SCREEN_HEIGHT-kNavBarAndStatusBarHeight);
    self.scrollView.backgroundColor = COLORFORRGB(0xf2f3f5);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT-kNavBarAndStatusBarHeight)];
    bgView.backgroundColor = self.scrollView.backgroundColor;
    [self.scrollView addSubview:bgView];

    UIImageView *icon = [ZZCustomView imageViewInitView:bgView imageName:@"faceIDRound"];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView).offset(CGFloatScale(35));
        make.width.height.mas_equalTo(60);
    }];
    
    UIView *whiteBg = [[UIView alloc] init];
    whiteBg.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.top.equalTo(icon.mas_bottom).offset(CGFloatScale(35));
        make.height.mas_equalTo(60);
    }];

    UnlockSupportType type = [SWFingerprintLock checkUnlockSupportType];
    NSString *titleStr;
    if (type == JUnlockType_FaceID) {
        titleStr = @"Face ID";
    }else{
        titleStr = @"Touch ID";
    }
    
    UILabel *titleLbl = [ZZCustomView labelInitWithView:whiteBg text:titleStr textColor:[UIColor im_textColor_three] font:GCSFontRegular(16)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBg).offset(CGFloatScale(20));
        make.centerY.equalTo(whiteBg.mas_centerY);
    }];
    
    Wallet *wallet =  [[WalletManager shareWalletManager] getWalletWithAddress:self.wallet.address type:self.wallet.type];
    NSString *imgStr;
    if ([wallet.isOpenID boolValue]) {
        imgStr = @"switchOpen";
    }else{
        imgStr = @"switchClose";
    }
    UIButton *rightBtn = [ZZCustomView buttonInitWithView:whiteBg imageName:imgStr];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteBg).offset(-CGFloatScale(20));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(50), CGFloatScale(25)));
        make.centerY.equalTo(whiteBg);
    }];
    if ([wallet.isOpenID boolValue]) {
        rightBtn.selected = YES;
    }else{
        rightBtn.selected = NO;
    }
    NSArray *list = @[
        @{
            @"title":@"免密支付介绍",
            @"detail":@"免密支付将你的钱包密码通过安全加密算法存储至手机设备的Keychain / Keystore中，交易时调用生物识别(指纹或面容)鉴权，快速完成支付与签名。\n\n开启免密支付后，请妥善备份密码。如果忘记密码，可以通过导入助记词/私钥，重新设置密码。"
        },
        @{
            @"title":@"风险提示",
            @"detail":@"请了解你的手机设备生物识别的安全等级\n大额资产，请勿开启免密支付\n公共手机，请勿开启免密支付"
        },
        @{
            @"title":@"免责声明",
            @"detail":@"手机厂商的生物识别技术安全等级各有差异，我们提醒用户谨慎使用该便捷功能。使用过程中出现任何生物识别技术漏洞引发的资产风险，本软件不承担法律责任。"
        },
    
    ];

    UIView *lastView = nil;
    for (int i = 0; i<list.count; i++) {
        UILabel *titleLbl = [ZZCustomView labelInitWithView:bgView text:list[i][@"title"] textColor:[UIColor im_textColor_three] font:GCSFontRegular(14)];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(CGFloatScale(20));
            make.right.equalTo(bgView).offset(-CGFloatScale(20));
            make.top.equalTo(lastView?lastView.mas_bottom:whiteBg.mas_bottom).offset(30);
        }];
        
        UILabel *detailLbl = [ZZCustomView labelInitWithView:bgView text:list[i][@"detail"] textColor:COLORFORRGB(0x54565e) font:GCSFontRegular(14)];
        detailLbl.numberOfLines = 0;
        [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(titleLbl);
            make.top.equalTo(titleLbl.mas_bottom).offset(CGFloatScale(15));
        }];
        lastView = detailLbl;
        
    }
}
- (void)rightBtnAction:(UIButton *)sender{
    if (!sender.selected) {
        [TokenAlertView showInputPasswordWithTitle:@"输入钱包密码" ViewWithAction:^(NSInteger index, NSString * _Nonnull inputText) {
            if (![inputText isEqualToString:self.wallet.walletPassword]) {
                return [self showAlertViewWithText:@"密码不正确" actionText:@"好"];
            }
            if (index == 1) {//确认
                //开启Face ID | Touch ID
                [SWFingerprintLock unlockWithResultBlock:^(UnlockResult result, NSString * _Nonnull errMsg) {
                    if (result == JUnlockSuccess) {
                        self.wallet.isOpenID = @"1";
                        [[WalletManager shareWalletManager] updataWallet:self.wallet];
                        [sender setImage:ImageNamed(@"switchOpen") forState:UIControlStateNormal];
                        sender.selected = YES;
                        [self showSuccessMessage:@"设置成功"];
                    }else{
                        [self showFailMessage:errMsg];
                    }
                }];
            }
        }];
    }else{
        [self showAlertViewWithText:@"确认关闭免密支付？" action:^(NSInteger index) {
            if (index == 1) {//确认
                self.wallet.isOpenID = @"0";
                [[WalletManager shareWalletManager] updataWallet:self.wallet];
                [sender setImage:ImageNamed(@"switchClose") forState:UIControlStateNormal];
                sender.selected = NO;
            }
        }];
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
