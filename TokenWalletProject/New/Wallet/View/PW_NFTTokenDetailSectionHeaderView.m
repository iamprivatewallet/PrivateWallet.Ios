//
//  PW_NFTTokenDetailSectionHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/3.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTTokenDetailSectionHeaderView.h"

@interface PW_NFTTokenDetailSectionHeaderView ()

@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_NFTTokenDetailSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.bottom.offset(0);
    }];
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_transactionRecord") fontSize:14 textColor:[UIColor g_textColor]];
    }
    return _titleLb;
}

@end
