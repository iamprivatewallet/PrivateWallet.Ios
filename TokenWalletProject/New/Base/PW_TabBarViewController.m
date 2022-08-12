//
//  PW_TabBarViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TabBarViewController.h"
#import "PW_WalletViewController.h"
#import "PW_MarketViewController.h"
#import "PW_NFTViewController.h"
#import "PW_DappViewController.h"
#import "PW_MoreViewController.h"
#import "PW_NavigationController.h"

@interface PW_TabBarViewController () <UITabBarControllerDelegate>

@end

@implementation PW_TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.tabBar.translucent = NO;
    UIImage *image = [UIImage pw_imageGradientSize:CGSizeMake(SCREEN_WIDTH, self.tabBar.frame.size.height) gradientColors:@[[UIColor g_darkGradientStartColor],[UIColor g_darkGradientEndColor]] gradientType:PW_GradientLeftToRight];
    UIColor *bgColor = [UIColor colorWithPatternImage:image];
    self.tabBar.backgroundColor = bgColor;
    [self.tabBar setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, -3) radius:8];
    self.tabBar.barTintColor = bgColor;
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    line.backgroundColor = [UIColor g_lineColor];
//    [self.tabBar addSubview:line];
    [self setupTab];
}
- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleDark;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)setupTab {
    PW_WalletViewController *walletVc = [PW_WalletViewController new];
    PW_NavigationController *walletNac = [[PW_NavigationController alloc] initWithRootViewController:walletVc];
    walletNac.tabBarItem = [self tabbarItemTitle:LocalizedStr(@"tabbar_wallet") imageNamed:@"icon_tabbar_wallet"];
    
    PW_MarketViewController *marketVc = [PW_MarketViewController new];
    PW_NavigationController *marketNac = [[PW_NavigationController alloc] initWithRootViewController:marketVc];
    marketNac.tabBarItem = [self tabbarItemTitle:LocalizedStr(@"tabbar_market") imageNamed:@"icon_tabbar_market"];
    
    PW_NFTViewController *nftVc = [PW_NFTViewController new];
    PW_NavigationController *ntfNac = [[PW_NavigationController alloc] initWithRootViewController:nftVc];
    ntfNac.tabBarItem = [self tabbarItemTitle:@"NFT" imageNamed:@"icon_tabbar_nft"];
    
    PW_DappViewController *dappVc = [PW_DappViewController new];
    PW_NavigationController *dappNac = [[PW_NavigationController alloc] initWithRootViewController:dappVc];
    dappNac.tabBarItem = [self tabbarItemTitle:LocalizedStr(@"tabbar_browser") imageNamed:@"icon_tabbar_browser"];
    
    PW_MoreViewController *moreVc = [PW_MoreViewController new];
    PW_NavigationController *moreNac = [[PW_NavigationController alloc] initWithRootViewController:moreVc];
    moreNac.tabBarItem = [self tabbarItemTitle:LocalizedStr(@"tabbar_more") imageNamed:@"icon_tabbar_more"];
    
    self.viewControllers = @[walletNac,marketNac,ntfNac,dappNac,moreNac];
}
- (UITabBarItem *)tabbarItemTitle:(NSString *)title imageNamed:(NSString *)imageNamed {
    UITabBarItem *item = [[UITabBarItem alloc] init];
    item.title = title;
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium],NSForegroundColorAttributeName:[UIColor g_whiteTextColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium],NSForegroundColorAttributeName:[UIColor g_primaryColor]} forState:UIControlStateSelected];
    item.image = [[UIImage imageNamed:imageNamed] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageNamed]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return item;
}
#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [PW_VibrationTool light];
}

@end
