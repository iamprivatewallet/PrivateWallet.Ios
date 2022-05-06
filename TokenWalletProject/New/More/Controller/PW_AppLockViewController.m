//
//  PW_AppLockViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/5/6.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AppLockViewController.h"
#import "PW_AuthenticationTool.h"

@interface PW_AppLockViewController ()

@end

@implementation PW_AppLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_appLock")];
    [self makeViews];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LAContext *context = [PW_AuthenticationTool showWithDesc:@"123" reply:^(BOOL success, NSError * _Nonnull error) {
        NSLog(@"%ld-%@",success,error.localizedDescription);
    }];
    switch (context.biometryType) {
        case LABiometryTypeFaceID:
            NSLog(@"FaceID");
            break;
        case LABiometryTypeTouchID:
            NSLog(@"TouchID");
            break;
        case LABiometryTypeNone:
            NSLog(@"None");
            break;
        default:
            break;
    }
}
- (void)makeViews {
    
}

@end
