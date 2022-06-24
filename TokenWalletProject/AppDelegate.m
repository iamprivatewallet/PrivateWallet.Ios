//
//  AppDelegate.m
//  TokenWalletProject
//
//  Created by Zinkham on 16/7/7.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "AppDelegate.h"
#import "PW_TabBarViewController.h"
#import "PW_NavigationController.h"
#import "UserManager.h"
#import "ETHServerMananger.h"
#import "FchainTool.h"
#import "VersionTool.h"
#import "PW_FirstChooseViewController.h"
#import "PW_SetUpViewController.h"

@interface AppDelegate () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIViewController *rootController;
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@property (nonatomic, strong) PW_AppAuthLockView *appAuthLockView;
@property (nonatomic, strong) PW_AppPwdLockView *appPwdLockView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [NSThread sleepForTimeInterval:1];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSArray *wallets = [[PW_WalletManager shared] getWallets];
    User *user = User_manager.currentUser;
    if (wallets==nil||wallets.count==0||![user.chooseWallet_address isNoEmpty]) {
        [self switchToCreateWalletVC];
    }else{
        self.rootController = [[PW_TabBarViewController alloc] init];
        self.rootNavigationController = [[PW_NavigationController alloc] initWithRootViewController:self.rootController];
        self.window.rootViewController = self.rootNavigationController;
        [self.window makeKeyAndVisible];
    }
    [self setConfig];
    [self beginNetwork];
    [self setupLockApp];
    
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
    if (@available(iOS 13.0, *)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        [UITextField appearance].overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        [UITextView appearance].overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
        // Fallback on earlier versions
    }
    [PW_SDImageTool setup];
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
    if (![self.rootController isKindOfClass:[PW_TabBarViewController class]]) {
        self.rootController = [[PW_TabBarViewController alloc] init];
        self.rootNavigationController = [[PW_NavigationController alloc] initWithRootViewController:self.rootController];
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
    if (![self.rootController isKindOfClass:[PW_FirstChooseViewController class]]) {
        self.rootController = [[PW_FirstChooseViewController alloc] init];
        self.rootNavigationController = [[PW_NavigationController alloc] initWithRootViewController:self.rootController];
        self.rootNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        
        self.window.rootViewController = self.rootNavigationController;
        [self.window makeKeyAndVisible];
    }
}
- (void)resetTabbarVc {
    self.rootController = [[PW_TabBarViewController alloc] init];
    self.rootNavigationController = [[PW_NavigationController alloc] initWithRootViewController:self.rootController];
    self.window.rootViewController = self.rootNavigationController;
    [self.window makeKeyAndVisible];
}
- (void)resetCreateWalletVc {
    self.rootController = [[PW_FirstChooseViewController alloc] init];
    self.rootNavigationController = [[PW_NavigationController alloc] initWithRootViewController:self.rootController];
    self.window.rootViewController = self.rootNavigationController;
    [self.window makeKeyAndVisible];
}
- (void)resetApp {
    if ([User_manager.currentUser.user_name isNoEmpty]) {
        [self resetTabbarVc];
        if([self.rootController isKindOfClass:[UITabBarController class]]){
            ((UITabBarController *)self.rootController).selectedIndex = 3;
        }
        [self.rootNavigationController pushViewController:[PW_SetUpViewController new] animated:NO];
    }else{
        [self resetCreateWalletVc];
    }
}
- (void)setupLockApp {
    [RACObserve(self, appIsBackground) subscribeNext:^(NSNumber * _Nullable x) {
        if ([PW_LockTool getUnlockAppTransaction]) {
            [self.window addSubview:self.appAuthLockView];
            [self.appAuthLockView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.offset(0);
            }];
            if (x.boolValue) {
                [self.appAuthLockView reset];
            }else{
                [self.appAuthLockView start];
            }
        }else if([PW_LockTool getOpenUnlockPwd]) {//密码解锁
            [self.window addSubview:self.appPwdLockView];
            [self.appPwdLockView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.offset(0);
            }];
            if (x.boolValue) {
                [self.appPwdLockView reset];
            }else{
                [self.appPwdLockView start];
            }
        }
    }];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.appIsBackground = YES;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [VersionTool requestAppVersion];
    self.appIsBackground = NO;
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

#pragma mark - lazy
- (PW_AppAuthLockView *)appAuthLockView {
    if (!_appAuthLockView) {
        _appAuthLockView = [[PW_AppAuthLockView alloc] init];
        _appAuthLockView.completeBlock = ^(PW_AppAuthLockView * _Nonnull view, BOOL success) {
            if (success) {
                [view removeFromSuperview];
            }
        };
    }
    return _appAuthLockView;
}
- (PW_AppPwdLockView *)appPwdLockView {
    if (!_appPwdLockView) {
        _appPwdLockView = [[PW_AppPwdLockView alloc] init];
        _appPwdLockView.completeBlock = ^(PW_AppPwdLockView * _Nonnull view, BOOL success) {
            if (success) {
                [view removeFromSuperview];
            }
        };
    }
    return _appPwdLockView;
}

@end
