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
@property (nonatomic, strong) UIView *lineView;

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
    self.fluctuationRangeLb.backgroundColor = model.rose.floatValue>0?[UIColor g_roseColor]:[UIColor g_fallColor];
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
    [self.bodyView addSubview:self.lineView];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.bottom.offset(0);
    }];
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bodyView.mas_centerY).offset(-2);
        make.left.offset(0);
    }];
    [self.marketValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bodyView.mas_centerY).offset(2);
        make.left.offset(0);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-110);
        make.centerY.offset(0);
    }];
    [self.fluctuationRangeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectionBtn.mas_left).offset(-10);
        make.centerY.offset(0);
        make.width.offset(65);
        make.height.offset(28);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
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
        _nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:20 textColor:[UIColor g_boldTextColor]];
    }
    return _nameLb;
}
- (UILabel *)marketValueLb {
    if (!_marketValueLb) {
        _marketValueLb = [PW_ViewTool labelText:@"--" fontSize:15 textColor:[UIColor g_textColor]];
    }
    return _marketValueLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [PW_ViewTool labelText:@"--" fontSize:18 textColor:[UIColor g_textColor]];
    }
    return _priceLb;
}
- (UILabel *)fluctuationRangeLb {
    if (!_fluctuationRangeLb) {
        _fluctuationRangeLb = [PW_ViewTool labelMediumText:@"--" fontSize:15 textColor:[UIColor g_primaryTextColor]];
        _fluctuationRangeLb.textAlignment = NSTextAlignmentCenter;
        _fluctuationRangeLb.backgroundColor = [UIColor g_primaryColor];
        [_fluctuationRangeLb setCornerRadius:8];
        _fluctuationRangeLb.adjustsFontSizeToFitWidth = YES;
    }
    return _fluctuationRangeLb;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor g_lineColor];
    }
    return _lineView;
}

@end
