//
//  BaseViewController.m
//  Traffic
//
//  Created by Terry.c on 30/03/2017.
//  Copyright © 2017 Terry.c. All rights reserved.
//

#import "BaseViewController.h"
#import "TokenMessageView.h"
#import "NetworkTool.h"
#define NAV_BACKCOLOR [UIColor navAndTabBackColor]

@interface BaseViewController ()
@property(nonatomic ,strong)UIView *networkErrorView;
@property(nonatomic ,strong)UIImageView *noListImagV;
@property(nonatomic ,strong)UILabel *noListLbl;
@property(nonatomic ,strong)NSTimer *timer;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.fd_interactivePopDisabled = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = [UIColor g_bgColor];
}
- (void)requestApi:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^_Nonnull)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock {
    [NetworkTool requestApi:path params:params completeBlock:completeBlock errBlock:errBlock];
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)setNavNoLineTitle:(NSString *)title {
    if(self.navigationController.viewControllers.count>1){
        [self initTitleBarWithLeftBtnImg:IMAGE(@"icon_back") leftTitle:nil leftAction:@selector(backPrecious)  title:title isNoLine:YES isWhiteBg:YES];
    }else{
        [self initTitleBarWithLeftBtnImg:nil leftTitle:nil leftAction:nil title:title isNoLine:YES isWhiteBg:NO];
    }
}
- (void)setNavNoLineTitle:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction {
    [self initTitleWithTitle:title leftImg:IMAGE(@"icon_back") leftAction:@selector(backPrecious) rightImage:rightImg rightAction:rightAction isNoLine:YES];
}
- (void)setNavTitle:(NSString *)title isNoLine:(BOOL)isNoLine{
    [self initTitleBarWithLeftBtnImg:nil leftTitle:nil leftAction:nil  title:title isNoLine:isNoLine isWhiteBg:NO];
}

- (void)setNavTitle:(NSString *)title isNoLine:(BOOL)isNoLine isWhiteBg:(BOOL)isWhiteBg{
    [self initTitleBarWithLeftBtnImg:nil leftTitle:nil leftAction:nil  title:title isNoLine:isNoLine isWhiteBg:isWhiteBg];
}

- (void)setNavTitleWithLeftItem:(NSString *)title {
    [self initTitleBarWithLeftBtnImg:IMAGE(@"icon_back") leftTitle:nil leftAction:@selector(backPrecious)  title:title isNoLine:NO isWhiteBg:NO];
}
- (void)setNav_NoLine_WithLeftItem:(NSString *)title isWhiteBg:(BOOL)isWhiteBg{
    [self initTitleBarWithLeftBtnImg:IMAGE(@"icon_back") leftTitle:nil leftAction:@selector(backPrecious)  title:title isNoLine:YES isWhiteBg:isWhiteBg];

}
- (void)setNav_NoLine_WithLeftItem:(NSString *)title {
    [self initTitleBarWithLeftBtnImg:IMAGE(@"icon_back") leftTitle:nil leftAction:@selector(backPrecious)  title:title isNoLine:YES isWhiteBg:NO];
}

