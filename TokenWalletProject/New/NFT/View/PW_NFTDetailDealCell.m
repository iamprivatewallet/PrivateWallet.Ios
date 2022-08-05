//
//  PW_NFTDetailDealCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/5.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTDetailDealCell.h"

@interface PW_NFTDetailDealCell ()

@property (nonatomic, strong) UILabel *typeLb;
@property (nonatomic, strong) UIImageView *coinTypeIv;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UILabel *buyerLb;
@property (nonatomic, strong) UILabel *sellerLb;
@property (nonatomic, strong) UILabel *timeLb;

@end

@implementation PW_NFTDetailDealCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self.contentView addSubview:self.typeLb];
    [self.contentView addSubview:self.coinTypeIv];
    [self.contentView addSubview:self.priceLb];
    [self.contentView addSubview:self.buyerLb];
    [self.contentView addSubview:self.sellerLb];
    [self.contentView addSubview:self.timeLb];
    [self.typeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.centerY.offset(0);
    }];
    [self.coinTypeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(78);
        make.centerY.offset(0);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinTypeIv.mas_right).offset(3);
        make.centerY.offset(0);
    }];
    [self.buyerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(-30);
        make.bottom.offset(0);
    }];
    [self.sellerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(45);
        make.bottom.offset(0);
    }];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.bottom.offset(0);
    }];
}
#pragma mark - lazy
- (UILabel *)typeLb {
    if (!_typeLb) {
        _typeLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _typeLb;
}
- (UIImageView *)coinTypeIv {
    if (!_coinTypeIv) {
        _coinTypeIv = [[UIImageView alloc] init];
    }
    return _coinTypeIv;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [PW_ViewTool labelBoldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _priceLb;
}
- (UILabel *)buyerLb {
    if (!_buyerLb) {
        _buyerLb = [PW_ViewTool labelText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _buyerLb;
}
- (UILabel *)sellerLb {
    if (!_sellerLb) {
        _sellerLb = [PW_ViewTool labelText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _sellerLb;
}
- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [PW_ViewTool labelText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _timeLb;
}

@end
