//
//  PW_DappMoreItemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappMoreItemCell.h"

@interface PW_DappMoreItemCell ()

@property (nonatomic, strong) UIView *iconBgView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_DappMoreItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.iconBgView = [[UIView alloc] init];
        self.iconBgView.backgroundColor = [UIColor g_bgColor];
        [self.iconBgView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
        [self.iconBgView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
        [self.contentView addSubview:self.iconBgView];
        [self.iconBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.offset(0);
            make.width.height.offset(50);
        }];
        self.iconIv = [[UIImageView alloc] init];
        [self.iconBgView addSubview:self.iconIv];
        [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
        }];
        self.titleLb = [PW_ViewTool labelMediumText:@"--" fontSize:12 textColor:[UIColor g_darkTextColor]];
        self.titleLb.numberOfLines = 2;
        self.titleLb.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconBgView.mas_bottom).offset(5);
            make.left.right.offset(0);
        }];
    }
    return self;
}
- (void)setModel:(PW_DappMoreModel *)model {
    _model = model;
    self.iconIv.image = [UIImage imageNamed:model.iconName];
    self.titleLb.text = model.title;
}

@end
