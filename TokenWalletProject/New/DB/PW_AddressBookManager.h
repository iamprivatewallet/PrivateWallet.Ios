//
//  PW_AddressBookManager.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_AddressBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_AddressBookManager : NSObject

+ (instancetype)shared;
- (void)saveModel:(PW_AddressBookModel *)model;
- (BOOL)updateModel:(PW_AddressBookModel *)model;
- (void)deleteModel:(PW_AddressBookModel *)model;
- (void)deleteAll;
- (NSArray<PW_AddressBookModel *> *)getList;
- (NSArray<PW_AddressBookModel *> *)getListWithChainId:(NSString *)chainId;

@end

NS_ASSUME_NONNULL_END
