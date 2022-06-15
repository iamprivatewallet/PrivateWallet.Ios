//
//  PW_SegmentedHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SegmentedHeaderView.h"

@interface PW_SegmentedHeaderView ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation PW_SegmentedHeaderView

- (void)configurationItems:(NSArray<NSString *> *)items {
    if (_segmentedControl) {
        [_segmentedControl removeFromSuperview];
    }
    _segmentedControl = [PW_ViewTool segmentedControlWithTitles:items];
    [self.contentView addSubview:_segmentedControl];
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.centerY.offset(2);
        make.height.offset(38);
    }];
    [_segmentedControl addTarget:self action:@selector(menuChangeAction) forControlEvents:UIControlEventValueChanged];
}
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    self.segmentedControl.selectedSegmentIndex = selectedIndex;
}
- (void)menuChangeAction {
    if (self.clickBlock) {
        self.clickBlock(self.segmentedControl.selectedSegmentIndex);
    }
}

@end
