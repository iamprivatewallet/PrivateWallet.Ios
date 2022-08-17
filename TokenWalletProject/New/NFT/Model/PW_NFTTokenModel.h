//
//  PW_NFTTokenModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTTokenModel : PW_BaseModel

@property (nonatomic, copy) NSString *tId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *tokenId;
@property (nonatomic, assign) NSInteger decimals;
@property (nonatomic, copy) NSString *ethPrice;
@property (nonatomic, copy) NSString *usdPrice;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *imageThumbnailUrl;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *totalVolume;

@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) NSInteger follows;
@property (nonatomic, assign) NSInteger saleStatus;
@property (nonatomic, assign) NSInteger marketStatus;
@property (nonatomic, copy) NSString *assetContract;
@property (nonatomic, copy) NSString *slug;

@property (nonatomic, assign) NSInteger hotValue;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, copy) NSString *search;

@property (nonatomic, copy) NSString *nonce;

@end

NS_ASSUME_NONNULL_END
