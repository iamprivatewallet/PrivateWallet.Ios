//
//  WalletCoinListManager.h
//  TokenWalletProject
//
//  Created by FChain on 2021/10/19.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetCoinModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WalletCoinListManager : NSObject
+ (instancetype)shareManager;
- (NSInteger)getMaxIndex;
- (void)saveCoin:(AssetCoinModel *)coin;
- (BOOL)updateCoin:(AssetCoinModel*)record address:(NSString *)address type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSString *)chainId;
- (BOOL)updateSortIndex:(NSInteger)sortIndex address:(NSString *)address type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSString *)chainId;
- (AssetCoinModel *)isExit:(NSString *)address type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSString *)chainId;
- (void)deleteCoin:(NSString *)address type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSString *)chainId;
- (NSArray*)getListWithWalletAddress:(NSString *)address type:(NSString *)type chainId:(NSString *)chainId;
@end

NS_ASSUME_NONNULL_END
