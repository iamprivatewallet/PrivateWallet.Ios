//
//  PW_DappItemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/23.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappItemCell.h"

@interface PW_DappItemCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_DappItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.iconIv = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIv];
        [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(10);
            make.centerX.offset(0);
            make.height.equalTo(self.iconIv.mas_width);
        }];
        self.titleLb = [PW_ViewTool labelText:@"--" fontSize:14 textColor:[UIColor g_grayTextColor]];
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
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    self.titleLb.text = model.appName;
}

@end
