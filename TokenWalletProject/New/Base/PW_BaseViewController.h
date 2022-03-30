//
//  PW_BaseViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_BaseViewController : BaseViewController

- (void)showSuccess:(NSString *)text;
- (void)showError:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
