//
//  PW_BaseViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"

@interface PW_BaseViewController ()

@end

@implementation PW_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = [UIColor g_darkBgColor];
    [self.view addSubview:self.bgIv];
    [self.bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}
- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleDark;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)makeViews {
    
}
- (void)requestData {
    
}
- (void)pw_requestApi:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^_Nonnull)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock {
    [NetworkTool requestApi:path params:params completeBlock:completeBlock errBlock:errBlock];
}
- (void)pw_requestWallet:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^_Nonnull)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock {
    [NetworkTool requestWallet:path params:params completeBlock:completeBlock errBlock:errBlock];
}
- (void)showSuccess:(NSString *)text {
    [PW_ToastTool showSucees:text];
}
- (void)showError:(NSString *)text {
    [PW_ToastTool showError:text];
}
- (void)showToast:(NSString *)text {//1.5s dismiss
    [[ToastHelper sharedToastHelper] toast:text];
}
- (void)showMessage:(NSString *)text {
    [[ToastHelper sharedToastHelper] showToast:text];
}
- (void)dismissMessage {
    [[ToastHelper sharedToastHelper] dismissToast];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_noDataView) {
        [self.view bringSubviewToFront:_noDataView];
    }
}
- (void)backPrecious {
    if (self.navigationController && self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)setNavNoLineTitle:(NSString *)title {
    if(self.navigationController.viewControllers.count>1){
        [self initBarWithTitle:title leftBtnImg:@"icon_back" leftTitle:nil leftAction:@selector(backPrecious) isNoLine:YES];
    }else{
        [self initBarWithTitle:title leftBtnImg:nil leftTitle:nil leftAction:nil isNoLine:YES];
    }
}
- (void)setNavNoLineTitle:(NSString *)title rightTitle:(NSString *)rightTitle rightAction:(SEL)rightAction {
    if(self.navigationController.viewControllers.count>1){
        [self initBarWithTitle:title leftImg:@"icon_back" leftTitle:nil leftAction:@selector(backPrecious) rightTitle:rightTitle rightImage:nil rightAction:rightAction isNoLine:YES];
    }else{
        [self initBarWithTitle:title leftImg:nil leftTitle:nil leftAction:nil rightTitle:rightTitle rightImage:nil rightAction:rightAction isNoLine:YES];
    }
}
- (void)setNavNoLineTitle:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction {
    if(self.navigationController.viewControllers.count>1){
        [self initBarWithTitle:title leftImg:@"icon_back" leftAction:@selector(backPrecious) rightImage:rightImg rightAction:rightAction isNoLine:YES];
    }else{
        [self initBarWithTitle:title leftImg:nil leftAction:nil rightImage:rightImg rightAction:rightAction isNoLine:YES];
    }
}
- (void)setNavNoLineTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightImg:(NSString *)rightImg rightAction:(SEL)rightAction {
    [self initBarWithTitle:title leftImg:nil leftTitle:leftTitle leftAction:nil rightTitle:nil rightImage:rightImg rightAction:rightAction isNoLine:YES];
}
- (void)setNavTitle:(NSString *)title isNoLine:(BOOL)isNoLine{
    [self initBarWithTitle:title leftBtnImg:nil leftTitle:nil leftAction:nil isNoLine:isNoLine];
}
- (void)setNavTitle:(NSString *)title leftImg:(NSString *)leftImg leftAction:(SEL)leftAction rightImg:(NSString *)rightImg rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine{
    [self initBarWithTitle:title leftImg:leftImg leftAction:leftAction rightImage:rightImg rightAction:rightAction isNoLine:isNoLine];
}
- (void)initBarWithTitle:(NSString *)title leftImg:(NSString *)leftImg leftAction:(SEL)leftAction rightImage:(NSString *)rightImage rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine {
    [self initBarWithTitle:title leftImg:leftImg leftTitle:nil leftAction:leftAction rightTitle:nil rightImage:rightImage rightAction:rightAction isNoLine:isNoLine];
}
-(void)initBarWithTitle:(NSString *)title leftBtnImg:(NSString *)leftImage leftTitle:(NSString *)leftTitle leftAction:(SEL)leftAction isNoLine:(BOOL)isNoLine {
    [self initBarWithTitle:title leftImg:leftImage leftTitle:leftTitle leftAction:leftAction rightTitle:nil rightImage:nil rightAction:nil isNoLine:isNoLine];
}
-(void)initBarWithTitle:(NSString*)title leftImg:(NSString *)leftImage leftTitle:(NSString *)leftTitle leftAction:(SEL)leftAction rightTitle:(NSString *)rightTitle rightImage:(NSString *)rightImage rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine {
    [self.view addSubview:self.naviBar];
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(44 + kStatusBarHeight);
    }];
    if (!isNoLine) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
        [self.naviBar addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.naviBar.mas_bottom).offset(-0.5);
            make.left.right.equalTo(self.naviBar);
            make.height.mas_equalTo(0.5);
        }];
    }
    
