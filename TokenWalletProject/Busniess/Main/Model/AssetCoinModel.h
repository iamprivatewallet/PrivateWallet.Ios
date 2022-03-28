//
//  AssetCoinModel.h
//  TokenWalletProject
//
//  Created by FChain on 2021/10/19.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetCoinModel : NSObject

@property (nonatomic, copy) NSString *coinId;
@property (nonatomic, assign) NSInteger sortIndex;//顺序
@property (nonatomic, copy) NSString *walletType;
@property (nonatomic, copy) NSString *walletAddress;
@property (nonatomic, copy) NSString *tokenContract;
@property (nonatomic, copy) NSString *tokenName;
@property (nonatomic, copy) NSString *tokenSymbol;
@property (nonatomic, copy) NSString *tokenDecimals;
@property (nonatomic, copy) NSString *tokenChain;
@property (nonatomic, copy) NSString *tokenLogo;
@property (nonatomic, copy) NSString *hotTokens;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isExit;

@end

NS_ASSUME_NONNULL_END
