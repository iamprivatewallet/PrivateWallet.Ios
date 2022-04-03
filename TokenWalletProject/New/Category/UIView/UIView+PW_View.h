//
//  UIView+PW_View.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PW_View)

- (void)setShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;
- (void)setShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius path:(nullable UIBezierPath *)path;

@end

NS_ASSUME_NONNULL_END
