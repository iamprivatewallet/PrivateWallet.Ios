//
//  UIView+SetRect.h
//  NewProject
//
//  Created by lmondi on 16/9/6.
//  Copyright © 2016年 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SetRect)

/*----------------------
 * Absolute coordinate *
 ----------------------*/

@property (nonatomic) CGPoint viewOrigin;
@property (nonatomic) CGSize  viewSize;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

/*----------------------
 * Relative coordinate *
 ----------------------*/

@property (nonatomic, readonly) CGFloat middleX;
@property (nonatomic, readonly) CGFloat middleY;
@property (nonatomic, readonly) CGPoint middlePoint;

-(void)addWholeRound:(CGFloat)width;
-(void)addRoundShandow:(CGFloat)width;
-(void)addRoundShandowoffset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius circle:(CGFloat)width;

-(void)addGradientLayer:(CGSize )size withColorArr:(NSArray *)colorArr withStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint;
-(void)addCommonGradientLayer:(CGSize )size;
-(void)addGradientLayer:(CGSize )size withColorArr:(NSArray *)colorArr;
+(UIView *)tipViewWithTitle:(NSString *)title;
@end
