//
//  UIView+PW_View.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import "UIView+PW_View.h"

@implementation UIView (PW_View)

- (void)setShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    [self setShadowColor:color offset:offset radius:radius path:nil];
}
- (void)setShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius path:(nullable UIBezierPath *)path {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowOpacity = 1;
}

@end
