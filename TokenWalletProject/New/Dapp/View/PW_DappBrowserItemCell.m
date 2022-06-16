//
//  PW_DappBrowserItemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappBrowserItemCell.h"

@interface PW_DappBrowserItemCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_DappBrowserItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.iconIv = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIv];
        [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.centerX.offset(0);
            make.height.equalTo(self.iconIv.mas_width);
        }];
        self.titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_grayTextColor]];
        self.titleLb.numberOfLines = 1;
        self.titleLb.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-5);
            make.left.right.offset(0);
        }];
    }
    return self;
}
- (void)setModel:(PW_DappModel *)model {
    _model = model;
    if ([model.iconUrl isURL]) {
        [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
        [self.iconIv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.centerX.offset(0);
            make.height.equalTo(self.iconIv.mas_width);
        }];
    }else{
        self.iconIv.image = [UIImage imageNamed:model.iconUrl];
        [self.iconIv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(-15);
            make.centerX.offset(0);
        }];
    }
    self.titleLb.text = model.appName;
}

@end
