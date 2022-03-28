//
//  SecretFreeViewController.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/9.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecretFreeViewController : BaseViewController
@property(nonatomic, assign) BOOL isPresentShow;
@property (nonatomic, strong) Wallet *wallet;

@end

NS_ASSUME_NONNULL_END
