//
//  UIView+PW_View.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PW_ViewBlock)(UIView * _Nonnull view);

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PW_View)

- (void)addTapTarget:(nullable id)target action:(SEL)action;
- (void)addTapBlock:(PW_ViewBlock)block;

- (void)setCornerRadius:(CGFloat)radius;

- (void)setRadius:(CGFloat)radius corners:(UIRectCorner)corners;
- (void)setRadius:(CGFloat)radius corners:(UIRectCorner)corners size:(CGSize)size;

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius;

- (void)setShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;
- (void)setShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius path:(nullable UIBezierPath *)path;

- (void)setDottedLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth length:(CGFloat)length space:(CGFloat)space radius:(CGFloat)radius;
- (void)setDottedLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth length:(CGFloat)length space:(CGFloat)space radius:(CGFloat)radius size:(CGSize)size;

- (UIImage *)convertViewToImage;
- (UIImage *)convertViewToImageBgColor:(UIColor *)bgColor;

- (void)setRequiredHorizontal;
- (void)setRequiredVertical;

@end

NS_ASSUME_NONNULL_END
