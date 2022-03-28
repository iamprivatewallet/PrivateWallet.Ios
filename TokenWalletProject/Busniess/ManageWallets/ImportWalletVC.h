//
//  ImportWalletViewController.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/4.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, kImportWalletType) {
    kImportWalletTypeMnemonic,
    kImportWalletTypePrivateKey,
    kImportWalletTypeKeystore,

};
@interface ImportWalletVC : BaseTableViewController
@property(nonatomic, assign) kImportWalletType importType;
@property (nonatomic, copy) NSString *walletTypeStr;
@end

NS_ASSUME_NONNULL_END
