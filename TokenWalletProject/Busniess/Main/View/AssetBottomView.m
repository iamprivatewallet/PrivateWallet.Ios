//
//  AssetBottomView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/24.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AssetBottomView.h"


@interface AssetBottomView()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) void(^clickBlock)(NSInteger index);

@end
@implementation AssetBottomView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)clickBtnBlock:(void(^)(NSInteger index))block{
    self.clickBlock = block;
}
- (void)makeViews{
//    NSArray *titleAry = @[@"兑换",@"收款",@"转账"];
    NSArray *titleAry = @[@"收款",@"转账"];
    NSMutableArray *tolAry = [NSMutableArray new];
    for (int i = 0; i < titleAry.count; i ++) {
       UIButton *btn = [ZZCustomView buttonInitWithView:self title:titleAry[i] titleColor:nil titleFont:GCSFontRegular(15) bgColor:nil];
       btn.tag = i;
       [btn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       btn.layer.cornerRadius = 4;
//       if (i == 0) {
//           [btn setTitleColor:[UIColor im_textColor_three] forState:UIControlStateNormal];
//           btn.backgroundColor = [UIColor whiteColor];
//           btn.layer.borderColor = COLORFORRGB(0xd0cfcf).CGColor;
//           btn.layer.borderWidth = 1;
//           [btn setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
//           btn.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, -30);
//           btn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 10);
//
//       }else
       if (i == 0) {
           btn.backgroundColor = COLORFORRGB(0x23bdd3);
       }else{
           btn.backgroundColor = COLORFORRGB(0x1c8ee2);
       }
       [tolAry addObject:btn];
    }
    
    //水平方向控件间隔固定等间隔
    [tolAry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:10 tailSpacing:10];
    [tolAry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.height.equalTo(@45);
    }];

    UIView *line = [ZZCustomView viewInitWithView:self bgColor:[UIColor im_borderLineColor]];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@1);
    }];
}
- (void)itemBtnAction:(UIButton *)sender{
    self.clickBlock(sender.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
