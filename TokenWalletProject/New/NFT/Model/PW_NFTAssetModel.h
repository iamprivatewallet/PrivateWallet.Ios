//
//  PW_NFTAssetModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/10.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTAssetModel : PW_BaseModel

@property (nonatomic, copy) NSString *cId;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) NSInteger limitStart;
@property (nonatomic, assign) NSInteger limitEnd;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *errors;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger marketStatus;
@property (nonatomic, assign) NSInteger saleStatus;
@property (nonatomic, copy, nullable) NSString *tokenId;
@property (nonatomic, copy, nullable) NSString *assetContract;
@property (nonatomic, copy, nullable) NSString *symbol;
@property (nonatomic, copy, nullable) NSString *owner;
@property (nonatomic, copy, nullable) NSString *creator;
@property (nonatomic, copy) NSString *ethPrice;
@property (nonatomic, copy) NSString *usdPrice;
@property (nonatomic, assign) NSInteger numSales;
@property (nonatomic, copy) NSString *slug;
@property (nonatomic, copy) NSString *categorySlug;
@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy, nullable) NSString *imagePreviewUrl;
@property (nonatomic, copy) NSString *imageThumbnailUrl;
@property (nonatomic, copy, nullable) NSString *imageOriginalUrl;
@property (nonatomic, copy, nullable) NSString *externalLink;
@property (nonatomic, copy, nullable) NSString *permalink;
@property (nonatomic, assign) NSInteger follows;
@property (nonatomic, copy, nullable) NSString *tokenMetadata;
@property (nonatomic, copy, nullable) NSString *openedAt;
@property (nonatomic, copy, nullable) NSString *closedAt;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy, nullable) NSString *orderTime;
@property (nonatomic, copy, nullable) NSString *orderPrice;

@end

NS_ASSUME_NONNULL_END
