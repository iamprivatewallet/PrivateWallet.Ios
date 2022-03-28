//
//  WalletRecordManager.h
//  GCSWalletProject
//
//  Created by MM on 2020/10/28.
//  Copyright © 2020 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletRecordManager : NSObject

+ (instancetype)shareRecordManager;

- (void)saveRecord:(WalletRecord*)record;

- (void)updateRecord:(WalletRecord*)record;

- (void)deleteRecord:(WalletRecord*)record;

- (NSArray*)getWalletsWithAddress:(NSString *)address tokenAddr:(NSString *)tokenAddr;


@end

NS_ASSUME_NONNULL_END
