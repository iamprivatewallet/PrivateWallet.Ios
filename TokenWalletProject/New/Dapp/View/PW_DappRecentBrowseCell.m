//
//  PW_DappRecentBrowseCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappRecentBrowseCell.h"

@interface PW_DappRecentBrowseCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *descLb;

@end

@implementation PW_DappRecentBrowseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_DappModel *)model {
    _model = model;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    self.titleLb.text = model.appName;
    self.descLb.text = model.appUrl;
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.titleLb];
    [self.bodyView addSubview:self.descLb];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(6);
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-6);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.centerY.offset(0);
        make.width.height.offset(40);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(15);
        make.top.equalTo(self.iconIv);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
    [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(15);
        make.bottom.equalTo(self.iconIv);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if(!_bodyView) {
        _bodyView = [[UIView alloc] init];
        [_bodyView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
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
        _titleLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    }
    return _titleLb;
}
- (UILabel *)descLb {
    if (!_descLb) {
        _descLb = [PW_ViewTool labelBoldText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    }
    return _descLb;
}

@end
