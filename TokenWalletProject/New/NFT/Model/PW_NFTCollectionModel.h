//
//  PW_NFTCollectionModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTCollectionModel : PW_BaseModel

@property (nonatomic, copy) NSString *cId;
@property (nonatomic, assign) NSInteger limitStart;
@property (nonatomic, assign) NSInteger limitEnd;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *errors;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, copy) NSString *slug;
@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, assign) NSInteger totalSales;
@property (nonatomic, assign) NSInteger totalSupply;
@property (nonatomic, assign) NSInteger numOwners;
@property (nonatomic, assign) NSInteger numReports;
@property (nonatomic, copy) NSString *totalVolume;
@property (nonatomic, copy) NSString *averagePrice;
@property (nonatomic, copy) NSString *floorPrice;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *payoutAddress;
@property (nonatomic, copy) NSString *bannerImageUrl;
@property (nonatomic, copy) NSString *externalUrl;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *largeImageUrl;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *categorySlug;

@end

NS_ASSUME_NONNULL_END
