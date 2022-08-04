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

@end

@implementation PW_NFTDetailDataSectionHeaderView

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
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.height.mas_equalTo(35);
        make.centerY.offset(0);
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

@end
