//
//  PW_MoreCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MoreCell.h"

@interface PW_MoreCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation PW_MoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_MoreModel *)model {
    _model = model;
    self.iconIv.image = [UIImage imageNamed:model.iconName];
    self.titleLb.text = model.title;
}
- (void)makeViews {
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    self.titleLb = [PW_ViewTool labelText:@"--" fontSize:18 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:self.titleLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [self.contentView addSubview:arrowIv];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor g_lineColor];
    [self.contentView addSubview:self.lineView];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(26);
        make.centerY.offset(0);
        make.width.height.mas_equalTo(66);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(8);
        make.centerY.offset(0);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-36);
        make.centerY.offset(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.bottom.offset(0);
        make.height.mas_equalTo(1);
    }];
}

@end