//    if (title) {
    _titleLable = [UILabel new];
    [self.naviBar addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.naviBar.mas_bottom).offset(-(44-25)/2);
        make.centerX.equalTo(self.naviBar);
        make.height.mas_equalTo(25);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH*0.75);
    }];
    [UITools setLableProperties:_titleLable withColor:[UIColor g_whiteTextColor] andFont:GCSFontSemibold(16)];
    _titleLable.text = title;
//    }
    
    if (leftImage||[leftTitle isNoEmpty]) {
        _leftBtn = [UIButton new];
        [self.naviBar addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.naviBar).offset(CGFloatScale(10));
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(44);
            make.centerY.equalTo(_titleLable.mas_centerY);
        }];
        if (leftTitle) {
            [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
            [_leftBtn setTitleColor:[UIColor g_textColor] forState:UIControlStateNormal];
            _leftBtn.titleLabel.font = GCSFontRegular(14);
        }else{
            [_leftBtn setImage:ImageNamed(leftImage) forState:UIControlStateNormal];
        }
        if (leftAction) {
            [_leftBtn addTarget:self action:leftAction forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (rightImage||[rightTitle isNoEmpty]) {
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _rightBtn.titleLabel.font = GCSFontRegular(14);
        [_rightBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_rightBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.naviBar addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.naviBar).offset(-CGFloatScale(20));
            make.centerY.equalTo(self.titleLable.mas_centerY);
        }];
        if (rightImage) {
            [_rightBtn setImage:ImageNamed(rightImage) forState:UIControlStateNormal];
            if (!SYSTEM_VERSION_LESS_THAN(@"11")) {
                _rightBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
                [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 * SCREEN_WIDTH/375.0)];
            }
        }
        if (rightTitle) {
            [_rightBtn setTitle:rightTitle forState:UIControlStateNormal];
            [_rightBtn setTitleColor:[UIColor g_textColor] forState:UIControlStateNormal];
        }
        if (rightAction) {
            [_rightBtn addTarget:self action:rightAction forControlEvents:(UIControlEventTouchUpInside)];
        }
    }
}
#pragma make - lazy
- (NoDataShowView *)noDataView {
    if(!_noDataView) {
        _noDataView = [NoDataShowView showView:self.view image:@"icon_noData" text:LocalizedStr(@"text_noData") offsetY:0];
        _noDataView.hidden = YES;
    }
    return _noDataView;
}
- (UIView *)naviBar {
    if (!_naviBar) {
        _naviBar = [[UIView alloc] init];
        _naviBar.backgroundColor = [UIColor clearColor];
    }
    return _naviBar;
}
- (UIImageView *)bgIv {
    if (!_bgIv) {
        _bgIv = [[UIImageView alloc] init];
    }
    return _bgIv;
}

@end
