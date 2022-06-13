//
//  PW_DappChainBrowserItemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappChainBrowserItemCell.h"

@interface PW_DappChainBrowserItemCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_DappChainBrowserItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.iconIv = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIv];
        [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.centerX.equalTo(self.contentView.mas_left).offset(25);
        }];
        self.titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:18 textColor:[UIColor g_whiteTextColor]];
        self.titleLb.numberOfLines = 1;
        self.titleLb.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(50);
            make.right.centerY.offset(0);
        }];
    }
    return self;
}
- (void)setModel:(PW_DappChainBrowserModel *)model {
    _model = model;
//    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
//    self.titleLb.text = model.title;
}

@end
