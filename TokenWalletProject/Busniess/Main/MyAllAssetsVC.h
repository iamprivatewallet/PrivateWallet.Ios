//
//  MyAllAssetsVC.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAllAssetsVC : BaseViewController
//@property (nonatomic, strong) Wallet *currentWallet;
@property (nonatomic, copy) NSArray *coinList;

@end

NS_ASSUME_NONNULL_END
