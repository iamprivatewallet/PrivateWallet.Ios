//
//  PW_BaseViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_BaseViewController : UIViewController

@property (nonatomic, strong) NoDataShowView *noDataView;

- (void)makeViews;
- (void)requestData;
- (void)pw_requestApi:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^_Nonnull)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock;
- (void)pw_requestWallet:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^_Nonnull)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock;
- (void)showSuccess:(NSString *)text;
- (void)showError:(NSString *)text;
- (void)showToast:(NSString *)text;
- (void)showMessage:(NSString *)text;
- (void)dismissMessage;

@property (nonatomic, strong) UIImageView *bgIv;
@property (nonatomic, strong) UIView *naviBar;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

- (void)setNavNoLineTitle:(NSString *)title;
- (void)setNavNoLineTitle:(NSString *)title rightTitle:(NSString *)rightTitle rightAction:(SEL)rightAction;
- (void)setNavNoLineTitle:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction;
- (void)setNavNoLineTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightImg:(NSString *)rightImg rightAction:(SEL)rightAction;
//只显示标题
- (void)setNavTitle:(NSString *)title isNoLine:(BOOL)isNoLine;
//自定义左右图片
- (void)setNavTitle:(NSString *)title leftImg:(NSString *)leftImg leftAction:(SEL)leftAction rightImg:(NSString *)rightImg rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine;

@end

NS_ASSUME_NONNULL_END
