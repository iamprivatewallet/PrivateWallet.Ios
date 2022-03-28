//
//  UIView+Indictor.m
//  TokenWalletProject
//
//  Created by jinkh on 2019/1/9.
//  Copyright © 2019 Zinkham. All rights reserved.
//

#import "UIView+Indictor.h"

@implementation UIView (Indictor)

-(UIActivityIndicatorView *)indicator
{
    UIActivityIndicatorView *indicator = objc_getAssociatedObject(self, @"IndicatorView");
    if (!indicator) {
        if (@available(iOS 13.0, *)) {
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        } else {
            // Fallback on earlier versions
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

        }
        indicator.center = CGPointMake(self.mj_w*.5, self.mj_h*.5);
        indicator.color = [UIColor blackColor];
        [indicator startAnimating];
        objc_setAssociatedObject(self, @"IndicatorView", indicator, OBJC_ASSOCIATION_RETAIN);
    }
    return indicator;
}

- (void)showLoadingIndicator
{
    UIActivityIndicatorView *indicator = [self indicator];
    if (!indicator.superview) {
        [self addSubview:indicator];
    }
}

- (void)hideLoadingIndicator
{
    UIActivityIndicatorView *indicator = [self indicator];
    if (indicator.superview) {
        [indicator removeFromSuperview];
    }
}

-(void)addWholeRound:(CGFloat)width{
    self.layer.cornerRadius = width;
    self.layer.masksToBounds = YES;
}


@end
