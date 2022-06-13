//
//  PW_TitleHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TitleHeaderView.h"

@interface PW_TitleHeaderView ()

@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_TitleHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(38);
            make.centerY.offset(0);
        }];
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLb.text = title;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelMediumText:@"--" fontSize:20 textColor:[UIColor g_textColor]];
    }
    return _titleLb;
}

@end
