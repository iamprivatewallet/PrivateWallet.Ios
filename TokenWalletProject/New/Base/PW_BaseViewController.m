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
    
}
- (void)showSuccess:(NSString *)text {
    [PW_ToastTool showSucees:text toView:self.view];
}
- (void)showError:(NSString *)text {
    [PW_ToastTool showError:text toView:self.view];
}
- (void)toast:(NSString *)text {//1.5s dismiss
    [[ToastHelper sharedToastHelper] toast:text];
}
- (void)showToast:(NSString *)text {
    [[ToastHelper sharedToastHelper] showToast:text];
}
- (void)dismissToast {
    [[ToastHelper sharedToastHelper] dismissToast];
}

@end