- (void)setNavTitle:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction{
    [self initTitleWithTitle:title rightImage:rightImg rightTitle:nil rightAction:rightAction isNoLine:NO];
}
- (void)setNavTitleWithLeftItem:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction{
    [self initTitleWithTitle:title leftImg:IMAGE(@"icon_back") leftAction:@selector(backPrecious) rightImage:rightImg rightAction:rightAction isNoLine:NO];
}
- (void)setNav_NoLine_WithLeftItem:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction{
    [self initTitleWithTitle:title leftImg:IMAGE(@"icon_back") leftAction:@selector(backPrecious) rightImage:rightImg rightAction:rightAction isNoLine:YES];
}
- (void)setNavTitle:(NSString *)title leftImg:(NSString *)leftImg leftAction:(SEL)leftAction rightImg:(NSString *)rightImg  rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine{
    [self initTitleWithTitle:title leftImg:IMAGE(leftImg) leftAction:leftAction rightImage:rightImg rightAction:rightAction isNoLine:isNoLine];
}
- (void)setNavTitle:(NSString *)title leftImg:(NSString *)leftImg leftAction:(SEL)leftAction rightImg:(NSString *)rightImg  rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine isWhiteBg:(BOOL)isWhiteBg {
    [self initTitleWithTitle:title leftImg:IMAGE(leftImg) leftAction:leftAction rightImage:rightImg rightAction:rightAction isNoLine:isNoLine isWhiteBg:isWhiteBg];
}
- (void)setNavTitleWithLeftItem:(NSString *)title rightTitle:(NSString *)rightTitle rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine{    
    [self initBarWithTitle:title leftImg:IMAGE(@"icon_back") leftTitle:nil leftAction:@selector(backPrecious) rightTitle:rightTitle rightImage:nil rightAction:rightAction bgColor:[UIColor navAndTabBackColor] isWhiteStyle:NO isNoLine:isNoLine];
}
- (void)setNavTitle:(NSString *)title leftTitle:(NSString *)leftTitle leftAction:(SEL)leftAction rightTitle:(NSString *)rightTitle  rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine{
    [self initTitle:title leftTitle:leftTitle leftAction:leftAction rightTitle:rightTitle rightAction:rightAction isNoLine:isNoLine];
}

- (void)setNavTitle_whiteStype:(NSString *)title rightImg:(NSString *)rightImg rightAction:(SEL)rightAction bgColor:(UIColor *)bgColor{
    [self initBarWithTitle:title leftImg:ImageNamed(@"backWhite") leftTitle:nil leftAction:@selector(backPrecious) rightTitle:nil rightImage:rightImg rightAction:rightAction bgColor:bgColor isWhiteStyle:YES isNoLine:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)jumpToViewController:(Class)aclass {
    for(UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:aclass]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void)backPrecious {
    if (self.navigationController &&self.navigationController.viewControllers.count!=1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)initWithRightTitle:(NSString*)rightTitle rightAction:(SEL)rightAction{
    _naviBar = [UIView new];
    _naviBar.backgroundColor = [UIColor navAndTabBackColor];
   
    [self.view addSubview:_naviBar];
    [_naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(44 + kStatusBarHeight);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    [_naviBar addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_naviBar.mas_bottom).offset(-0.5);
        make.left.right.equalTo(_naviBar);
        make.height.mas_equalTo(0.5);
    }];
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    _rightBtn.titleLabel.font = GCSFontRegular(16);
    [_rightBtn setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
    [_rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    [_rightBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_rightBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_rightBtn addTarget:self action:rightAction forControlEvents:(UIControlEventTouchUpInside)];
    [_naviBar addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_naviBar).offset(-CGFloatScale(20));
        make.bottom.equalTo(_naviBar).offset(-5);
    }];
}
-(void)initTitleBarWithLeftBtnImg:(UIImage*)image leftTitle:(NSString *)leftTitle leftAction:(SEL)leftAction title:(NSString*)title isNoLine:(BOOL)isNoLine isWhiteBg:(BOOL)isWhiteBg{
    _naviBar = [UIView new];
    if (isWhiteBg) {
        _naviBar.backgroundColor = [UIColor g_bgColor];
    }else{
        _naviBar.backgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:_naviBar];
    [_naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(44 + kStatusBarHeight);
    }];
    if (!isNoLine) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
        [_naviBar addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_naviBar.mas_bottom).offset(-0.5);
            make.left.right.equalTo(_naviBar);
            make.height.mas_equalTo(0.5);
        }];
    }
    
