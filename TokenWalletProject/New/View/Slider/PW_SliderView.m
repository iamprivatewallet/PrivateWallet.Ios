//
//  PW_SliderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/16.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SliderView.h"

@interface PW_SliderView ()

@end

@implementation PW_SliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setThumbImage:[UIImage imageNamed:@"icon_slider"] forState:UIControlStateNormal];
        self.minimumTrackTintColor = [UIColor g_primaryColor];
        self.maximumTrackTintColor = [UIColor g_hex:@"#E6E6E6"];
    }
    return self;
}
- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), 5);
}

@end
