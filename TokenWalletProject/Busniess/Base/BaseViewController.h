//
//  BaseViewController.h
//  Traffic
//
//  Created by Terry.c on 30/03/2017.
//  Copyright © 2017 Terry.c. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

//modify navi bar height
//https://gist.github.com/maciekish/c2c903d9b7e7b583b4b2
@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIView *naviBar;

@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

- (void)requestApi:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock;

- (UIImage*)compressImage:(UIImage*)sourceImage toTargetWidth:(CGFloat)targetWidth;

-(void)hideDivider;

-(void)backPrecious;

-(void)jumpToViewController:(Class)aclass;

-(void)setStatusBarBackgroundColor:(UIColor *)color;

-(void)addNoListToView:(UIView *)view;

-(void)addNoContentToView:(UIView *)view;

-(void)addNetworkErrow;

-(void)starTimer;

-(void)startTimerWithTimeInterval:(CGFloat)time;

-(void)stopTimer;

-(void)timeCountMethod:(NSTimer *)timer;

-(void)requestBusiness:( void (^)(id results, NSError *error) )completion;


-(void)initTitleBarWithLeftBtnImg:(UIImage*)image leftAction:(SEL)leftAction title:(NSString*)title isNoLine:(BOOL)isNoLine;

- (void)setupWhiteNavBarTint;
- (void)setNavNoLineTitle:(NSString *)title;
- (void)setNavNoLineTitle:(NSString *)title isWhiteBg:(BOOL)isWhiteBg;
- (void)setNavNoLineTitle:(NSString *)title rightTitle:(NSString *)rightTitle rightAction:(SEL)rightAction;
- (void)setNavNoLineTitle:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction;
- (void)setNavNoLineTitle:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction isWhiteBg:(BOOL)isWhiteBg;
- (void)setNavNoLineTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightImg:(NSString *)rightImg rightAction:(SEL)rightAction;
//只显示标题
- (void)setNavTitle:(NSString *)title isNoLine:(BOOL)isNoLine;

- (void)setNavTitle:(NSString *)title isNoLine:(BOOL)isNoLine isWhiteBg:(BOOL)isWhiteBg;

//带返回按钮 加导航线
- (void)setNavTitleWithLeftItem:(NSString *)title;
- (void)setNav_NoLine_WithLeftItem:(NSString *)title isWhiteBg:(BOOL)isWhiteBg;
//带返回按钮 不加加导航线
- (void)setNav_NoLine_WithLeftItem:(NSString *)title;
//带返回按钮 右边加图片
- (void)setNavTitle:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction;
//带返回按钮 右边加图片 加导航线
- (void)setNavTitleWithLeftItem:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction;
//带返回按钮 右边加图片 不加加导航线
- (void)setNav_NoLine_WithLeftItem:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction;
//自定义左右图片
- (void)setNavTitle:(NSString *)title leftImg:(NSString *)leftImg leftAction:(SEL)leftAction rightImg:(NSString *)rightImg  rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine;
- (void)setNavTitle:(NSString *)title leftImg:(NSString *)leftImg leftAction:(SEL)leftAction rightImg:(NSString *)rightImg  rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine isWhiteBg:(BOOL)isWhiteBg;
//自定义右边文字
- (void)setNavTitleWithLeftItem:(NSString *)title rightTitle:(NSString *)rightTitle rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine;
//自定义左右文字
- (void)setNavTitle:(NSString *)title leftTitle:(NSString *)leftTitle leftAction:(SEL)leftAction rightTitle:(NSString *)rightTitle  rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine;

- (void)setNavTitle_whiteStype:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction bgColor:(UIColor *)bgColor;

- (void)initWithRightTitle:(NSString*)rightTitle rightAction:(SEL)rightAction;
/**
 刷新方法 子类继承
 */
- (void)refresh;

/**
 是否相等

 @param vc vc
 @return bool
 */
- (BOOL)isEqualToVc:(BaseViewController *)vc;

- (void)showSuccessMessage:(NSString *)message;
- (void)showFailMessage:(NSString *)message;
- (void)showToastMessage:(NSString *)message;

- (void)addNavTitleView:(UIView *)view;

- (void)showAlertViewWithText:(NSString *)text action:(void(^)(NSInteger index))alertAction;

- (void)showAlertViewWithText:(NSString *)text actionText:(NSString *)actionText;

- (void)showAlertViewWithTitle:(NSString *)title text:(NSString *)text actionText:(NSString *)actionText;

@end