//    if (title) {
    _titleLable = [UILabel new];
    [_naviBar addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_naviBar).offset(kStatusBarHeight + (44-25)/2);
        make.centerX.equalTo(_naviBar);
        make.height.mas_equalTo(25);
    }];
    [UITools setLableProperties:_titleLable withColor:[UIColor g_boldTextColor] andFont:GCSFontSemibold(16)];
    _titleLable.text = title;
//    }
    
    if (leftAction) {
        _leftBtn = [UIButton new];
        [_naviBar addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_naviBar).offset(CGFloatScale(20));
            make.centerY.equalTo(_titleLable.mas_centerY);
        }];
        if (leftTitle) {
            [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
            [_leftBtn setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
            _leftBtn.titleLabel.font = GCSFontRegular(14);
        }else{
            [_leftBtn setImage:image forState:UIControlStateNormal];
        }
        [_leftBtn addTarget:self action:leftAction forControlEvents:UIControlEventTouchUpInside];
        
    }
}
-(void)initBarWithTitle:(NSString*)title leftImg:(UIImage*)image leftTitle:(NSString *)leftTitle leftAction:(SEL)leftAction rightTitle:(NSString *)rightTitle rightImage:(NSString *)rightImage rightAction:(SEL)rightAction bgColor:(UIColor *)bgColor isWhiteStyle:(BOOL)isWhiteStyle isNoLine:(BOOL)isNoLine {
    
    _naviBar = [UIView new];
    _naviBar.backgroundColor = bgColor;
   
    [self.view addSubview:_naviBar];
    [_naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(44 + kStatusBarHeight);
    }];
    if (!isNoLine) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
        [_naviBar addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_naviBar.mas_bottom).offset(-0.5);
            make.left.right.equalTo(_naviBar);
            make.height.mas_equalTo(0.5);
        }];
    }
    
//    if (title) {
    _titleLable = [UILabel new];
    [_naviBar addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_naviBar.mas_bottom).offset(-(44-25)/2);
        make.centerX.equalTo(_naviBar);
        make.height.mas_equalTo(25);
    }];
    [UITools setLableProperties:_titleLable withColor:[UIColor g_boldTextColor] andFont:GCSFontSemibold(16)];
    _titleLable.text = title;
//    }
    
    if (leftAction) {
      _leftBtn = [UIButton new];
      [_naviBar addSubview:_leftBtn];
      [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(_naviBar).offset(CGFloatScale(20));
          make.centerY.equalTo(_titleLable.mas_centerY);
      }];
        if (leftTitle) {
            [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
            [_leftBtn setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
            _leftBtn.titleLabel.font = GCSFontRegular(14);
        }else{
            [_leftBtn setImage:image forState:UIControlStateNormal];
        }
      [_leftBtn addTarget:self action:leftAction forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (rightAction) {
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _rightBtn.titleLabel.font = GCSFontRegular(14);
        [_rightBtn addTarget:self action:rightAction forControlEvents:(UIControlEventTouchUpInside)];
        [_rightBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_rightBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_naviBar addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_naviBar).offset(-CGFloatScale(20));
            make.centerY.equalTo(self.titleLable.mas_centerY);
        }];
    }
    
    if (rightImage) {
        [_rightBtn setImage:ImageNamed(rightImage) forState:UIControlStateNormal];
        if (!SYSTEM_VERSION_LESS_THAN(@"11")) {
            _rightBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
            [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 * SCREEN_WIDTH/375.0)];
        }
    }
    if (rightTitle) {
        [_rightBtn setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
        [_rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    }
}
- (void)initTitle:(NSString *)title leftTitle:(NSString *)leftTitle leftAction:(SEL)leftAction rightTitle:(NSString *)rightTitle rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine{
    [self initTitleBarWithLeftBtnImg:nil leftTitle:leftTitle leftAction:leftAction  title:title isNoLine:isNoLine isWhiteBg:NO];
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [_rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = GCSFontRegular(14);
    [_rightBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_rightBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_rightBtn addTarget:self action:rightAction forControlEvents:(UIControlEventTouchUpInside)];
    [_naviBar addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_naviBar).offset(-CGFloatScale(20));
        make.centerY.equalTo(self.titleLable.mas_centerY);
    }];
}

