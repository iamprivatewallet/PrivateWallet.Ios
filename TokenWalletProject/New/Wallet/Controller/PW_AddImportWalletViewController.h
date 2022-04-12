//
//  PW_AddImportWalletViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/12.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"

typedef NS_ENUM(NSUInteger, PW_ImportWalletType) {
    PW_ImportWalletTypeMnemonic,
    PW_ImportWalletTypePrivateKey,
};

NS_ASSUME_NONNULL_BEGIN

@interface PW_AddImportWalletViewController : PW_BaseViewController

@property (nonatomic, copy) NSString *walletType;
@property (nonatomic, assign) PW_ImportWalletType importType;

@end

NS_ASSUME_NONNULL_END
