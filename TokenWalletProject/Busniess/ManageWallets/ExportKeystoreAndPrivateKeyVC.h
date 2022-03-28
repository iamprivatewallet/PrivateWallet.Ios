//
//  ExportPrivateKeyVC.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/5.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, kExportType) {
    kExportTypeKeystore,
    kExportTypePrivateKey
};
@interface ExportKeystoreAndPrivateKeyVC : BaseViewController
@property(nonatomic, assign) kExportType exportType;
@property (nonatomic, strong) Wallet *wallet;

@end

NS_ASSUME_NONNULL_END
