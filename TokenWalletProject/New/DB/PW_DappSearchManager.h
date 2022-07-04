//
//  PW_DappSearchManager.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/20.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_DappModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappSearchManager : NSObject

+ (instancetype)shared;
- (void)saveModel:(PW_DappModel *)model;
- (BOOL)updateModel:(PW_DappModel *)model;
- (BOOL)deleteWithUrlStr:(NSString *)urlStr;
- (BOOL)deleteAll;
- (NSArray<PW_DappModel *> *)getList;
- (nullable PW_DappModel *)isExistWithUrlStr:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
