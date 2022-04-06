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
        [self layoutIfNeeded];
        tSize = self.frame.size;
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

@end
