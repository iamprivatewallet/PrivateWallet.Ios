//
//  PW_FollowSeriesNFTItemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_FollowSeriesNFTItemCell.h"

@interface PW_FollowSeriesNFTItemCell ()

@property (nonatomic, strong) UIImageView *logoIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation PW_FollowSeriesNFTItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)followAction {
    self.followBtn.selected = !self.followBtn.isSelected;
    if (self.followBlock) {
        self.followBlock(self.followBtn.selected);
    }
}
- (void)makeViews {
    [self.contentView addSubview:self.logoIv];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.followBtn];
    [self.contentView addSubview:self.lineView];
    [self.logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(4);
        make.width.height.mas_equalTo(35);
        make.centerY.offset(0);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoIv.mas_right).offset(14);
        make.centerY.offset(0);
    }];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark - lazy
- (UIImageView *)logoIv {
    if (!_logoIv) {
        _logoIv = [[UIImageView alloc] init];
    }
    return _logoIv;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:14 textColor:[UIColor g_textColor]];
    }
    return _nameLb;
}
- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [PW_ViewTool buttonImageName:@"icon_collect" selectedImage:@"icon_collect_selected" target:self action:@selector(followAction)];
    }
    return _followBtn;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor g_lineColor];
    }
    return _lineView;
}

@end
