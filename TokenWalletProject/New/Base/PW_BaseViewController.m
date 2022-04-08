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
}
- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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

#pragma make - lazy
- (NoDataShowView *)noDataView {
    if(!_noDataView) {
        _noDataView = [NoDataShowView showView:self.view image:@"icon_noData" text:LocalizedStr(@"text_noData") offsetY:0];
    }
    return _noDataView;
}

@end
