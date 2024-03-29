//
//  AppDelegate.m
//  TokenWalletProject
//
//  Created by Zinkham on 16/7/7.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import "UserManager.h"
#import "FirstInputViewController.h"
#import "ETHServerMananger.h"
#import "FchainTool.h"
#import "VersionTool.h"

@interface AppDelegate () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIViewController *rootController;
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (!User_manager.currentUser.user_name) {
        [self switchToCreateWalletVC];
    }else{
        self.rootController = [[RootTabBarController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.rootController];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    if (@available(iOS 13.0, *)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
        // Fallback on earlier versions
    }
    [self setConfig];
    [self beginNetwork];
    
    return YES;
}
- (void)beginNetwork {
    self.manager = [AFNetworkReachabilityManager sharedManager];
    [self.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkDisabledNotification object:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [VersionTool requestAppVersion];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkAvailableNotification object:nil];
                break;
            default:
                break;
        }
    }];
    [self.manager startMonitoring];
}
- (void)setConfig{
    [JJException configExceptionCategory:JJExceptionGuardAllExceptZombie];
    [JJException startGuardException];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //设置HUD的Style
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //设置HUD和文本的颜色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];

    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor UIColorWithHexColorString:@"000000" AndAlpha:0.6]];
//    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setMinimumSize:CGSizeMake(kRealValue(100), kRealValue(40))];
}

-(void)switchToTabBarController
{
    if (![self.rootController isKindOfClass:[RootTabBarController class]]) {
        self.rootController = [[RootTabBarController alloc] init];
        self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:self.rootController];
        self.rootNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [self.rootNavigationController.view.layer addAnimation:transition forKey:kCATransition];
        self.window.rootViewController = self.rootNavigationController;
        [self.window makeKeyAndVisible];
    }
}
-(void)switchToCreateWalletVC
{
    if (![self.rootController isKindOfClass:[FirstInputViewController class]]) {
        self.rootController = [[FirstInputViewController alloc] init];
        self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:self.rootController];
        self.rootNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        
        self.window.rootViewController = self.rootNavigationController;
        [self.window makeKeyAndVisible];
    }
}
-(void)switchToWelcomeController
{
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [VersionTool requestAppVersion];
    //touch id
//    if ([SettingManager sharedInstance].isUseTouchID) {
//        TouchIDController *con = [[TouchIDController alloc] init];
//        [self.rootNavigationController pushViewController:con animated:NO];
//    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
