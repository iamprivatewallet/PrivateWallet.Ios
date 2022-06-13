//
//  PW_MarketHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MarketHeaderView.h"

@interface PW_MarketHeaderView ()

@property (nonatomic, strong) UIView *bodyView;

@end

@implementation PW_MarketHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    self.bodyView = [[UIView alloc] init];
    [self.contentView addSubview:self.bodyView];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.top.offset(10);
        make.right.offset(-36);
        make.bottom.offset(-10);
    }];
    UILabel *currencyLb = [PW_ViewTool labelText:PW_StrFormat(@"%@/%@",LocalizedStr(@"text_name"),LocalizedStr(@"text_marketValue")) fontSize:15 textColor:[UIColor g_textColor]];
    [self.bodyView addSubview:currencyLb];
    UILabel *priceLb = [PW_ViewTool labelText:LocalizedStr(@"text_price") fontSize:15 textColor:[UIColor g_textColor]];
    [self.bodyView addSubview:priceLb];
    UILabel *fluctuationRangeLb = [PW_ViewTool labelText:LocalizedStr(@"text_fluctuationRange") fontSize:15 textColor:[UIColor g_textColor]];
    [self.bodyView addSubview:fluctuationRangeLb];
    [currencyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.offset(0);
    }];
    [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-110);
        make.centerY.offset(0);
    }];
    [fluctuationRangeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
}

@end
