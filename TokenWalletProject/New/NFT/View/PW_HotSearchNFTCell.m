//
//  PW_HotSearchNFTCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/9.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_HotSearchNFTCell.h"

@interface PW_HotSearchNFTCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation PW_HotSearchNFTCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_NFTTokenModel *)model {
    _model = model;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    self.nameLb.text = model.search;
}
- (void)makeViews {
    [self.contentView addSubview:self.iconIv];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.lineView];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.width.height.mas_equalTo(35);
        make.centerY.offset(0);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(14);
        make.centerY.offset(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(32);
        make.right.offset(-32);
        make.bottom.offset(0);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark - lazy
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
        [_iconIv setCornerRadius:17.5];
    }
    return _iconIv;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:14 textColor:[UIColor g_textColor]];
    }
    return _nameLb;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor g_lineColor];
    }
    return _lineView;
}

@end
