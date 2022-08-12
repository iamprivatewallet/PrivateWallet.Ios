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
    self.view.backgroundColor = [UIColor g_bgColor];
    [self.view insertSubview:self.bgIv atIndex:0];
    [self.bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
    }];
}
- (void)dealloc {
    NSLog(@"%@-dealloc",self);
}
- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleDark;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)setupFullBackground {
    self.bgIv.image = [UIImage imageNamed:@"icon_bg"];
    [self.bgIv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}
- (void)setupNavBgBlack {
    self.bgIv.image = [UIImage imageNamed:@"icon_nav_black"];
}
- (void)setupNavBgRed {
    self.bgIv.image = [UIImage imageNamed:@"icon_nav_red"];
}
- (void)setupNavBgGreen {
    self.bgIv.image = [UIImage imageNamed:@"icon_nav_green"];
}
- (void)setupNavBgPurple {
    self.bgIv.image = [UIImage imageNamed:@"icon_nav_purple"];
}
- (void)setupNavBgBlue {
    self.bgIv.image = [UIImage imageNamed:@"icon_nav_blue"];
}
- (void)clearBackground {
    [self.bgIv removeFromSuperview];
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
- (void)pw_requestNFTApi:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^_Nonnull)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock {
    [NetworkTool requestNFTApi:path params:params completeBlock:completeBlock errBlock:errBlock];
}
- (void)showSuccess:(NSString *)text {
    [PW_ToastTool showSucees:text toView:self.view];
}
- (void)showError:(NSString *)text {
    [PW_ToastTool showError:text toView:self.view];
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
- (void)showLoading {
//    [SVProgressHUD show];
    [self.view showLoadingIndicator];
}
- (void)dismissLoading {
//    [SVProgressHUD dismiss];
    [self.view hideLoadingIndicator];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_navBar) {
        [self.view bringSubviewToFront:_navBar];
    }
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
- (void)setNavTitleNoLeft:(NSString *)title isNoLine:(BOOL)isNoLine{
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
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(PW_NavStatusHeight);
    }];
    if (!isNoLine) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
        [self.navContentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.mas_equalTo(0.5);
        }];
    }
//    if (title) {
    [self.navContentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navContentView);
        make.height.mas_equalTo(25);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH*0.75);
    }];
    self.titleLabel.text = title;
//    }
    
    if (leftImage||[leftTitle isNoEmpty]) {
        _leftBtn = [UIButton new];
        [self.navContentView addSubview:_leftBtn];
        if (leftTitle) {
            [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
            [_leftBtn setTitleColor:[UIColor g_whiteTextColor] forState:UIControlStateNormal];
            _leftBtn.titleLabel.font = [UIFont pw_mediumFontOfSize:20];
            [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(CGFloatScale(18));
                make.height.mas_equalTo(44);
                make.centerY.equalTo(self.titleLabel.mas_centerY);
            }];
        }else{
            [_leftBtn setImage:ImageNamed(leftImage) forState:UIControlStateNormal];
            [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(CGFloatScale(10));
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(44);
                make.centerY.equalTo(_titleLabel.mas_centerY);
            }];
        }
        if (leftAction) {
            [_leftBtn addTarget:self action:leftAction forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (rightImage||[rightTitle isNoEmpty]) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.titleLabel.font = [UIFont pw_mediumFontOfSize:15];
        [_rightBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_rightBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.navContentView addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-CGFloatScale(20));
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
        if (rightImage) {
            [_rightBtn setImage:ImageNamed(rightImage) forState:UIControlStateNormal];
            _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,-5)];
        }
        if (rightTitle) {
            [_rightBtn setTitle:rightTitle forState:UIControlStateNormal];
            [_rightBtn setTitleColor:[UIColor g_whiteTextColor] forState:UIControlStateNormal];
        }
        if (rightAction) {
            [_rightBtn addTarget:self action:rightAction forControlEvents:(UIControlEventTouchUpInside)];
        }
    }
}
#pragma make - lazy
- (PW_NoDataView *)noDataView {
    if(!_noDataView) {
        _noDataView = [PW_NoDataView showView:self.view offsetY:0];
        _noDataView.hidden = YES;
    }
    return _noDataView;
}
- (UIView *)navBar {
    if (!_navBar) {
        _navBar = [[UIView alloc] init];
        _navBar.backgroundColor = [UIColor clearColor];
        [_navBar addSubview:self.navContentView];
        [self.navContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.mas_equalTo(44);
        }];
    }
    return _navBar;
}
- (UIView *)navContentView {
    if (!_navContentView) {
        _navContentView = [[UIView alloc] init];
        _navContentView.backgroundColor = [UIColor clearColor];
    }
    return _navContentView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont pw_mediumFontOfSize:20];
        [_titleLabel setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 3) radius:8];
    }
    return _titleLabel;
}
- (UIImageView *)bgIv {
    if (!_bgIv) {
        _bgIv = [[UIImageView alloc] init];
        _bgIv.image = [UIImage imageNamed:@"icon_nav_black_big"];
        _bgIv.contentMode = UIViewContentModeScaleAspectFill;
        _bgIv.clipsToBounds = YES;
    }
    return _bgIv;
}

@end
