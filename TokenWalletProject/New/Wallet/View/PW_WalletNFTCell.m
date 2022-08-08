//
//  PW_WalletNFTCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/27.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletNFTCell.h"

@interface PW_WalletNFTCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *countLb;
@property (nonatomic, strong) UIImageView *arrowIv;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation PW_WalletNFTCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_NFTCollectionModel *)model {
    _model = model;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"icon_token_default"]];
    self.nameLb.text = model.slug;
    self.countLb.text = @(model.numOwners).stringValue;
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.countLb];
    [self.bodyView addSubview:self.arrowIv];
    [self.bodyView addSubview:self.lineView];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.height.mas_equalTo(45);
        make.centerY.offset(0);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(16);
        make.centerY.offset(0);
    }];
    [self.countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowIv.mas_left).offset(-8);
        make.centerY.offset(0);
    }];
    [self.arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - lazy
- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
    }
    return _bodyView;
}
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
    }
    return _iconIv;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:14 textColor:[UIColor g_textColor]];
        _nameLb.numberOfLines = 2;
    }
    return _nameLb;
}
- (UILabel *)countLb {
    if (!_countLb) {
        _countLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:14 textColor:[UIColor g_grayTextColor]];
    }
    return _countLb;
}
- (UIImageView *)arrowIv {
    if (!_arrowIv) {
        _arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_black"]];
    }
    return _arrowIv;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor g_lineColor];
    }
    return _lineView;
}

@end
