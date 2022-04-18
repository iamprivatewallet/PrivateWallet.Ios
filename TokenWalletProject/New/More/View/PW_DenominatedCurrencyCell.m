//
//  PW_DenominatedCurrencyCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DenominatedCurrencyCell.h"

@interface PW_DenominatedCurrencyCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UILabel *iconLb;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *openBtn;

@end

@implementation PW_DenominatedCurrencyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_DenominatedCurrencyModel *)model {
    _model = model;
    self.iconLb.text = model.iconStr;
    self.titleLb.text = model.title;
    self.openBtn.selected = model.selected;
}
- (void)makeViews {
    self.bodyView = [[UIView alloc] init];
    [self.bodyView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    self.bodyView.backgroundColor = [UIColor g_bgColor];
    [self.contentView addSubview:self.bodyView];
    self.iconLb = [[UILabel alloc] init];
    self.iconLb.textColor = [UIColor g_hex:@"#11D1C7"];
    self.iconLb.font = [UIFont pw_regularFontOfSize:22];
    self.iconLb.textAlignment = NSTextAlignmentCenter;
    self.iconLb.layer.cornerRadius = 20;
    self.iconLb.layer.masksToBounds = YES;
    self.iconLb.backgroundColor = [UIColor g_hex:@"#E5FAF9"];
    [self.bodyView addSubview:self.iconLb];
    self.titleLb = [PW_ViewTool labelMediumText:@"--" fontSize:16 textColor:[UIColor g_boldTextColor]];
    [self.bodyView addSubview:self.titleLb];
    self.openBtn = [[UIButton alloc] init];
    self.openBtn.userInteractionEnabled = NO;
    [self.openBtn setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
    [self.openBtn setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateSelected];
    [self.bodyView addSubview:self.openBtn];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.offset(5);
        make.bottom.offset(-5);
    }];
    [self.iconLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.width.height.offset(40);
        make.centerY.offset(0);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconLb.mas_right).offset(15);
        make.centerY.offset(0);
    }];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.centerY.offset(0);
    }];
}

@end
