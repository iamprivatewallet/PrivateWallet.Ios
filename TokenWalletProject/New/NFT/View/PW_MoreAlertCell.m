//
//  PW_MoreAlertCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MoreAlertCell.h"

@interface PW_MoreAlertCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_MoreAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_MoreAlertModel *)model {
    _model = model;
    self.iconIv.image = [UIImage imageNamed:model.iconName];
    self.titleLb.text = model.title;
}
- (void)makeViews {
    [self.contentView addSubview:self.iconIv];
    [self.contentView addSubview:self.titleLb];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14);
        make.centerY.offset(0);
        make.width.height.mas_equalTo(40);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(5);
        make.centerY.offset(0);
    }];
}
#pragma mark - lazy
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
    }
    return _iconIv;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:16 textColor:[UIColor g_textColor]];
    }
    return _titleLb;
}

@end
