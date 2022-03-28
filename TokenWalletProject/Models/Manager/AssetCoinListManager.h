//
//  AssetCoinListManager.h
//  TokenWalletProject
//
//  Created by FChain on 2021/10/19.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetCoinListManager : NSObject
+(instancetype)sharedInstance;

-(NSArray *)getArray;
-(void)addCoin:(NSDictionary *)dic;
-(void)deleteCoin:(NSString *)idStr;
- (NSDictionary *)getCoinWithID:(NSString *)idStr;
-(void)deleteAllCoins;
@end

NS_ASSUME_NONNULL_END
