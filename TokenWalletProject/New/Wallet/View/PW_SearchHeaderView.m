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
- (void)makeViews {
    self.titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:15 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(26);
        make.centerY.offset(0);
    }];
}

@end
