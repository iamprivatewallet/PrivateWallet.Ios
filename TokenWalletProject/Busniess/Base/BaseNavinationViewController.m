//
//  BaseNavinationViewController.m
//  AegisCargo
//
//  Created by Terry.c on 21/11/2017.
//  Copyright © 2017 Aegis. All rights reserved.
//

#import "BaseNavinationViewController.h"

@interface BaseNavinationViewController ()

@end

@implementation BaseNavinationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:19.f],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setBarTintColor:_AG_COLOR_MAIN_1];
    
    [self setNeedsStatusBarAppearanceUpdate];
}
- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController navBtn:(BOOL)navBtn
{
    if (self = [super initWithRootViewController:rootViewController]) {
//        if (!navBtn) {
//            self.fd_prefersNavigationBarHidden = YES;
//        }
    }
    return self;
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

//- (void)showMenu
//{
//    // Dismiss keyboard (optional)
//    //
//    [self.view endEditing:YES];
//    [self.frostedViewController.view endEditing:YES];
//
//    // Present the view controller
//    //
//    [self.frostedViewController presentMenuViewController];
//}
//
//#pragma mark -
//#pragma mark Gesture recognizer
//
//- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
//{
//    // Dismiss keyboard (optional)
//    //
//    [self.view endEditing:YES];
//    [self.frostedViewController.view endEditing:YES];
//
//    // Present the view controller
//    //
//    [self.frostedViewController panGestureRecognized:sender];
//}

@end
