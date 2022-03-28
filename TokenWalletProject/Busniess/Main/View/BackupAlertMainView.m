//
//  BackupAlertMainView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BackupAlertMainView.h"
@interface BackupAlertMainView()

@end
@implementation BackupAlertMainView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor navAndTabBackColor];
       [self makeViews];
    }
    return self;
}

- (void)makeViews{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor im_borderLineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.top.equalTo(self);
    }];
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self text:@"安全提醒" textColor:[UIColor im_textColor_three] font:GCSFontRegular(19)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
    }];

    UILabel *messageLbl = [ZZCustomView labelInitWithView:self text:@"你的身份助记词未备份，请务必备份助记词" textColor:[UIColor im_grayColor] font:GCSFontRegular(15)];
    [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CGFloatScale(25));
        make.right.equalTo(self).offset(-CGFloatScale(25));
        make.top.equalTo(titleLbl.mas_bottom).offset(CGFloatScale(5));
    }];
    
    UIButton *laterBtn = [ZZCustomView buttonInitWithView:self title:@"稍后提醒" titleColor:[UIColor im_textColor_nine] titleFont:GCSFontRegular(16) bgColor:COLOR(213, 219, 223)];
    laterBtn.tag = 0;
    laterBtn.layer.cornerRadius = 10;
    [laterBtn addTarget:self action:@selector(buttonsEvent:) forControlEvents:UIControlEventTouchUpInside];
    [laterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CGFloatScale(25));
        make.right.equalTo(self.mas_centerX).offset(-CGFloatScale(10));
        make.bottom.equalTo(self).offset(-CGFloatScale(10));
        make.height.mas_equalTo(CGFloatScale(43));
    }];
    
    UIButton *nowBtn = [ZZCustomView buttonInitWithView:self title:@"立即备份" titleColor:[UIColor whiteColor] titleFont:GCSFontRegular(16) bgColor:[UIColor im_btnSelectColor]];
    nowBtn.tag = 1;
    nowBtn.layer.cornerRadius = 10;
    [nowBtn addTarget:self action:@selector(buttonsEvent:) forControlEvents:UIControlEventTouchUpInside];
    [nowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-CGFloatScale(25));
        make.left.equalTo(self.mas_centerX).offset(CGFloatScale(10));
        make.bottom.equalTo(self).offset(-CGFloatScale(10));
        make.height.equalTo(laterBtn);
        
    }];
    
    UILabel *messageLbl2 = [ZZCustomView labelInitWithView:self text:@"助记词可用于恢复身份下钱包资产，防止忘记密码、应用删除、手机丢失等情况导致资产损失。" textColor:[UIColor im_grayColor] font:GCSFontRegular(15)];
    [messageLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(messageLbl);
        make.top.equalTo(messageLbl.mas_bottom).offset(CGFloatScale(6));
        make.bottom.equalTo(nowBtn.mas_top).offset(-CGFloatScale(15));

    }];
}
- (void)buttonsEvent:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backupAlertBtnAciton:)]) {
        [self.delegate backupAlertBtnAciton:sender.tag];
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
