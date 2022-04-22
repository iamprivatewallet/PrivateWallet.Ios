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
    self.bodyView.backgroundColor = [[UIColor g_grayBgColor] colorWithAlphaComponent:0.5];
    [self.bodyView setCornerRadius:8];
    [self.contentView addSubview:self.bodyView];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(10);
        make.right.offset(-20);
        make.bottom.offset(-10);
    }];
    UILabel *currencyLb = [PW_ViewTool labelSemiboldText:PW_StrFormat(@"%@/%@",LocalizedStr(@"text_currency"),LocalizedStr(@"text_marketValue")) fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.bodyView addSubview:currencyLb];
    UILabel *priceLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_price") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.bodyView addSubview:priceLb];
    UILabel *fluctuationRangeLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_fluctuationRange") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.bodyView addSubview:fluctuationRangeLb];
    [currencyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35);
        make.centerY.offset(0);
    }];
    [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-124);
        make.centerY.offset(0);
    }];
    [fluctuationRangeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.centerY.offset(0);
    }];
}

@end
