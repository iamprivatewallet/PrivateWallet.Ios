//
//  PW_ViewTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/30.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ViewTool.h"
#import "PW_Button.h"

@implementation PW_ViewTool

+ (UILabel *)labelText:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)color {
    return [self labelText:text fontSize:size weight:UIFontWeightRegular textColor:color];
}
+ (UILabel *)labelBoldText:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)color {
    return [self labelText:text fontSize:size weight:UIFontWeightBold textColor:color];
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
+ (UIButton *)buttonSemiboldTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor imageName:(nullable NSString *)imageName target:(nullable id)target action:(nullable SEL)action {
    PW_Button *btn = [PW_Button buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    if([imageName isNoEmpty]){
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn layoutWithEdgeInsetStyle:PW_ButtonEdgeInsetStyleLeft spaceBetweenImageAndTitle:5];
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:[titleColor colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    if(target&&action){
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}
+ (UIButton *)buttonTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor cornerRadius:(CGFloat)cornerRadius backgroundColor:(nullable UIColor *)backgroundColor target:(nullable id)target action:(nullable SEL)action {
    return [self buttonTitle:title fontSize:fontSize weight:UIFontWeightRegular titleColor:titleColor cornerRadius:cornerRadius backgroundColor:backgroundColor target:target action:action];
}
+ (UIButton *)buttonTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor imageName:(nullable NSString *)imageName target:(nullable id)target action:(nullable SEL)action {
    PW_Button *btn = [PW_Button buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    if([imageName isNoEmpty]){
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn layoutWithEdgeInsetStyle:PW_ButtonEdgeInsetStyleLeft spaceBetweenImageAndTitle:5];
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:[titleColor colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    if(target&&action){
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}
+ (UIButton *)buttonTitle:(NSString *)title fontSize:(CGFloat)fontSize weight:(UIFontWeight)weight titleColor:(UIColor *)titleColor cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action {
    PW_Button *btn = [PW_Button buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:weight];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:[titleColor colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    if (cornerRadius>0) {
        btn.layer.cornerRadius = cornerRadius;
        btn.layer.masksToBounds = YES;
    }
    if(backgroundColor){
        UIImage *normalImage = [UIImage imageWithColor:backgroundColor size:CGSizeMake(1, 1)];
        UIImage *highlightImage = [UIImage imageWithColor:[backgroundColor colorWithAlphaComponent:0.8] size:CGSizeMake(1, 1)];
        UIImage *disabledImage = [UIImage imageWithColor:[backgroundColor colorWithAlphaComponent:0.5] size:CGSizeMake(1, 1)];
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        [btn setBackgroundImage:disabledImage forState:UIControlStateDisabled];
    }
    if(target&&action){
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}
+ (UIButton *)buttonImageName:(NSString *)imageName target:(nullable id)target action:(nullable SEL)action {
    return [self buttonImageName:imageName selectedImage:nil target:target action:action];
}
+ (UIButton *)buttonImageName:(NSString *)imageName selectedImage:(nullable NSString *)selectedImage target:(nullable id)target action:(nullable SEL)action {
    PW_Button *btn = [PW_Button buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if([selectedImage isNoEmpty]){
        [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    }
    if(target&&action){
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

+ (UITextField *)textFieldFont:(UIFont *)font color:(UIColor *)color placeholder:(NSString *)placeholder {
    UITextField *tf = [[UITextField alloc] init];
    tf.font = font;
    tf.textColor = color;
    [tf pw_setPlaceholder:placeholder];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    return tf;
}

+ (UISegmentedControl *)segmentedControlWithTitles:(NSArray<NSString *> *)titles {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:titles];
    segmentedControl.apportionsSegmentWidthsByContent = YES;
    [segmentedControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:[UIImage imageWithColor:[UIColor g_segmentedColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    UIImage *dividerImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
    [segmentedControl setDividerImage:dividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    segmentedControl.tintColor = [UIColor g_segmentedColor];
    segmentedControl.backgroundColor = [UIColor whiteColor];
    [segmentedControl setBorderColor:[UIColor g_segmentedColor] width:1 radius:8];
    if (@available(iOS 13.0, *)) {
        segmentedControl.selectedSegmentTintColor = [UIColor g_segmentedColor];
    } else {
        // Fallback on earlier versions
    }
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont pw_mediumFontOfSize:18],NSForegroundColorAttributeName:[UIColor g_textColor]} forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont pw_mediumFontOfSize:18],NSForegroundColorAttributeName:[UIColor g_whiteTextColor]} forState:UIControlStateSelected];
    return segmentedControl;
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
