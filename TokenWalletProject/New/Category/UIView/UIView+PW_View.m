//
//  UIView+PW_View.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import "UIView+PW_View.h"

@implementation UIView (PW_View)

- (void)addTapTarget:(nullable id)target action:(SEL)action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (void)setRadius:(CGFloat)radius corners:(UIRectCorner)corners {
    [self setRadius:radius size:CGSizeZero corners:corners];
}
- (void)setRadius:(CGFloat)radius size:(CGSize)size corners:(UIRectCorner)corners {
    CGSize tSize = size;
    if(size.width==0&&size.height==0){
        [self setNeedsLayout];
        [self layoutIfNeeded];
        tSize = self.frame.size;
        if(tSize.width==0&&tSize.height==0){
            return;
        }
    }
    CGRect rect = CGRectMake(0, 0, tSize.width, tSize.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
}

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

- (void)setDottedLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth length:(CGFloat)length space:(CGFloat)space radius:(CGFloat)radius {
    [self setDottedLineColor:lineColor lineWidth:lineWidth length:length space:space radius:radius size:CGSizeZero];
}
- (void)setDottedLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth length:(CGFloat)length space:(CGFloat)space radius:(CGFloat)radius size:(CGSize)size {
    CGSize tSize = size;
    if(size.width==0&&size.height==0){
        [self setNeedsLayout];
        [self layoutIfNeeded];
        tSize = self.frame.size;
        if(tSize.width==0&&tSize.height==0){
            return;
        }
    }
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, tSize.width, tSize.height);
    borderLayer.position = CGPointMake(tSize.width*0.5, tSize.height*0.5);
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:radius].CGPath;
    borderLayer.lineWidth = lineWidth / [[UIScreen mainScreen] scale];
    borderLayer.lineDashPattern = @[@(length), @(space)];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = lineColor.CGColor;
    [self.layer addSublayer:borderLayer];
}

- (UIImage *)convertViewToImage {
    CGSize tSize = self.bounds.size;
    if(tSize.width==0&&tSize.height==0){
        [self setNeedsLayout];
        [self layoutIfNeeded];
        tSize = self.bounds.size;
        if(tSize.width==0&&tSize.height==0){
            tSize = CGSizeMake(100, 100);
        }
    }
    UIGraphicsBeginImageContextWithOptions(tSize, NO, [UIScreen mainScreen].scale);
    [[UIColor g_bgColor] setFill];
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
