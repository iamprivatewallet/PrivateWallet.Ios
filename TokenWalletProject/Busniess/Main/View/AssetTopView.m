//
//  AssetTopView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/24.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AssetTopView.h"
@interface AssetTopView()
@property (nonatomic, strong) UILabel *amountLbl;
@property (nonatomic, strong) UILabel *rmbAmountLbl;
@property (nonatomic, strong) UILabel *coinLbl;
@property (nonatomic, strong) UIView *lineChartView;


@end
@implementation AssetTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}

- (void)setViewWithModel:(WalletCoinModel *)model{
    self.amountLbl.text = NSStringWithFormat(@"%@",[model.usableAmount stringDownDecimal:4]);
    self.rmbAmountLbl.text = NSStringWithFormat(@"$%@",[model.usableAmount stringDownMultiplyingBy:model.usdtPrice decimal:4]);
    self.coinLbl.text = model.tokenName;
}
- (void)makeViews{
    self.amountLbl = [ZZCustomView labelInitWithView:self text:@"0.0000" textColor:[UIColor blackColor] font:GCSFontMedium(25)];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(10);
    }];
    self.rmbAmountLbl = [ZZCustomView labelInitWithView:self text:@"≈$0.00" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(11)];
    [self.rmbAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.amountLbl.mas_bottom);
    }];
    
    self.coinLbl = [ZZCustomView labelInitWithView:self text:@"--" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(10)];
    [self.coinLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-25);
        make.bottom.equalTo(self.amountLbl).offset(-3);
    }];
    UIView *blueView = [ZZCustomView viewInitWithView:self bgColor:COLORFORRGB(0x188fea)];
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coinLbl);
        make.right.equalTo(self.coinLbl.mas_left).offset(-5);
        make.width.height.mas_equalTo(5);
    }];
    
    UILabel *cnyLbl = [ZZCustomView labelInitWithView:self text:@"CNY" textColor:[UIColor im_textColor_nine] font:self.coinLbl.font];
    [cnyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinLbl);
        make.top.equalTo(self.coinLbl.mas_bottom);
    }];
    UIView *cnyView = [ZZCustomView viewInitWithView:self bgColor:COLORFORRGB(0x8e62f1)];
    [cnyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cnyLbl);
        make.right.equalTo(blueView);
        make.width.height.equalTo(blueView);
    }];
    
    UIView *chartView = [ZZCustomView viewInitWithView:self bgColor:[UIColor whiteColor]];
    [chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.rmbAmountLbl.mas_bottom).offset(20);
    }];
    
}

@end
