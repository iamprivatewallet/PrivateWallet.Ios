//
//  MainTopWalletView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/29.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MainTopWalletView.h"
#import "CollectionViewController.h"
#import "ImportManageVC.h"
#import "ManageViewController.h"

@interface MainTopWalletView()
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UIImageView *codeImg;

@property (nonatomic, strong) UILabel *amountLbl;
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UIButton *amountBtn;

@property (nonatomic, strong) WalletCoinModel *coinModel;

@end
@implementation MainTopWalletView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 14;
        self.backgroundColor = COLOR(26, 144, 193);
        [self makeViews];
    }
    return self;
}

- (void)setTopViewWithData:(id)data{
    if (data && [data isKindOfClass:[WalletCoinModel class]]) {
        WalletCoinModel *model = data;
        self.coinModel = model;
        self.titleLbl.text = model.currentWallet.walletName;
        NSString *chainType = [[SettingManager sharedInstance] getChainType];
        [self.bgImg sd_setImageWithURL:[NSURL URLWithString:AppWalletChainBgURL(chainType)]];
        BOOL isHidden = [GetUserDefaultsForKey(@"isHiddenWalletAmount") boolValue];
        if (isHidden) {
            [self makeAddressLblWithStr:NSStringWithFormat(@"%@****",[self.coinModel.currentWallet.address contractPrefix])];
            [self makeAmountAttrWithStr:@"$****"];
            self.amountBtn.selected = YES;
        }else{
            [self makeAddressLblWithStr:self.coinModel.currentWallet.address];
            NSString *totalBalance = [@(self.coinModel.currentWallet.totalBalance).stringValue stringDownDecimal:8];
            [self makeAmountAttrWithStr:NSStringWithFormat(@"$%@",totalBalance)];
            self.amountBtn.selected = NO;
        }
    }
}

- (void)makeViews{
    self.bgImg = [[UIImageView alloc] init];
    [self addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.titleLbl = [ZZCustomView labelInitWithView:self text:@"ETH" textColor:[UIColor whiteColor] font:GCSFontMedium(18)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CGFloatScale(20));
        make.top.equalTo(self).offset(15);
    }];
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:addressBtn];
    [addressBtn addTarget:self action:@selector(addressBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.top.equalTo(self.titleLbl.mas_bottom);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(30);
    }];
    
    self.addressLbl = [ZZCustomView labelInitWithView:addressBtn text:@"--" textColor:[UIColor colorWithWhite:1 alpha:0.8] font:GCSFontRegular(13)];
    self.addressLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressBtn);
        make.top.equalTo(addressBtn).offset(CGFloatScale(3));
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(25);
    }];
    
    UIButton *spotBtn = [ZZCustomView buttonInitWithView:self imageName:@"detail"];
    [spotBtn addTarget:self action:@selector(spotBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [spotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(20);
        make.width.height.mas_equalTo(17);
    }];
    
    self.amountBtn = [[UIButton alloc] init];
    [self addSubview:self.amountBtn];
    [self.amountBtn addTarget:self action:@selector(amountBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.amountLbl = [ZZCustomView labelInitWithView:self.amountBtn text:@"0" textColor:[UIColor whiteColor] font:GCSFontRegular(30) textAlignment:NSTextAlignmentRight];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-17);
        make.bottom.equalTo(self).offset(-12);
        make.left.greaterThanOrEqualTo(self).offset(20);
    }];
    [self.amountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.amountLbl);
    }];
}

- (void)spotBtnAction{
    //跳转管理
    if ([self.coinModel.currentWallet.isImport boolValue]) {
        ImportManageVC *vc = [[ImportManageVC alloc] init];
        vc.wallet = self.coinModel.currentWallet;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else{
        ManageViewController *vc = [[ManageViewController alloc] init];
        vc.wallet = self.coinModel.currentWallet;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addressBtnAction{
    //收款页
    CollectionViewController *vc = [[CollectionViewController alloc] init];
    vc.coinModel = self.coinModel;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
- (void)amountBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self makeAddressLblWithStr:NSStringWithFormat(@"%@****",[self.coinModel.currentWallet.address contractPrefix])];
        [self makeAmountAttrWithStr:@"$****"];
        SetUserDefaultsForKey(@"1", @"isHiddenWalletAmount");
    }else{
        [self makeAddressLblWithStr:self.coinModel.currentWallet.address];
        NSString *totalBalance = [@(self.coinModel.currentWallet.totalBalance).stringValue stringDownDecimal:8];
        [self makeAmountAttrWithStr:NSStringWithFormat(@"$%@",totalBalance)];
        SetUserDefaultsForKey(@"0", @"isHiddenWalletAmount");
    }
    [UserDefaults synchronize];

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAmountTextWithHidden)]) {
        [self.delegate clickAmountTextWithHidden];
    }
}

- (void)makeAddressLblWithStr:(NSString *)str{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [ImageNamed(@"qRcode") imageWithColor:[UIColor colorWithWhite:1 alpha:0.9]];
    attch.bounds = CGRectMake(0, -2, 13, 13);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string]; //在文字后面添加图片
    self.addressLbl.attributedText = attri;
}

- (void)makeAmountAttrWithStr:(NSString *)str{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSFontAttributeName value:GCSFontRegular(18) range:NSMakeRange(0, 1)];
    self.amountLbl.attributedText = attributedString;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
