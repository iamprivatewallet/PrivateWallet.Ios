//
//  PW_NFTDetailOfferCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/5.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTDetailOfferCell.h"

@interface PW_NFTDetailOfferCell ()

@property (nonatomic, strong) UIImageView *coinTypeIv;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UILabel *buyerLb;

@end

@implementation PW_NFTDetailOfferCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self.contentView addSubview:self.coinTypeIv];
    [self.contentView addSubview:self.priceLb];
    [self.contentView addSubview:self.buyerLb];
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
        make.right.offset(-30);
        make.centerY.offset(0);
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
        _buyerLb = [PW_ViewTool labelText:@"--" fontSize:15 textColor:[UIColor g_textColor]];
    }
    return _buyerLb;
}

@end
