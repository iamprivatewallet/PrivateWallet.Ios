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
    return UIUserInterfaceStyleDark;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
