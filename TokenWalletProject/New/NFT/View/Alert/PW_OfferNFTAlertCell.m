//
//  PW_OfferNFTAlertCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_OfferNFTAlertCell.h"

@interface PW_OfferNFTAlertCell ()

@property (nonatomic, strong) UIImageView *coinTypeIv;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UILabel *buyerLb;
@property (nonatomic, strong) UIButton *sellBtn;

@end

@implementation PW_OfferNFTAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)sellAction {
    if (self.sellBlock) {
        self.sellBlock();
    }
}
- (void)makeViews {
    [self.contentView addSubview:self.coinTypeIv];
    [self.contentView addSubview:self.priceLb];
    [self.contentView addSubview:self.buyerLb];
    [self.contentView addSubview:self.sellBtn];
    [self.coinTypeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.width.height.mas_equalTo(12);
        make.centerY.offset(0);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinTypeIv.mas_right).offset(3);
        make.centerY.offset(0);
    }];
    [self.buyerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sellBtn.mas_left).offset(-6);
        make.centerY.offset(0);
    }];
    [self.sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-24);
        make.centerY.offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
}
#pragma mark - lazy
- (UIImageView *)coinTypeIv {
    if (!_coinTypeIv) {
        _coinTypeIv = [[UIImageView alloc] init];
    }
    return _coinTypeIv;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [PW_ViewTool labelBoldText:@"--" fontSize:15 textColor:[UIColor g_textColor]];
    }
    return _priceLb;
}
- (UILabel *)buyerLb {
    if (!_buyerLb) {
        _buyerLb = [PW_ViewTool labelBoldText:@"--" fontSize:15 textColor:[UIColor g_hex:@"#62A4D7"]];
    }
    return _buyerLb;
}
- (UIButton *)sellBtn {
    if (!_sellBtn) {
        _sellBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_sell") fontSize:11 titleColor:[UIColor g_primaryColor] cornerRadius:5 backgroundColor:nil target:self action:@selector(sellAction)];
        UIImage *image = [UIImage pw_imageGradientSize:CGSizeMake(30, 20) gradientColors:@[[[UIColor g_primaryNFTColor] alpha:0.2],[[UIColor g_primaryColor] alpha:0.2]] gradientType:PW_GradientTopToBottom];
        [_sellBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    return _sellBtn;
}

@end
