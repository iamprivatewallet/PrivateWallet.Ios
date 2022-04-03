//
//  PW_ViewTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/30.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_ViewTool : NSObject

+ (UILabel *)labelText:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)color;
+ (UILabel *)labelSemiboldText:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)color;
+ (UILabel *)labelMediumText:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)color;
+ (UILabel *)labelText:(NSString *)text fontSize:(CGFloat)size weight:(UIFontWeight)weight textColor:(UIColor *)color;

+ (UIButton *)buttonSemiboldTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor cornerRadius:(CGFloat)cornerRadius backgroundColor:(nullable UIColor *)backgroundColor target:(nullable id)target action:(nullable SEL)action;
+ (UIButton *)buttonSemiboldTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor imageName:(NSString *)imageName target:(nullable id)target action:(nullable SEL)action;
+ (UIButton *)buttonTitle:(NSString *)title fontSize:(CGFloat)fontSize weight:(UIFontWeight)weight titleColor:(UIColor *)titleColor cornerRadius:(CGFloat)cornerRadius backgroundColor:(nullable UIColor *)backgroundColor target:(nullable id)target action:(nullable SEL)action;
+ (UIButton *)buttonImageName:(NSString *)imageName target:(nullable id)target action:(nullable SEL)action;
+ (UIButton *)buttonImageName:(NSString *)imageName selectedImage:(nullable NSString *)selectedImage target:(nullable id)target action:(nullable SEL)action;

+ (void)setupView:(UIView *)view cornerRadius:(CGFloat)cornerRadius shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius;
+ (void)setupView:(UIView *)view cornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius;

@end

NS_ASSUME_NONNULL_END
