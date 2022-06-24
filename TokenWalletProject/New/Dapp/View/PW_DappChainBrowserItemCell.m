//
//  PW_DappChainBrowserItemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappChainBrowserItemCell.h"

@interface PW_DappChainBrowserItemCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_DappChainBrowserItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.iconIv = [[UIImageView alloc] init];
        self.iconIv.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.iconIv];
        [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return self;
}
- (void)setModel:(PW_DappChainBrowserModel *)model {
    _model = model;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
}

@end
