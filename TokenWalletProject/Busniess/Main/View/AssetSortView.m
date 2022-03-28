//
//  AssetSortView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/24.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AssetSortView.h"
@interface AssetSortView()

@property (nonatomic, strong) UIView *line;


@end
@implementation AssetSortView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeViews];
    }
    return self;
}

- (void)makeViews{
    NSArray *titleAry = @[@"全部",@"转出",@"转入",@"失败"];
    NSMutableArray *tolAry = [NSMutableArray new];

    for (int i = 0; i < titleAry.count; i ++) {
       UIButton *btn = [ZZCustomView buttonInitWithView:self title:titleAry[i] titleColor:[UIColor im_textColor_three] titleFont:GCSFontRegular(14) bgColor:nil];
       btn.tag = i;
       [btn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       [tolAry addObject:btn];
        
        if (i == 0) {
            self.line = [ZZCustomView viewInitWithView:self bgColor:[UIColor im_textColor_three]];
            [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
                make.centerX.equalTo(btn);
                make.height.equalTo(@1.5);
                make.width.equalTo(@70);
            }];
        }
    }

    //水平方向控件间隔固定等间隔
    [tolAry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:10 tailSpacing:10];
    [tolAry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.equalTo(@45);
    }];
    
}

- (void)itemBtnAction:(UIButton *)sender{
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(sender);
        make.height.equalTo(@1.5);
        make.width.equalTo(@70);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickItemWithIndex:)]) {
        [self.delegate clickItemWithIndex:sender.tag];
    }
}

@end
