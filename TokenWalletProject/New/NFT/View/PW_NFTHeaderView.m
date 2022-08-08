//
//  PW_NFTHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTHeaderView.h"
#import <SDCycleScrollView.h>

@interface PW_NFTHeaderView () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *sdScrollView;

@end

@implementation PW_NFTHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setDataArr:(NSArray<PW_NFTBannerModel *> *)dataArr {
    _dataArr = dataArr;
    NSMutableArray *array = [NSMutableArray array];
    for (PW_NFTBannerModel *model in dataArr) {
        [array addObject:model.imgH5];
    }
    self.sdScrollView.imageURLStringsGroup = array;
}
#pragma mark - delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    PW_NFTBannerModel *model = self.dataArr[index];
    if (self.clickBlock) {
        self.clickBlock(model);
    }
}
- (void)makeViews {
    UIView *bodyView = [[UIView alloc] init];
    bodyView.layer.cornerRadius = 5;
    bodyView.backgroundColor = [UIColor g_bgColor];
    [bodyView setShadowColor:[UIColor g_shadowGrayColor] offset:CGSizeMake(0, 6) radius:8];
    [self addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(-8);
        make.left.offset(34);
        make.right.offset(-34);
    }];
    [bodyView addSubview:self.sdScrollView];
    [self.sdScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(2);
        make.right.bottom.offset(-2);
    }];
}
#pragma mark - lazy
- (SDCycleScrollView *)sdScrollView {
    if (!_sdScrollView) {
        _sdScrollView = [[SDCycleScrollView alloc] init];
        _sdScrollView.placeholderImage = [UIImage imageNamed:@""];
        _sdScrollView.delegate = self;
        _sdScrollView.autoScrollTimeInterval = 3;
        _sdScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _sdScrollView.currentPageDotColor = [UIColor g_primaryColor];
        _sdScrollView.pageDotColor = [UIColor g_bgColor];
        _sdScrollView.backgroundColor = [UIColor g_grayBgColor];
        _sdScrollView.layer.masksToBounds = YES;
        _sdScrollView.layer.cornerRadius = 8;
    }
    return _sdScrollView;
}

@end
