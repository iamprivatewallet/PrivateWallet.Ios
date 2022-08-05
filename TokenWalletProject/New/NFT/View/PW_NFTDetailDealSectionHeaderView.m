//
//  PW_NFTDetailDealSectionHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/4.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTDetailDealSectionHeaderView.h"
#import "PW_SegmentedControl.h"

@interface PW_NFTDetailDealSectionHeaderView ()

@property (nonatomic, strong) PW_SegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *typeLb;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UILabel *buyerLb;
@property (nonatomic, strong) UILabel *sellerLb;
@property (nonatomic, strong) UILabel *timeLb;

@end

@implementation PW_NFTDetailDealSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor g_bgColor];
        [self makeViews];
    }
    return self;
}
- (void)setIndex:(NSInteger)index {
    _index = index;
    self.segmentedControl.selectedIndex = index;
}
- (void)makeViews {
    [self.contentView addSubview:self.segmentedControl];
    [self.contentView addSubview:self.typeLb];
    [self.contentView addSubview:self.priceLb];
    [self.contentView addSubview:self.buyerLb];
    [self.contentView addSubview:self.sellerLb];
    [self.contentView addSubview:self.timeLb];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.height.mas_equalTo(35);
        make.top.offset(5);
    }];
    [self.typeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.bottom.offset(-5);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(78);
        make.bottom.offset(-5);
    }];
    [self.buyerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(-30);
        make.bottom.offset(-5);
    }];
    [self.sellerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(45);
        make.bottom.offset(-5);
    }];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.bottom.offset(-5);
    }];
}
#pragma mark - lazy
- (PW_SegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[PW_SegmentedControl alloc] init];
        _segmentedControl.dataArr = @[LocalizedStr(@"text_data"),LocalizedStr(@"text_offer"),LocalizedStr(@"text_deal")];
        _segmentedControl.selectedIndex = 0;
        __weak typeof(self) weakSelf = self;
        _segmentedControl.didClick = ^(NSInteger index) {
            if (weakSelf.segmentIndexBlock) {
                weakSelf.segmentIndexBlock(index);
            }
        };
    }
    return _segmentedControl;
}
- (UILabel *)typeLb {
    if (!_typeLb) {
        _typeLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_type") fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _typeLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_price") fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _priceLb;
}
- (UILabel *)buyerLb {
    if (!_buyerLb) {
        _buyerLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_buyer") fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _buyerLb;
}
- (UILabel *)sellerLb {
    if (!_sellerLb) {
        _sellerLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_seller") fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _sellerLb;
}
- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_time") fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _timeLb;
}

@end