- (void)initTitleWithTitle:(NSString *)title rightImage:(NSString *)rightImage rightTitle:(NSString *)rightTitle rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine{
    [self initTitleBarWithLeftBtnImg:nil leftTitle:nil leftAction:nil  title:title isNoLine:isNoLine isWhiteBg:NO];
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    if (rightImage) {
        [_rightBtn setImage:ImageNamed(rightImage) forState:UIControlStateNormal];
        if (!SYSTEM_VERSION_LESS_THAN(@"11")) {
            _rightBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
            [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 * SCREEN_WIDTH/375.0)];
        }
    }
    if (rightTitle) {
        [_rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = GCSFontRegular(14);
    }
    [_rightBtn addTarget:self action:rightAction forControlEvents:(UIControlEventTouchUpInside)];
    
    [_naviBar addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_naviBar).offset(-CGFloatScale(20));
        make.centerY.equalTo(self.titleLable.mas_centerY);
    }];
}

- (void)initTitleWithTitle:(NSString *)title leftImg:(UIImage*)leftImg leftAction:(SEL)leftAction rightImage:(NSString *)rightImage rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine{
    [self initTitleWithTitle:title leftImg:leftImg leftAction:leftAction rightImage:rightImage rightAction:rightAction isNoLine:isNoLine isWhiteBg:YES];
}
- (void)initTitleWithTitle:(NSString *)title leftImg:(UIImage*)leftImg leftAction:(SEL)leftAction rightImage:(NSString *)rightImage rightAction:(SEL)rightAction isNoLine:(BOOL)isNoLine isWhiteBg:(BOOL)isWhiteBg {
    [self initTitleBarWithLeftBtnImg:leftImg leftTitle:nil leftAction:leftAction title:title isNoLine:isNoLine isWhiteBg:isWhiteBg];
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [_rightBtn setImage:ImageNamed(rightImage) forState:UIControlStateNormal];
    [_rightBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_rightBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_rightBtn addTarget:self action:rightAction forControlEvents:(UIControlEventTouchUpInside)];
    if (!SYSTEM_VERSION_LESS_THAN(@"11")) {
        _rightBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 * SCREEN_WIDTH/375.0)];
    }
    [_naviBar addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_naviBar).offset(-CGFloatScale(20));
        make.centerY.equalTo(self.titleLable.mas_centerY);
    }];
}

-(void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (UIImage*)compressImage:(UIImage*)sourceImage toTargetWidth:(CGFloat)targetWidth {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0, targetWidth, targetHeight)];
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


-(void)requestBusiness:( void (^)(id results, NSError *error) )completion{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"requesting", nil)];
    [[MPHttpClient shareClient]postInfo:PCM_PBCIS_DO requestArgument:@{@"coin_id":@"MSC"} completion:completion];
}

//-(UIView *)networkErrorView{
//    if (!_networkErrorView) {
//        _networkErrorView = [ZZCustomView viewInitWithFrame:CGRectZero view:self.view bgColor:[UIColor whiteColor]];
//        [_networkErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
//            if (self.naviBar) {
//                make.top.equalTo(self.naviBar.mas_bottom);
//            }else{
//                make.top.equalTo(self.view);
//            }
//            make.left.right.bottom.equalTo(self.view);
//        }];
//        UIImageView *imageV = [ZZCustomView imageViewInitView:_networkErrorView image:IMAGE(@"network_error")];
//        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.offset(63);
//            make.centerX.equalTo(_networkErrorView.mas_centerX);
//        }];
//        
//        YYLabel *lbl = [YYLabel new];
//        [_networkErrorView addSubview:lbl];
//        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(imageV.mas_bottom).offset(kRealValue(43));
//            make.height.mas_equalTo(kRealValue(20));
//            make.centerX.equalTo(_networkErrorView.mas_centerX);
//        }];
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"网络请求异常，请重试"];
//        [text setTextHighlightRange:NSMakeRange(text.length-2, 2)
//                                 color:[UIColor mp_blueColor]
//                       backgroundColor:[UIColor whiteColor]
//                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
//            [self requestData];
//                             }];
//        [text setColor:[UIColor mp_blueGrayColor] range:NSMakeRange(0, text.length-2)];
//        [text setFont:[UIFont systemFontOfSize:kRealValue(14)]];
//        lbl.attributedText = text;
//    }
//    
//    return _networkErrorView;
//}


