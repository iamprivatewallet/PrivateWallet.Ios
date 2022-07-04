//
//  PW_MarketManager.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_MarketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_MarketManager : NSObject

+ (instancetype)shared;
- (void)saveModel:(PW_MarketModel *)model;
- (BOOL)updateModel:(PW_MarketModel *)model;
- (void)deleteModel:(PW_MarketModel *)model;
- (BOOL)deleteAll;
- (NSArray<PW_MarketModel *> *)getList;
- (nullable PW_MarketModel *)isExistWithSymbol:(NSString *)symbol;

@end

NS_ASSUME_NONNULL_END
