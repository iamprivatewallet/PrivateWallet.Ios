//
//  MangeWalletsVC.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, kWalletType) {
    kWalletTypeAll,
    kWalletTypeETH,
//    kWalletTypeBSC,
//    kWalletTypeHECO,
    kWalletTypeCVN
};

@interface MangeWalletsVC : BaseViewController
@property(nonatomic, assign) kWalletType walletType;

@end

NS_ASSUME_NONNULL_END
