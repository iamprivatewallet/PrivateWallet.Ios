//
//  UIView+PW_View.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import "UIView+PW_View.h"

static void * eventsBlockKey = &eventsBlockKey;

@interface UIView ()

@property (nonatomic, copy) PW_ViewBlock viewBlock;

@end

@implementation UIView (PW_View)

- (void)addTapTarget:(nullable id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}
- (void)addTapBlock:(PW_ViewBlock)block {
    self.userInteractionEnabled = YES;
    self.viewBlock = block;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__tapAction:)];
    [self addGestureRecognizer:tap];
}
- (void)__tapAction:(UIGestureRecognizer *)gesture {
    if (self.viewBlock) {
        self.viewBlock(self);
    }
}
- (void)setViewBlock:(PW_ViewBlock)viewBlock {
    objc_setAssociatedObject(self, &eventsBlockKey, viewBlock, OBJC_ASSOCIATION_COPY);
}
- (PW_ViewBlock)viewBlock {
    return objc_getAssociatedObject(self, &eventsBlockKey);
}

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)setRadius:(CGFloat)radius corners:(UIRectCorner)corners {
    [self setRadius:radius corners:corners size:CGSizeZero];
}
- (void)setRadius:(CGFloat)radius corners:(UIRectCorner)corners size:(CGSize)size {
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
    CGSize size = self.bounds.size;
    if(size.width==0&&size.height==0){
        [self setNeedsLayout];
        [self layoutIfNeeded];
        size = self.bounds.size;
        if(size.width!=0&&size.height!=0){
            path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
        }
    }
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
- (void)setRequiredHorizontal {
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}
- (void)setRequiredVertical {
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

@end
