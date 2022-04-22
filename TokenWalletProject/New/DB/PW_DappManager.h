//
//  PW_DappManager.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_DappModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappManager : NSObject

+ (instancetype)shared;
- (void)saveModel:(PW_DappModel *)model;
- (BOOL)updateModel:(PW_DappModel *)model;
- (BOOL)deleteWithUrlStr:(NSString *)urlStr;
- (NSArray<PW_DappModel *> *)getList;
- (BOOL)deleteAll;
- (nullable PW_DappModel *)isExistWithUrlStr:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
