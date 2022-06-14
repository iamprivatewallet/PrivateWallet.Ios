//
//  PW_WalletSetCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletSetCell.h"

@interface PW_WalletSetCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *descLb;

@end

@implementation PW_WalletSetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_WalletSetModel *)model {
    _model = model;
    self.iconIv.image = [UIImage imageNamed:model.iconName];
    self.titleLb.text = model.title;
    self.descLb.text = model.desc;
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.titleLb];
    [self.bodyView addSubview:self.descLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [self.bodyView addSubview:arrowIv];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [self.bodyView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1);
    }];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bodyView.mas_left).offset(30);
        make.centerY.offset(0);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(66);
        make.bottom.equalTo(self.bodyView.mas_centerY).offset(-1);
        make.right.offset(-35);
    }];
    [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.equalTo(self.bodyView.mas_centerY).offset(1);
        make.right.offset(-30);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if(!_bodyView) {
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
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelMediumText:@"--" fontSize:15 textColor:[UIColor g_boldTextColor]];
    }
    return _titleLb;
}
- (UILabel *)descLb {
    if (!_descLb) {
        _descLb = [PW_ViewTool labelText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    }
    return _descLb;
}

@end
