//
//  PW_CreateViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_CreateViewController.h"

@interface PW_CreateViewController ()

@end

@implementation PW_CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_createWallet") rightImg:@"icon_share" rightAction:@selector(shareAction)];
    [self makeViews];
}
- (void)shareAction {
    
}
- (void)makeViews {
    
}

@end
