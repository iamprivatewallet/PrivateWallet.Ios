//
//  PW_MarketCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MarketCell.h"

@interface PW_MarketCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *marketValueLb;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UILabel *fluctuationRangeLb;

@end

@implementation PW_MarketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_MarketModel *)model {
    _model = model;
    
    self.collectionBtn.selected = model.collection;
    self.nameLb.text = model.symbol;
    double million = 1000000;
    if (model.lastVol.doubleValue>=million) {
        self.marketValueLb.text = PW_StrFormat(@"$%@%@",[model.lastVol stringDownDividingBy10Power:8 scale:2],LocalizedStr(@"text_hundredMillion"));
    }else{
        self.marketValueLb.text = PW_StrFormat(@"$%@",model.lastVol);
    }
    self.priceLb.text = PW_StrFormat(@"$%@",[[model.last stringDownDecimal:2] currency]);
    self.fluctuationRangeLb.text = PW_StrFormat(@"%@%@%%",model.rose.floatValue>0?@"+":@"",[model.rose stringDownDecimal:2]);
    self.priceLb.textColor = self.fluctuationRangeLb.backgroundColor = model.rose.floatValue>0?[UIColor g_roseColor]:[UIColor g_fallColor];
}
- (void)collectionAction {
    if (self.collectionBlock) {
        self.collectionBlock(self.model);
    }
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.collectionBtn];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.marketValueLb];
    [self.bodyView addSubview:self.priceLb];
    [self.bodyView addSubview:self.fluctuationRangeLb];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-8);
        make.top.offset(0);
    }];
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(15);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(35);
    }];
    [self.marketValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-10);
        make.left.offset(35);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-124);
        make.centerY.offset(0);
    }];
    [self.fluctuationRangeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(-3);
        make.width.offset(78);
        make.height.offset(34);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.backgroundColor = [UIColor g_bgColor];
        [_bodyView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
        _bodyView.layer.cornerRadius = 8;
    }
    return _bodyView;
}
- (UIButton *)collectionBtn {
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBtn setImage:[UIImage imageNamed:@"icon_star"] forState:UIControlStateNormal];
        [_collectionBtn setImage:[UIImage imageNamed:@"icon_star_full"] forState:UIControlStateSelected];
        [_collectionBtn addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    }
    return _nameLb;
}
- (UILabel *)marketValueLb {
    if (!_marketValueLb) {
        _marketValueLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _marketValueLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [PW_ViewTool labelMediumText:@"--" fontSize:17 textColor:[UIColor g_textColor]];
    }
    return _priceLb;
}
- (UILabel *)fluctuationRangeLb {
    if (!_fluctuationRangeLb) {
        _fluctuationRangeLb = [PW_ViewTool labelMediumText:@"--" fontSize:16 textColor:[UIColor g_primaryTextColor]];
        _fluctuationRangeLb.textAlignment = NSTextAlignmentCenter;
        _fluctuationRangeLb.backgroundColor = [UIColor g_primaryColor];
        [_fluctuationRangeLb setCornerRadius:6];
        _fluctuationRangeLb.adjustsFontSizeToFitWidth = YES;
    }
    return _fluctuationRangeLb;
}

@end
