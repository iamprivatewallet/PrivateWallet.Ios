//
//  UIViewController+helper.m
//  HyperFund
//
//  Created by 孙林林 on 2020/7/9.
//  Copyright © 2020 HyperTech. All rights reserved.
//
//

#import "UIViewController+helper.h"

@implementation UIViewController (helper)

- (void)adaptScrollView:(UIScrollView *)scrollView{
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

@end
