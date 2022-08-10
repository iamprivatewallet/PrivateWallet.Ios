//
//  PW_NFTDetailModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/10.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"
#import "PW_NFTCollectionModel.h"
#import "PW_NFTTokenModel.h"
#import "PW_NFTTraitModel.h"
#import "PW_NFTAssetContractModel.h"
#import "PW_NFTAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTDetailModel : PW_BaseModel

@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, strong) PW_NFTAssetContractModel *assetContract;
@property (nonatomic, copy) PW_NFTCollectionModel *collection;
@property (nonatomic, copy) NSArray<PW_NFTTokenModel *> *tokens;
@property (nonatomic, copy) NSArray<PW_NFTTraitModel *> *traits;
@property (nonatomic, strong) PW_NFTAssetModel *asset;

@end

NS_ASSUME_NONNULL_END