-(void)addNoListToView:(UIView *)view{
    if (!_noListImagV) {
         _noListImagV = [ZZCustomView imageViewInitView:nil image:IMAGE(@"home_notice_empty")];
    }
    if (!_noListLbl) {
        _noListLbl = [ZZCustomView labelInitWithView:nil text:NSLocalizedString(@"no_more_news", nil) textColor:[UIColor mp_blueGrayColor] font:[UIFont systemFontOfSize:kRealValue(14)] textAlignment:NSTextAlignmentCenter];
    }
    if (![view.subviews containsObject:_noListLbl]) {
        [view addSubview:_noListLbl];
    }
    if (![view.subviews containsObject:_noListImagV]) {
        [view addSubview:_noListImagV];
    }
   
    
    
}

-(void)addNetworkErrow{
    [self.view addSubview:self.networkErrorView];
}


-(UINavigationController *)navigationController{
    if (super.navigationController) {
        return super.navigationController;
    }
    return [MPTools appRootViewController];
}

-(void)starTimer
{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCountMethod:) userInfo:nil repeats:YES];
   
    
}

-(void)startTimerWithTimeInterval:(CGFloat)time{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timeCountMethod:) userInfo:nil repeats:YES];
}

-(void)timeCountMethod:(NSTimer *)timer{
    [self stopTimer];
}

-(void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)dealloc {
    NSLog(@"%@ dealloc is called", NSStringFromClass(self.class));
}

- (void)refresh{
    
}

- (BOOL)isEqualToVc:(BaseViewController *)vc{
    BOOL eq = NO;
    if ([self isKindOfClass:[vc class]]) {
        eq = YES;
    }
    return eq;
}

- (void)showAlertViewWithText:(NSString *)text action:(void(^)(NSInteger index))alertAction{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:text preferredStyle:UIAlertControllerStyleAlert];
    //2.1 确认按钮
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        alertAction(1);
    }];
    //2.2 取消按钮
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        alertAction(0);
    }];
    [alert addAction:conform];
    [alert addAction:cancel];
    
    //4.显示弹框
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)showAlertViewWithText:(NSString *)text actionText:(NSString *)actionText{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:text preferredStyle:UIAlertControllerStyleAlert];
    //2.1 确认按钮
    UIAlertAction *conform = [UIAlertAction actionWithTitle:actionText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:conform];
    
    //4.显示弹框
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)showAlertViewWithTitle:(NSString *)title text:(NSString *)text actionText:(NSString *)actionText{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    //2.1 确认按钮
    UIAlertAction *conform = [UIAlertAction actionWithTitle:actionText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:conform];
    
    //4.显示弹框
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)showSuccessMessage:(NSString *)message{
    [TokenMessageView showMessageWithText:message imageName:@"succeed"];
}
- (void)showFailMessage:(NSString *)message{
    [TokenMessageView showMessageWithText:message imageName:@"registerFail"];
}
- (void)showToastMessage:(NSString *)message{
    [UITools showToast:message];
}

- (void)addNavTitleView:(UIView *)view{
    if (_naviBar) {
        [_naviBar addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(_naviBar);
            make.width.mas_equalTo(200);
            make.height.equalTo(_naviBar);
        }];
    }
}

@end

