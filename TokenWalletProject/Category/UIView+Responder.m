//
//  UIView+Responder.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/2.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "UIView+Responder.h"

@implementation UIView (Responder)
- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
