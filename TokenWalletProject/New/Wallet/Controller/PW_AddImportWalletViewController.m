//
//  PW_AddImportWalletViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/12.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddImportWalletViewController.h"

@interface PW_AddImportWalletViewController ()

@end

@implementation PW_AddImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:NSStringWithFormat(LocalizedStr(@"text_importSomeWallet"),self.walletType)];
}

@end
