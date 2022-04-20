//
//  PW_TokenModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/3.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_TokenModel : PW_BaseModel

@property (nonatomic, copy) NSString *tokenTitle;
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *tokenTime;

@property (nonatomic, copy) NSString *tId;
@property (nonatomic, copy) NSString *tokenContract;
@property (nonatomic, copy) NSString *tokenName;
@property (nonatomic, copy) NSString *tokenAmount;
@property (nonatomic, copy) NSString *tokenSymbol;
@property (nonatomic, assign) NSInteger tokenDecimals;
@property (nonatomic, assign) NSInteger tokenChain;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) BOOL hotTokens;
@property (nonatomic, copy) NSString *tokenLogo;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, copy) NSString *nonce;

@property (nonatomic, assign) NSInteger sortIndex;//顺序
@property (nonatomic, copy) NSString *walletType;
@property (nonatomic, copy) NSString *walletAddress;
@property (nonatomic, assign) BOOL isExist;

@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, assign) BOOL isChoose;

@end

NS_ASSUME_NONNULL_END
