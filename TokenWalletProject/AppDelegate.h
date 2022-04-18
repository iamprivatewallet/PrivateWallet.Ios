//
//  AppDelegate.h
//  TokenWalletProject
//
//  Created by Zinkham on 16/7/7.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *rootNavigationController;

-(void)switchToTabBarController;
-(void)switchToCreateWalletVC;
- (void)resetApp;

@end

