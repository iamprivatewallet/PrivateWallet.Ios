//
//  UIView+SetRect.m
//  NewProject
//
//  Created by lmondi on 16/9/6.
//  Copyright © 2016年 MD. All rights reserved.
//

#import "UIView+SetRect.h"

@implementation UIView (SetRect)
- (CGPoint)viewOrigin {
    
    return self.frame.origin;
}

- (void)setViewOrigin:(CGPoint)viewOrigin {
    
    CGRect newFrame = self.frame;
    newFrame.origin = viewOrigin;
    self.frame      = newFrame;
}

- (CGSize)viewSize {
    
    return self.frame.size;
}

- (void)setViewSize:(CGSize)viewSize {
    
    CGRect newFrame = self.frame;
    newFrame.size   = viewSize;
    self.frame      = newFrame;
}

- (CGFloat)x {
    
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = x;
    self.frame        = newFrame;
}

- (CGFloat)y {
    
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = y;
    self.frame        = newFrame;
}

- (CGFloat)width {
    
    return CGRectGetWidth(self.bounds);
}

- (void)setWidth:(CGFloat)width {
    
    CGRect newFrame     = self.frame;
    newFrame.size.width = width;
    self.frame          = newFrame;
}

- (CGFloat)height {
    
    return CGRectGetHeight(self.bounds);
}

- (void)setHeight:(CGFloat)height {
    
    CGRect newFrame      = self.frame;
    newFrame.size.height = height;
    self.frame           = newFrame;
}

- (CGFloat)top {
    
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = top;
    self.frame        = newFrame;
}

- (CGFloat)bottom {
    
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)left {
    
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = left;
    self.frame        = newFrame;
}

- (CGFloat)right {
    
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)centerX {
    
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint newCenter = self.center;
    newCenter.x       = centerX;
    self.center       = newCenter;
}

- (CGFloat)centerY {
    
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    
    CGPoint newCenter = self.center;
    newCenter.y       = centerY;
    self.center       = newCenter;
}

- (CGFloat)middleX {
    
    return CGRectGetWidth(self.bounds) / 2.f;
}

- (CGFloat)middleY {
    
    return CGRectGetHeight(self.bounds) / 2.f;
}

- (CGPoint)middlePoint {
    
    return CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
}

-(void)addWholeRound:(CGFloat)width{
    self.layer.cornerRadius = width;
    self.layer.masksToBounds = YES;
}

-(void)addRoundShandow:(CGFloat)width{
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = self.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius=width;
    subLayer.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,5);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 0.2;//阴影透明度，默认0
    subLayer.shadowRadius = 10;//阴影半径，默认3
    [self.superview.layer insertSublayer:subLayer below:self.layer];
}

-(void)removeRoundShandow:(CGFloat)width{
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = self.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius=width;
    subLayer.backgroundColor=[UIColor clearColor].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,5);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 0.2;//阴影透明度，默认0
    subLayer.shadowRadius = 10;//阴影半径，默认3
    [self.superview.layer insertSublayer:subLayer below:self.layer];
}

-(void)addRoundShandowoffset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius circle:(CGFloat)width{
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = CGRectMake(self.x+1, self.y+1, self.width-2, self.height-2);
    subLayer.frame= fixframe;
    subLayer.cornerRadius=width;
    subLayer.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = offset;//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = opacity;//阴影透明度，默认0
    subLayer.shadowRadius = radius ;//阴影半径，默认3
    [self.superview.layer insertSublayer:subLayer below:self.layer];
}


-(void)addGradientLayer:(CGSize )size withColorArr:(NSArray *)colorArr withStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint{
    CAGradientLayer *gradient = [CAGradientLayer layer];
       gradient.frame = CGRectMake(0, 0, size.width, size.height);
       NSMutableArray *arr = [NSMutableArray new];
       for (UIColor *color in colorArr) {
           [arr addObject:(id)color.CGColor];
       }
       gradient.colors = arr;
       gradient.startPoint = startPoint;
       gradient.endPoint = endPoint;
       //    gradient.locations = @[@(0.5f), @(1.0f)];
       if (self.layer.sublayers.count == 0) {
                  [self.layer insertSublayer:gradient atIndex:0];
              } else {
                  for (int i = 0; i < self.layer.sublayers.count; i++) {
                      if ([self.layer.sublayers[i] isKindOfClass:[CAGradientLayer class]]) {
                         NSMutableArray *arrs = [NSMutableArray arrayWithArray:self.layer.sublayers];
                         [arrs replaceObjectAtIndex:i withObject:gradient];
                         self.layer.sublayers = [NSArray arrayWithArray:arrs];
                         break;
                      } else if (i == (self.layer.sublayers.count - 1)) {
                         [self.layer insertSublayer:gradient atIndex:0];
                          break;
                      }
                  }
              }
    [self.layer insertSublayer:gradient atIndex:0];
}


-(void)addGradientLayer:(CGSize )size withColorArr:(NSArray *)colorArr{
    [self addGradientLayer:size withColorArr:colorArr withStartPoint:CGPointMake(0.5, 0) withEndPoint:CGPointMake(0.5, 1)];
}


-(void)addCommonGradientLayer:(CGSize )size{
    [self addGradientLayer:size withColorArr:@[COLORFORRGB(0x292C31),COLORFORRGB(0x191B1E)]];
}

+(UIView *)tipViewWithTitle:(NSString *)title{
    UIView *view =[UIView new];
    UIView *yellowV = [UIView new];
    [view addSubview:yellowV];
    yellowV.backgroundColor = [UIColor monies_heavyYellowColor];
    [yellowV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kRealValue(20));
        make.height.offset(kRealValue(14));
        make.width.offset(kRealValue(5));
        make.bottom.equalTo(view.mas_bottom).offset(kRealValue(-18));
    }];
    
    UILabel *lbl = [UILabel new];
    [view addSubview:lbl];
    lbl.text = title;
    lbl.font = [UIFont boldSystemFontOfSize:kRealValue(16)];
    lbl.textColor = [UIColor monies_blueGrayColor5];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yellowV);
        make.left.equalTo(yellowV.mas_right).offset(kRealValue(10));
    }];
    
    return view;
}
@end
