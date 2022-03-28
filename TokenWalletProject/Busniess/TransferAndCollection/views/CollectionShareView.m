//
//  CollectionShareView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/12.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "CollectionShareView.h"
#import "SGQRCode.h"

@interface CollectionShareView()
@property (nonatomic, strong) UIView *shadowBgView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *codeTitleLbl;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UIButton *addressBtn;

@property (nonatomic, strong) Wallet *currentWallet;
@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) void(^shareAppButtonBlock)(void);

@end
@implementation CollectionShareView

+(void)showShareViewWithInfo:(id)info amount:(nonnull NSString *)amount shareAction:(nonnull void (^)(void))action{
    CollectionShareView *backView = nil;
    
    [SVProgressHUD dismiss];
    for (CollectionShareView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            backView = subView;
        }
    }
    if (!backView) {
        backView = [[CollectionShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.amount = amount;
        backView.shareAppButtonBlock = action;
        [backView makeViewsWithModel:info];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    
    backView.bgView.transform = CGAffineTransformMakeTranslation(0, 600);
    backView.bottomView.transform = CGAffineTransformMakeTranslation(0, 800);

    [UIView animateWithDuration:0.3 animations:^{
        backView.bgView.transform = CGAffineTransformMakeTranslation(0,0);
        backView.bottomView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
}

- (void)makeViewsWithModel:(id)model{
    if (model && [model isKindOfClass:[Wallet class]]) {
        Wallet *wallet = model;
        self.currentWallet = wallet;
        
        self.shadowBgView = [[UIView alloc] init];
        self.shadowBgView.backgroundColor = COLORA(0, 0, 0,0.5);
        [self addSubview:self.shadowBgView];
        
        [self.shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.bgView = [ZZCustomView viewInitWithView:self bgColor:[UIColor im_btnSelectColor]];
        self.bgView.layer.cornerRadius = 14;
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(CGFloatScale(20));
            make.right.equalTo(self).offset(-CGFloatScale(20));
            make.top.equalTo(self).offset(kNavBarAndStatusBarHeight+CGFloatScale(25));
        }];
        
        UIImageView *iconImg = [ZZCustomView imageViewInitView:self.bgView imageName:@"logo"];
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(35);
            make.left.equalTo(self.bgView).offset(CGFloatScale(20));
            make.bottom.equalTo(self.bgView).offset(-CGFloatScale(20));
        }];
        
        UILabel *detailLbl = [ZZCustomView labelInitWithView:self.bgView text:WalletWebSiteUrl textColor:[UIColor colorWithWhite:1 alpha:0.8] font:GCSFontRegular(12)];
        [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView).offset(-CGFloatScale(20));
            make.left.equalTo(iconImg.mas_right).offset(CGFloatScale(15));
        }];
        
        UILabel *titleLbl = [ZZCustomView labelInitWithView:self.bgView text:APPName textColor:[UIColor whiteColor] font:GCSFontMedium(15)];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(detailLbl.mas_top);
            make.left.equalTo(detailLbl);
        }];
        NSString *json = [CATCommon JSONString:WalletWebSiteUrl];
        UIImage *image = [SGQRCodeObtain generateQRCodeWithData:json size:50];
        UIImageView *codeImg = [ZZCustomView imageViewInitView:self.bgView image:image];
        [codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(50);
            make.right.equalTo(self.bgView).offset(-CGFloatScale(20));
            make.bottom.equalTo(self.bgView).offset(-CGFloatScale(15));
        }];
        [self makeWhiteViewsWithBgView:self.bgView];
        [self makeBottomViews];
        
    }

}
- (void)makeWhiteViewsWithBgView:(UIView *)bgView{
    UIView *whiteBg = [ZZCustomView viewInitWithView:bgView bgColor:[UIColor whiteColor]];
    whiteBg.layer.cornerRadius = 15;
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(-CGFloatScale(80));
    }];
    UILabel *titleLbl = [ZZCustomView labelInitWithView:whiteBg text:NSStringWithFormat(@"%@ 收款",self.currentWallet.type) textColor:[UIColor blackColor] font:GCSFontRegular(15) textAlignment:NSTextAlignmentCenter];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteBg).offset(CGFloatScale(40));
        make.centerX.equalTo(whiteBg);
    }];
    self.codeTitleLbl = [ZZCustomView labelInitWithView:whiteBg text:NSStringWithFormat(@"扫二维码，转入 %@ %@",self.amount!=nil?self.amount:@"",self.currentWallet.type) textColor:[UIColor im_lightGrayColor] font:GCSFontRegular(14) textAlignment:NSTextAlignmentCenter];
    [self.codeTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl.mas_bottom).offset(CGFloatScale(5));
        make.centerX.equalTo(whiteBg);
    }];
    self.codeImageView = [[UIImageView alloc] init];
    if ([self.amount doubleValue]>0) {
//        NSDictionary *dic = @{@"address":self.currentWallet.address,@"amount":self.amount};
        NSString *str = NSStringWithFormat(@"ethereum:%@?value=%@",self.currentWallet.address,self.amount);
        NSString *json = [CATCommon JSONString:str];
        self.codeImageView.image = [SGQRCodeObtain generateQRCodeWithData:json size:180];
    }else{
        self.codeImageView.image = [SGQRCodeObtain generateQRCodeWithData:self.currentWallet.address size:180];
    }
    [whiteBg addSubview:self.codeImageView];
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTitleLbl.mas_bottom).offset(CGFloatScale(40));
        make.width.height.mas_equalTo(180);
        make.centerX.equalTo(whiteBg);
    }];
    UIImageView *topLeftImg = [ZZCustomView imageViewInitView:whiteBg imageName:@"cornerLeftTop"];
    [topLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(26);
        make.centerX.equalTo(self.codeImageView.mas_left);
        make.centerY.equalTo(self.codeImageView.mas_top);
    }];
    
    UIImageView *topRightImg = [ZZCustomView imageViewInitView:whiteBg imageName:@"cornerRightTop"];
    [topRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(topLeftImg);
        make.centerX.equalTo(self.codeImageView.mas_right);
        make.centerY.equalTo(self.codeImageView.mas_top);
    }];
    
    UIImageView *bottomLeftImg = [ZZCustomView imageViewInitView:whiteBg imageName:@"cornerLeftBottom"];
    [bottomLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(topLeftImg);
        make.centerX.equalTo(self.codeImageView.mas_left);
        make.centerY.equalTo(self.codeImageView.mas_bottom);
    }];
    UIImageView *bottomRightImg = [ZZCustomView imageViewInitView:whiteBg imageName:@"cornerRightBottom"];
    [bottomRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(topLeftImg);
        make.centerX.equalTo(self.codeImageView.mas_right);
        make.centerY.equalTo(self.codeImageView.mas_bottom);
    }];
    
    UILabel *addrLbl = [ZZCustomView labelInitWithView:whiteBg text:@"钱包地址" textColor:[UIColor im_lightGrayColor] font:GCSFontRegular(13)];
    [addrLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeImageView.mas_bottom).offset(CGFloatScale(30));
        make.centerX.equalTo(whiteBg);
    }];
    
    self.addressBtn = [ZZCustomView im_buttonInitWithView:whiteBg title:self.currentWallet.address titleFont:GCSFontRegular(15) titleColor:[UIColor im_textColor_three] isHighlighted:YES];
    self.addressBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addrLbl.mas_bottom).offset(10);
        make.left.equalTo(whiteBg).offset(CGFloatScale(30));
        make.right.equalTo(whiteBg).offset(-CGFloatScale(30));
        make.bottom.equalTo(whiteBg).offset(-CGFloatScale(40));
    }];
    
}

