//
//  BaseNavinationViewController.h
//  AegisCargo
//
//  Created by Terry.c on 21/11/2017.
//  Copyright © 2017 Aegis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface BaseNavinationViewController : UINavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController navBtn:(BOOL)navBtn;

@end
