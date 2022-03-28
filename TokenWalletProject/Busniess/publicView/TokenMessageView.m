//
//  TokenMessageView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "TokenMessageView.h"

@implementation TokenMessageView

+(void)showMessageWithText:(NSString *)text imageName:(NSString *)imageName{
    TokenMessageView *backView = nil;
    [SVProgressHUD dismiss];
    for (TokenMessageView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[TokenMessageView alloc] initWithFrame:[UIScreen mainScreen].bounds text:text imageName:imageName];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backView removeFromSuperview];
    });

}

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text imageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViewsWithTitle:text image:imageName];
    }
    return self;
}

- (void)makeViewsWithTitle:(NSString *)title image:(NSString *)image{
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = COLORFORRGB(0xf7f7f7);
    grayView.layer.cornerRadius = 12;
    [self addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(120), CGFloatScale(130)));
    }];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:ImageNamed(image)];
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayView).offset(CGFloatScale(20));
        make.centerX.equalTo(grayView);
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(55), CGFloatScale(55)));
    }];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = title;
    titleLbl.font = GCSFontRegular(15);
    titleLbl.textColor = [UIColor im_grayColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(CGFloatScale(12));
        make.centerX.equalTo(grayView);
        make.left.right.equalTo(grayView);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
