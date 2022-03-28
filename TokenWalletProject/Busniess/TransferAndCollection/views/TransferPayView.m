//
//  PayPasswordView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/25.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "TransferPayView.h"
#import "MinersfeeSettingVC.h"
#import "SecretFreeViewController.h"

@interface TransferPayView()
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *nextStepBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *idBtn;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIView *passwordView;
@property (nonatomic, strong) UITextField *pw_TF;

@property(nonatomic, assign) BOOL isPasswordView;
@property(nonatomic, assign) BOOL isOpenID;

@property (nonatomic, copy) void(^clickNextStepAction)(void);

@property (nonatomic, strong) TransferInputModel *inputModel;
@property (nonatomic, strong) WalletCoinModel *coinModel;

@end

@implementation TransferPayView

+(TransferPayView *)showView:(UIView *)view
                   inputData:(id)inputData
                  walletData:(id)walletData
                 isDAppsShow:(BOOL)isDApps
                    delegate:(id)delegate;
{
    TransferPayView *backView = nil;

    [SVProgressHUD dismiss];
    for (TransferPayView *subView in view.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[TransferPayView alloc] initWithFrame:[UIScreen mainScreen].bounds inputData:inputData walletData:walletData isDAppsShow:isDApps];
        
       
        backView.delegate = delegate;
        [view addSubview:backView];
        
        backView.bgView.transform = CGAffineTransformMakeTranslation(0, 600);
        [UIView animateWithDuration:0.4 animations:^{
            backView.bgView.transform = CGAffineTransformMakeTranslation(0,0);
        }];
    }
    
    return backView;
}
- (instancetype)initWithFrame:(CGRect)frame
                    inputData:(id)inputData
                   walletData:(id)walletData
                  isDAppsShow:(BOOL)isDApps
{
    self = [super initWithFrame:frame];
    if (self) {
        self.inputModel = inputData;
        self.coinModel = walletData;
        Wallet *w =  [[WalletManager shareWalletManager] getWalletWithAddress: self.coinModel.currentWallet.address type: self.coinModel.currentWallet.type];
        self.isOpenID = [w.isOpenID boolValue];
        [self makeViewsIsDAppsShow:isDApps];
    }
    return self;
}
- (void)makeViewsIsDAppsShow:(BOOL)isDApps{
    self.isPasswordView = NO;
    
    UIView *shadowBgView = [[UIView alloc] init];
    shadowBgView.backgroundColor = COLORA(0, 0, 0,0.5);
    [self addSubview:shadowBgView];
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.layer.cornerRadius = 8;
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(10);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:ImageNamed(@"close") forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.top.equalTo(self.bgView).offset(CGFloatScale(13));
        make.width.height.equalTo(@25);
    }];
    
    self.nextStepBtn = [ZZCustomView im_ButtonDefaultWithView:self.bgView title:@"下一步" titleFont:GCSFontRegular(16) enable:YES];
    [_nextStepBtn addTarget:self action:@selector(nextStepBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-20);
        make.left.equalTo(self.bgView).offset(20);
        make.bottom.equalTo(self.bgView).offset(-20-kBottomSafeHeight);
        make.height.mas_equalTo(CGFloatScale(45));
    }];
    NSString *idImgStr;
    if (!self.isOpenID) {
        idImgStr = @"fingerPrintGray";
    }else{
        idImgStr = @"passwordKey";
    }
    self.idBtn = [ZZCustomView buttonInitWithView:self.bgView imageName:idImgStr];
    [self.idBtn addTarget:self action:@selector(idTouchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.idBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-10);
        make.top.equalTo(self.bgView).offset(13);
        make.width.height.equalTo(@28);
    }];
    UIView *line = [ZZCustomView viewInitWithView:self.bgView bgColor:[UIColor im_borderLineColor]];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(CGFloatScale(45));
        make.height.equalTo(@1);
    }];
    
    self.titleLbl = [ZZCustomView labelInitWithView:self.bgView text:@"支付详情" textColor:[UIColor im_textColor_six] font:GCSFontRegular(15)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(CGFloatScale(15));
        make.centerX.equalTo(self.bgView);
    }];
    
    
    
    [self getPasswordView];
    [self getPayInfoViewIsDAppsShow:isDApps];
    
    [self makeContentView];
}
- (void)makeContentView{
    
    if (self.isPasswordView) {
        self.infoView.hidden = YES;
        self.passwordView.hidden = NO;
        [self.closeBtn setImage:ImageNamed(@"nav_back") forState:UIControlStateNormal];
        self.titleLbl.text = @"密码";
        [self.nextStepBtn setTitle:@"确认" forState:UIControlStateNormal];
    }else{
        self.idBtn.hidden = NO;
        self.infoView.hidden = NO;
        self.passwordView.hidden = YES;
        [self.closeBtn setImage:ImageNamed(@"close") forState:UIControlStateNormal];
        self.titleLbl.text = @"支付详情";
        [self.nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
}
//支付详情 页
- (void)getPayInfoViewIsDAppsShow:(BOOL)isDApps{
    self.infoView = [[UIView alloc] init];
    [self.bgView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(45);
        make.bottom.equalTo(self.nextStepBtn.mas_top);
    }];
    UILabel *titleLbl = nil;
    if (isDApps) {
        UIImageView *icon = [ZZCustomView imageViewInitView:self.infoView imageName:@"defaultDappIcon"];
        icon.layer.cornerRadius = 8;
        icon.layer.masksToBounds = YES;
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.infoView);
            make.top.equalTo(self.infoView).offset(CGFloatScale(15));
            make.width.height.mas_equalTo(CGFloatScale(50));
        }];
        titleLbl = [ZZCustomView labelInitWithView:self.infoView text:self.inputModel.netUrl textColor:[UIColor im_lightGrayColor] font:GCSFontMedium(13)];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.infoView);
            make.top.equalTo(icon.mas_bottom).offset(12);
        }];
    }
    
    UILabel *amountLbl = [ZZCustomView labelInitWithView:self.infoView text:NSStringWithFormat(@"%@ %@",self.inputModel.amount,self.coinModel.tokenName) textColor:[UIColor blackColor] font:GCSFontRegular(30)];
    [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.infoView);
        if (titleLbl) {
            make.top.equalTo(titleLbl.mas_bottom).offset(50);
        }else{
            make.top.equalTo(self.infoView).offset(45);
        }
    }];
    
    NSArray *list = @[
        @{
            @"title":@"支付信息",
            @"content":NSStringWithFormat(@"%@转账",self.coinModel.currentWallet.type),
        },
        @{
            @"title":@"收款地址",
            @"content":self.inputModel.address,
        },
        @{
            @"title":@"付款地址",
            @"content":self.coinModel.currentWallet.address,
        },
        @{
            @"title":@"矿工费",
            @"content":NSStringWithFormat(@"%@ %@",self.inputModel.all_gasPrice,[[SettingManager sharedInstance] getChainCoinName]),
        },
    ];
    UIView *lastView = nil;
    for (int i = 0; i < list.count; i++) {
        UILabel *titleLbl = [ZZCustomView labelInitWithView:self.infoView text:list[i][@"title"] textColor:[UIColor im_grayColor] font:GCSFontRegular(13)];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView).offset(CGFloatScale(25));
            make.top.equalTo(lastView?lastView.mas_bottom: amountLbl.mas_bottom).offset(lastView?10:35);
            make.width.equalTo(@60);
        }];
        UILabel *contentLbl = [ZZCustomView labelInitWithView:self.infoView text:list[i][@"content"] textColor:[UIColor im_textColor_three] font:GCSFontRegular(13)];
        contentLbl.numberOfLines = 0;
        [contentLbl sizeToFit];
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLbl.mas_right).offset(CGFloatScale(20));
            make.right.equalTo(self.infoView).offset(-CGFloatScale(25));
            make.top.equalTo(titleLbl);
        }];
        
        if (i == list.count-1) {
            NSString *gasStr = NSStringWithFormat(@"= Gas（%@）* Gas Price（%.2f GWEI）",self.inputModel.gas,[self.inputModel.gas_price doubleValue]);
            UILabel *gasLbl = [ZZCustomView labelInitWithView:self.infoView text:gasStr textColor:[UIColor im_textColor_nine] font:GCSFontRegular(12)];
            [gasLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentLbl);
                make.right.equalTo(self.infoView).offset(-CGFloatScale(40));
                make.top.equalTo(contentLbl.mas_bottom);
                make.bottom.equalTo(self.infoView).offset(-CGFloatScale(30));
            }];
            if (isDApps) {//DApps浏览器转账
                UIImageView *arrow = [ZZCustomView imageViewInitView:self.infoView imageName:@"shevronSmall5"];
                [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.infoView).offset(-CGFloatScale(25));
                    make.centerY.equalTo(contentLbl.mas_bottom);
                    make.width.height.mas_equalTo(CGFloatScale(17));
                }];
                UIButton *gasBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [gasBtn addTarget:self action:@selector(gasBtnAction) forControlEvents:UIControlEventTouchUpInside];
                [self.infoView addSubview:gasBtn];
                [gasBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.equalTo(titleLbl);
                    make.bottom.equalTo(gasLbl.mas_bottom);
                    make.right.equalTo(arrow);
                }];
            }
        }
        
        if (i != list.count-1) {
            UIView *line = [ZZCustomView viewInitWithView:self.infoView bgColor:[UIColor im_borderLineColor]];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleLbl);
                make.top.equalTo(contentLbl.mas_bottom).offset(CGFloatScale(12));
                make.right.equalTo(self.infoView).offset(-CGFloatScale(8));
                make.height.equalTo(@1);
            }];
            lastView = line;
        }
        
    }
}
//密码 页
- (void)getPasswordView{
    self.passwordView = [[UIView alloc] init];
    [self.bgView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(40);
        make.bottom.equalTo(self.nextStepBtn.mas_top);
    }];
    
    UIView *tf_bgView = [[UIView alloc] init];
    tf_bgView.backgroundColor = COLORFORRGB(0xfafafb);
    tf_bgView.layer.cornerRadius = 8;
    tf_bgView.layer.borderColor = [UIColor mp_lineGrayColor].CGColor;
    tf_bgView.layer.borderWidth = 1;
    [self.passwordView addSubview:tf_bgView];
    
    [tf_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordView).offset(25);
        make.right.equalTo(self.passwordView).offset(-25);
        make.top.equalTo(self.passwordView).offset(25);
        make.height.mas_equalTo(CGFloatScale(50));
    }];
    
    self.pw_TF = [ZZCustomView textFieldInitFrame:CGRectZero view:tf_bgView placeholder:@"" delegate:nil font:GCSFontRegular(14) textColor:[UIColor blackColor]];
    self.pw_TF.secureTextEntry = YES;
    NSString *str = @"钱包密码";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor im_textColor_six]} range:NSMakeRange(0, str.length)];
    self.pw_TF.attributedPlaceholder = att;
    [self.pw_TF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tf_bgView).offset(20);
        make.right.equalTo(tf_bgView).offset(-35);
        make.top.bottom.equalTo(tf_bgView);
    }];
    
    UIButton *hidePWBtn = [ZZCustomView buttonInitWithView:tf_bgView imageName:@"hideAssets"];
    [hidePWBtn addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [hidePWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tf_bgView).offset(-20);
        make.centerY.equalTo(tf_bgView);
        make.width.height.mas_equalTo(CGFloatScale(20));
    }];
    
    UIButton *forgetPwBtn = [ZZCustomView buttonInitWithView:self.passwordView title:@"忘记密码?" titleColor:[UIColor im_btnSelectColor] titleFont:GCSFontRegular(13)];
    [forgetPwBtn addTarget:self action:@selector(forgetPwBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [forgetPwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-20);
        make.top.equalTo(tf_bgView.mas_bottom);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
}

- (void)nextStepBtnAction{
    if (!self.isPasswordView) {
        //支付详情下一步
        if (!self.isOpenID) {
            self.isPasswordView = YES;
            [self makeContentView];
        }else{
            //开启免密支付 直接验证支付
            if (self.delegate && [self.delegate respondsToSelector:@selector(secretFreePaymentAction)]) {
                [self.delegate secretFreePaymentAction];
            }
        }
    }else{
        //密码支付 确认
        if (self.pw_TF.text.length <= 0) {
            return [UITools showToast:@"请输入密码"];
        }
        if (![self.pw_TF.text isEqualToString:self.coinModel.currentWallet.walletPassword]) {
            return [UITools showToast:@"输入密码错误"];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(transferPayAction)]) {
            [self.delegate transferPayAction];
            [self removeFromSuperview];
        }
    }

}
- (void)forgetPwBtnAction{
    
}
- (void)idTouchBtnAction{
    if (self.isOpenID) {
        //如果开启了免密支付 跳转密码页
        self.isPasswordView = YES;
        [self makeContentView];
        self.idBtn.hidden = YES;
    }else{
        //免密支付
        SecretFreeViewController *vc = [[SecretFreeViewController alloc] init];
        vc.isPresentShow = YES;
        vc.wallet = self.coinModel.currentWallet;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.viewController presentViewController:vc animated:YES completion:nil];
    }
    
}

- (void)gasBtnAction{
    //矿工费详情
    MinersfeeSettingVC *vc = [[MinersfeeSettingVC alloc] init];
    vc.isDAppsPush = YES;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.viewController presentViewController:vc animated:YES completion:nil];
}

- (void)closeBtnAction{
    if (!self.isPasswordView) {
        [self removeFromSuperview];
    }else{
        self.isPasswordView = NO;
        [self makeContentView];
    }
}
- (void)hideButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:ImageNamed(@"showAssets") forState:UIControlStateNormal];
        self.pw_TF.secureTextEntry = NO;

    }else{
        [sender setImage:ImageNamed(@"hideAssets") forState:UIControlStateNormal];
        self.pw_TF.secureTextEntry = YES;

    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
