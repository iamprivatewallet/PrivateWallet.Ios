//
//  UIScrollView+PW_Inset.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/9.
//  Copyright © 2022 . All rights reserved.
//

#import "UIScrollView+PW_Inset.h"

@implementation UIScrollView (PW_Inset)

- (void)resetMJFooterBottom {
    if (self.mj_footer) {
        self.mj_footer.ignoredScrollViewContentInsetBottom = self.adjustedContentInset.bottom;
    }
}

@end
