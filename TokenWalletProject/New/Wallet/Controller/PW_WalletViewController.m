//
//  PW_WalletViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletViewController.h"
#import "PW_ScanTool.h"

@interface PW_WalletViewController ()

@end

@implementation PW_WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"" leftImg:@"icon_wallet" leftAction:@selector(walletAction) rightImg:@"icon_scan" rightAction:@selector(scanAction) isNoLine:YES isWhiteBg:NO];
    [self makeViews];
}
- (void)scanAction {
    [[PW_ScanTool shared] showScanWithResultBlock:^(NSString * _Nonnull result) {
        
    }];
}
- (void)walletAction {
    
}
- (void)makeViews {
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"first_bg"]];
    [self.view insertSubview:bgIv atIndex:0];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
    }];
}

@end
