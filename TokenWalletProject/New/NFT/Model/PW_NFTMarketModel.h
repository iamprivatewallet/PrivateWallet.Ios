//
//  PW_NFTMarketModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"
#import "PW_NFTTokenModel.h"
#import "PW_NFTCollectionModel.h"
#import "PW_NFTBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTMarketModel : PW_BaseModel

@property (nonatomic, copy) NSArray<PW_NFTTokenModel *> *assets;
@property (nonatomic, copy) NSArray<PW_NFTCollectionModel *> *collections;
@property (nonatomic, copy) NSArray<PW_NFTBannerModel *> *banners;

@end

NS_ASSUME_NONNULL_END
