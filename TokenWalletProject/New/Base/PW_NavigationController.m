//
//  PW_NavigationController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NavigationController.h"

@interface PW_NavigationController ()

@end

@implementation PW_NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:19.f],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor g_bgColor]];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationBar.hidden = YES;
}
- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
