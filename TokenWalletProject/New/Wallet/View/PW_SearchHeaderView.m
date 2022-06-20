//
//  PW_SearchHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchHeaderView.h"

@interface PW_SearchHeaderView ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIImageView *iconIv;

@end

@implementation PW_SearchHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLb.text = title;
}
- (void)setShowHot:(BOOL)showHot {
    _showHot = showHot;
    self.iconIv.hidden = !showHot;
}
- (void)makeViews {
    self.titleLb = [PW_ViewTool labelMediumText:@"--" fontSize:20 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.centerY.offset(0);
    }];
    self.iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_hot"]];
    self.iconIv.hidden = YES;
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb.mas_right).offset(15);
        make.centerY.offset(0);
    }];
}

@end
