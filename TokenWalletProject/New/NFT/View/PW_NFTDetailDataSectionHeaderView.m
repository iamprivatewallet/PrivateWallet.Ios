//
//  PW_NFTDetailDataSectionHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/4.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTDetailDataSectionHeaderView.h"
#import "PW_SegmentedControl.h"

@interface PW_NFTDetailDataSectionHeaderView ()

@property (nonatomic, strong) PW_SegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *tokenStandardLb;
@property (nonatomic, strong) UILabel *networkLb;
@property (nonatomic, strong) UILabel *contractAddressLb;
@property (nonatomic, strong) UILabel *tokenIdLb;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_NFTDetailDataSectionHeaderView

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
- (void)copyContractAddressAction {
    
}
- (void)copyTokenIdAction {
    
}
- (void)makeViews {
    [self.contentView addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.height.mas_equalTo(35);
        make.top.offset(5);
    }];
    [self.contentView addSubview:self.tokenStandardLb];
    [self.contentView addSubview:self.networkLb];
    [self.contentView addSubview:self.contractAddressLb];
    [self.contentView addSubview:self.tokenIdLb];
    [self.contentView addSubview:self.titleLb];
    UILabel *tokenStandardTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_tokenStandard") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:tokenStandardTipLb];
    UILabel *networkTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_network") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:networkTipLb];
    UILabel *contractAddressTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_contractAddress") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:contractAddressTipLb];
    UIButton *copyContractAddressBtn = [PW_ViewTool buttonImageName:@"icon_copy_new_small" target:self action:@selector(copyContractAddressAction)];
    [self.contentView addSubview:copyContractAddressBtn];
    UILabel *tokenIdTipLb = [PW_ViewTool labelSemiboldText:@"Token ID" fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:tokenIdTipLb];
    UIButton *copyTokenIdBtn = [PW_ViewTool buttonImageName:@"icon_copy_new_small" target:self action:@selector(copyTokenIdAction)];
    [self.contentView addSubview:copyTokenIdBtn];
    [tokenStandardTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.equalTo(self.segmentedControl.mas_bottom).offset(20);
    }];
    [self.tokenStandardLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.centerY.equalTo(tokenStandardTipLb);
    }];
    [networkTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tokenStandardTipLb.mas_bottom).offset(10);
        make.left.offset(30);
    }];
    [self.networkLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(networkTipLb);
        make.right.offset(-30);
    }];
    [contractAddressTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(networkTipLb.mas_bottom).offset(10);
        make.left.offset(30);
    }];
    [self.contractAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contractAddressTipLb);
        make.right.equalTo(copyContractAddressBtn.mas_left).offset(-4);
    }];
    [copyContractAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contractAddressTipLb);
        make.right.offset(-30);
    }];
    [tokenIdTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contractAddressTipLb.mas_bottom).offset(10);
        make.left.offset(30);
    }];
    [self.tokenIdLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tokenIdTipLb);
        make.right.equalTo(copyTokenIdBtn.mas_left).offset(-4);
    }];
    [copyTokenIdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tokenIdTipLb);
        make.right.offset(-30);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tokenIdTipLb.mas_bottom).offset(20);
        make.left.offset(30);
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
- (UILabel *)tokenStandardLb {
    if (!_tokenStandardLb) {
        _tokenStandardLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _tokenStandardLb;
}
- (UILabel *)networkLb {
    if (!_networkLb) {
        _networkLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _networkLb;
}
- (UILabel *)contractAddressLb {
    if (!_contractAddressLb) {
        _contractAddressLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
        _contractAddressLb.numberOfLines = 1;
        _contractAddressLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _contractAddressLb;
}
- (UILabel *)tokenIdLb {
    if (!_tokenIdLb) {
        _tokenIdLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
        _tokenIdLb.numberOfLines = 1;
        _tokenIdLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _tokenIdLb;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_property") fontSize:14 textColor:[UIColor g_textColor]];
    }
    return _titleLb;
}

@end
