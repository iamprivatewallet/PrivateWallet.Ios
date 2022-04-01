//
//  PW_ViewTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/30.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ViewTool.h"

@implementation PW_ViewTool

+ (UILabel *)labelText:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)color {
    return [self labelText:text fontSize:size weight:UIFontWeightRegular textColor:color];
}
+ (UILabel *)labelSemiboldText:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)color {
    return [self labelText:text fontSize:size weight:UIFontWeightSemibold textColor:color];
}
+ (UILabel *)labelMediumText:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)color {
    return [self labelText:text fontSize:size weight:UIFontWeightMedium textColor:color];
}
+ (UILabel *)labelText:(NSString *)text fontSize:(CGFloat)size weight:(UIFontWeight)weight textColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}

+ (UIButton *)buttonSemiboldTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action {
    return [self buttonTitle:title fontSize:fontSize weight:UIFontWeightSemibold titleColor:titleColor cornerRadius:cornerRadius backgroundColor:backgroundColor target:target action:action];
}
+ (UIButton *)buttonTitle:(NSString *)title fontSize:(CGFloat)fontSize weight:(UIFontWeight)weight titleColor:(UIColor *)titleColor cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:weight];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:[titleColor colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    btn.layer.cornerRadius = cornerRadius;
    btn.layer.masksToBounds = YES;
    if(backgroundColor){
        UIImage *normalImage = [UIImage imageWithColor:backgroundColor size:CGSizeMake(1, 1)];
        UIImage *disabledImage = [UIImage imageWithColor:[backgroundColor colorWithAlphaComponent:0.5] size:CGSizeMake(1, 1)];
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:disabledImage forState:UIControlStateDisabled];
    }
    if(target&&action){
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

+ (void)setupView:(UIView *)view cornerRadius:(CGFloat)cornerRadius shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius {
    [self setupView:view cornerRadius:cornerRadius shadowColor:[UIColor g_shadowColor] shadowOffset:shadowOffset shadowRadius:shadowRadius];
}
+ (void)setupView:(UIView *)view cornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius {
    if(view==nil){return;}
    view.layer.cornerRadius = cornerRadius;
    view.layer.shadowColor = shadowColor.CGColor;
    view.layer.shadowOffset = shadowOffset;
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = 1;
}

@end
