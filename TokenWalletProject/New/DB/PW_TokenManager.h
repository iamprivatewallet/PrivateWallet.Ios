//
//  PW_TokenManager.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/13.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_TokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_TokenManager : NSObject

+ (instancetype)shareManager;
- (NSInteger)getMaxIndex;
- (void)saveCoin:(PW_TokenModel *)coin;
- (BOOL)updateCoin:(PW_TokenModel*)record;
- (BOOL)updateSortIndex:(NSInteger)sortIndex address:(NSString *)address type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSInteger)chainId;
- (PW_TokenModel *)isExist:(NSString *)walletAddress type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSInteger)chainId;
- (void)deleteCoinWalletAddress:(NSString *)walletAddress type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSInteger)chainId;
- (NSArray*)getListWithWalletAddress:(NSString *)walletAddress type:(NSString *)type chainId:(NSInteger)chainId;

@end

NS_ASSUME_NONNULL_END
