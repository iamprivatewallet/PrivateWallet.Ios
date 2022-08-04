//
//  PW_NFTDetailOfferSectionHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/4.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTDetailOfferSectionHeaderView.h"
#import "PW_SegmentedControl.h"

@interface PW_NFTDetailOfferSectionHeaderView ()

@property (nonatomic, strong) PW_SegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UILabel *buyerLb;

@end

@implementation PW_NFTDetailOfferSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
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
    [self.contentView addSubview:self.priceLb];
    [self.contentView addSubview:self.buyerLb];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.height.mas_equalTo(35);
        make.top.offset(20);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.bottom.offset(0);
    }];
    [self.buyerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.bottom.offset(0);
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

@end
