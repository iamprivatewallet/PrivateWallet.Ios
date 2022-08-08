//
//  PW_NFTSectionTitleView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTSectionTitleView.h"

@interface PW_NFTSectionTitleView ()

@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_NFTSectionTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLb.text = title;
}
- (void)makeViews {
    [self addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.centerY.offset(4);
    }];
}
#pragma mark - lazy
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:15 textColor:[UIColor g_textColor]];
    }
    return _titleLb;
}

@end
