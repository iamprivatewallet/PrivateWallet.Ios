//
//  PW_OfferNFTAlertSectionHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/6.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_OfferNFTAlertSectionHeaderView.h"

@interface PW_OfferNFTAlertSectionHeaderView ()

@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UILabel *buyerLb;

@end

@implementation PW_OfferNFTAlertSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor g_bgColor];
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self.contentView addSubview:self.priceLb];
    [self.contentView addSubview:self.buyerLb];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.centerY.offset(0);
    }];
    [self.buyerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.centerY.offset(0);
    }];
}
#pragma mark - lazy
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_price") fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _priceLb;
}
- (UILabel *)buyerLb {
    if (!_buyerLb) {
        _buyerLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_buyer") fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _buyerLb;
}

@end
