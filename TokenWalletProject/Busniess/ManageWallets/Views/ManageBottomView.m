//
//  ManageBottomView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/30.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ManageBottomView.h"

@implementation ManageBottomView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeViews];
    }
    return self;
}

- (void)makeViews{
    self.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor im_borderLineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
//    UIView *centerLine = [[UIView alloc] init];
//    centerLine.backgroundColor = COLORA(0, 0, 0, 0.15);
//    [self addSubview:centerLine];
//    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(18);
//        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(1);
//        make.centerX.equalTo(self);
//    }];
    
//    UIView *leftView = [[UIView alloc] init];
//    [self addSubview:leftView];
//    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.equalTo(self);
//        make.right.equalTo(self.mas_centerX);
//    }];
//    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapAction)];
//    [leftView addGestureRecognizer:leftTap];
//    UILabel *leftTitle = [ZZCustomView labelInitWithView:leftView text:@"配对硬件" textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(17)];
//    [leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(leftView).offset(15);
//        make.left.equalTo(leftView.mas_centerX).offset(-10);
//    }];
//
//    UIImageView *leftImg = [ZZCustomView imageViewInitView:leftView imageName:@"pairHW"];
//    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(leftTitle);
//        make.height.mas_equalTo(25);
//        make.width.mas_equalTo(25);
//        make.right.equalTo(leftTitle.mas_left).offset(-13);
//    }];
    
    
    UIView *rightView = [[UIView alloc] init];
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
//        make.left.equalTo(self.mas_centerX);
    }];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapAction)];
    [rightView addGestureRecognizer:rightTap];
    
    UILabel *rightTitle = [ZZCustomView labelInitWithView:rightView text:@"添加钱包" textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(17)];
    [rightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightView).offset(15);
        make.left.equalTo(rightView.mas_centerX).offset(-10);
    }];
    
    UIImageView *rightImg = [ZZCustomView imageViewInitView:rightView imageName:@"addWallet"];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightTitle);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
        make.right.equalTo(rightTitle.mas_left).offset(-13);
    }];
    
}

- (void)leftTapAction{
    if (self.bottomActionBlock) {
        self.bottomActionBlock(0);
    }
}
- (void)rightTapAction{
    if (self.bottomActionBlock) {
        self.bottomActionBlock(1);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
