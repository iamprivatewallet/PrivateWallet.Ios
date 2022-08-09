//
//  PW_SearchNFTCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchNFTCell.h"

@interface PW_SearchNFTCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIImageView *chainTypeIv;
@property (nonatomic, strong) UILabel *countLb;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation PW_SearchNFTCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setCollectionModel:(PW_NFTCollectionModel *)collectionModel {
    _collectionModel = collectionModel;
    self.countLb.hidden = NO;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:collectionModel.imageUrl] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    self.nameLb.text = collectionModel.name;
    self.chainTypeIv.image = [UIImage imageNamed:PW_StrFormat(@"icon_small_chain_%@",collectionModel.chainId)];
}
- (void)setAccountModel:(PW_NFTAccountModel *)accountModel {
    _accountModel = accountModel;
    self.countLb.hidden = YES;
}
- (void)setItemModel:(PW_NFTItemModel *)itemModel {
    _itemModel = itemModel;
    self.countLb.hidden = YES;
}
- (void)makeViews {
    [self.contentView addSubview:self.iconIv];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.chainTypeIv];
    [self.contentView addSubview:self.countLb];
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
    [self.chainTypeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.mas_right).offset(4);
        make.centerY.offset(0);
        make.width.height.mas_equalTo(18);
        make.right.mas_lessThanOrEqualTo(self.countLb.mas_left).offset(-10);
    }];
    [self.countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-50);
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
- (UIImageView *)chainTypeIv {
    if (!_chainTypeIv) {
        _chainTypeIv = [[UIImageView alloc] init];
        [_chainTypeIv setRequiredHorizontal];
    }
    return _chainTypeIv;
}
- (UILabel *)countLb {
    if (!_countLb) {
        _countLb = [PW_ViewTool labelText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
        [_countLb setRequiredHorizontal];
    }
    return _countLb;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor g_lineColor];
    }
    return _lineView;
}

@end
