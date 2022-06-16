//
//  PW_DappChainItemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappChainItemCell.h"

@interface PW_DappChainItemCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_DappChainItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor g_bgColor];
        [self.contentView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
        [self.contentView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
        self.iconIv = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIv];
        [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.offset(0);
            make.width.height.offset(45);
        }];
        self.titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:14 textColor:[UIColor g_grayTextColor]];
        self.titleLb.numberOfLines = 2;
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIv.mas_right).offset(15);
            make.centerY.offset(0);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
    }
    return self;
}
- (void)setModel:(PW_DappModel *)model {
    _model = model;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    self.titleLb.text = model.appName;
}

@end
