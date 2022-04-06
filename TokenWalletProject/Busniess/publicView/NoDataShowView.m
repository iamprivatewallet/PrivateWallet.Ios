//
//  NoDataShowView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "NoDataShowView.h"

@implementation NoDataShowView

+ (NoDataShowView *)showView:(UIView *)view image:(NSString *)image text:(NSString *)text {
    return [self showView:view image:image text:text offsetY:-kNavBarAndStatusBarHeight];
}
+ (NoDataShowView *)showView:(UIView *)view image:(NSString *)image text:(NSString *)text offsetY:(CGFloat)offsetY {
    NoDataShowView *backView = nil;
    for (NoDataShowView *subv in view.subviews) {
        if ([subv isKindOfClass:[NoDataShowView class]]) {
            [subv removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[NoDataShowView alloc] init];
//        backView.backgroundColor = [UIColor whiteColor];
        [view addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.centerY.offset(offsetY);
        }];
        UIImageView *img = [ZZCustomView imageViewInitView:backView image:ImageNamed(image)];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.centerX.equalTo(backView);
            make.size.mas_equalTo(CGSizeMake(94, 94));
        }];
        
        UILabel *title = [ZZCustomView labelInitWithView:backView text:text textColor:[UIColor g_grayTextColor] font:GCSFontRegular(13)];
        title.textAlignment = NSTextAlignmentCenter;
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(img.mas_bottom).offset(15);
            make.left.right.equalTo(backView);
            make.bottom.mas_lessThanOrEqualTo(0);
        }];
    }
    return backView;
}
- (void)setOffsetY:(CGFloat)offsetY {
    _offsetY = offsetY;
    if (self.superview) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self.superview);
            make.centerY.offset(offsetY);
        }];
    }
}
- (void)dismissView {
    [self removeFromSuperview];
}

@end
