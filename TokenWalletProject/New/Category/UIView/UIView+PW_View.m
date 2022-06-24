//
//  UIView+PW_View.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import "UIView+PW_View.h"

static void *eventsTapBlockKey = &eventsTapBlockKey;
static void *eventsSwipeBlockKey = &eventsSwipeBlockKey;

@interface UIView ()

@property (nonatomic, copy) PW_ViewBlock tapBlock;
@property (nonatomic, copy) PW_ViewBlock swipeBlock;

@end

@implementation UIView (PW_View)

- (void)addTapTarget:(nullable id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}
- (void)addTapBlock:(PW_ViewBlock)block {
    self.userInteractionEnabled = YES;
    self.tapBlock = block;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__tapAction:)];
    [self addGestureRecognizer:tap];
}
- (void)__tapAction:(UIGestureRecognizer *)gesture {
    if (self.tapBlock) {
        self.tapBlock(self);
    }
}
- (void)setTapBlock:(PW_ViewBlock)tapBlock {
    objc_setAssociatedObject(self, &eventsTapBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
}
- (PW_ViewBlock)tapBlock {
    return objc_getAssociatedObject(self, &eventsTapBlockKey);
}
- (void)addSwipeDirection:(UISwipeGestureRecognizerDirection)direction target:(nullable id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    swipeGesture.direction = direction;
    [self addGestureRecognizer:swipeGesture];
}
- (void)addSwipeDirection:(UISwipeGestureRecognizerDirection)direction block:(PW_ViewBlock)block {
    self.userInteractionEnabled = YES;
    self.swipeBlock = block;
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(__swipeAction:)];
    swipeGesture.direction = direction;
    [self addGestureRecognizer:swipeGesture];
}
- (void)__swipeAction:(UISwipeGestureRecognizer *)gesture {
    if (self.swipeBlock) {
        self.swipeBlock(self);
    }
}
- (void)setSwipeBlock:(PW_ViewBlock)swipeBlock {
    objc_setAssociatedObject(self, &eventsSwipeBlockKey, swipeBlock, OBJC_ASSOCIATION_COPY);
}
- (PW_ViewBlock)swipeBlock {
    return objc_getAssociatedObject(self, &eventsSwipeBlockKey);
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
    self.layer.masksToBounds = YES;
}

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)setShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    [self setShadowColor:color offset:offset radius:radius path:nil];
}
- (void)setShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius path:(nullable UIBezierPath *)path {
    CGSize size = self.bounds.size;
    if (path==nil&&self.superview!=nil) {
        if(size.width==0&&size.height==0){
            [self setNeedsLayout];
            [self layoutIfNeeded];
            size = self.bounds.size;
            if(size.width!=0&&size.height!=0){
                path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
            }
        }else{
            path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
        }
    }
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    if (path) {
        self.layer.shadowPath = path.CGPath;
    }
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
    return [self convertViewToImageBgColor:[UIColor g_bgColor]];
}
- (UIImage *)convertViewToImageBgColor:(UIColor *)bgColor {
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
    [bgColor setFill];
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