- (void)makeBottomViews{
    self.bottomView = [ZZCustomView viewInitWithView:self bgColor:COLORFORRGB(0xfefefd)];
    self.bottomView.layer.cornerRadius = 4;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_offset(kBottomSafeHeight+CGFloatScale(80));
        make.bottom.equalTo(self).offset(10);
    }];
    
    UIButton *cancelBtn = [ZZCustomView buttonInitWithView:self.bottomView title:@"取消" titleColor:[UIColor im_blueColor] titleFont:GCSFontRegular(16) bgColor:COLORFORRGB(0xe6f4fc)];
    cancelBtn.layer.cornerRadius = 8;
    [cancelBtn addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 0;
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(10);
        make.top.equalTo(self.bottomView).offset(10);
        make.height.mas_offset(CGFloatScale(50));
        make.right.equalTo(self.bottomView.mas_centerX).offset(-6);
    }];
    
    UIButton *shareBtn = [ZZCustomView buttonInitWithView:self.bottomView title:@"分享" titleColor:[UIColor whiteColor] titleFont:GCSFontRegular(16) bgColor:[UIColor im_btnSelectColor]];
    shareBtn.layer.cornerRadius = 8;
    [shareBtn addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.tag = 1;
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(-10);
        make.top.equalTo(self.bottomView).offset(10);
        make.height.mas_offset(CGFloatScale(50));
        make.left.equalTo(self.bottomView.mas_centerX).offset(6);
    }];
}

- (void)bottomButtonAction:(UIButton *)sender{
    if (sender.tag == 0) {
        [self dismissView];
    }else{
        self.shareAppButtonBlock();
    }
}

- (void)dismissView{
    self.bottomView.transform = self.bgView.transform = CGAffineTransformMakeTranslation(0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.transform = self.bgView.transform = CGAffineTransformMakeTranslation(0,800);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

@end
