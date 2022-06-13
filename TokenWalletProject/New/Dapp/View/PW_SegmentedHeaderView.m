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
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    [self.contentView addSubview:_segmentedControl];
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.centerY.offset(2);
        make.height.offset(38);
    }];
    [self configurationUI];
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
- (void)configurationUI {
    _segmentedControl.apportionsSegmentWidthsByContent = YES;
    [_segmentedControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segmentedControl setBackgroundImage:[UIImage imageWithColor:[UIColor g_hex:@"#7221F4"] size:CGSizeMake(1, 1)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    UIImage *dividerImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
    [_segmentedControl setDividerImage:dividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    _segmentedControl.tintColor = [UIColor g_hex:@"#7221F4"];
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    [_segmentedControl setBorderColor:[UIColor g_hex:@"#7221F4"] width:1 radius:8];
    if (@available(iOS 13.0, *)) {
        _segmentedControl.selectedSegmentTintColor = [UIColor g_hex:@"#7221F4"];
    } else {
        // Fallback on earlier versions
    }
    [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont pw_mediumFontOfSize:18],NSForegroundColorAttributeName:[UIColor g_textColor]} forState:UIControlStateNormal];
    [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont pw_mediumFontOfSize:18],NSForegroundColorAttributeName:[UIColor g_whiteTextColor]} forState:UIControlStateSelected];
    [_segmentedControl addTarget:self action:@selector(menuChangeAction) forControlEvents:UIControlEventValueChanged];
}

@end
