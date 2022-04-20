//
//  PW_NetworkManager.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_NetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NetworkManager : NSObject

+ (instancetype)shared;
- (NSInteger)getMaxIndex;
- (void)saveModel:(PW_NetworkModel *)model;
- (BOOL)updateModel:(PW_NetworkModel *)model;
- (BOOL)updateSortIndex:(NSInteger)sortIndex chainId:(NSString *)chainId;
- (void)deleteModel:(PW_NetworkModel *)model;
- (nullable PW_NetworkModel *)isExistWithChainId:(NSString *)chainId;
- (NSArray<PW_NetworkModel *> *)getList;
- (NSArray<PW_NetworkModel *> *)getListWithChainId:(NSString *)chainId;

@end

NS_ASSUME_NONNULL_END
