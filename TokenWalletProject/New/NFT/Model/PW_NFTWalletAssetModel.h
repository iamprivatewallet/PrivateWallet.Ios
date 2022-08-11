//
//  PW_NFTWalletAssetModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"
#import "PW_NFTCollectionModel.h"
#import "PW_NFTTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTWalletAssetModel : PW_BaseModel

@property (nonatomic, copy) NSString *totalVolume;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSArray<PW_NFTCollectionModel *> *collections;
@property (nonatomic, copy) NSArray<PW_NFTTokenModel *> *tokens;

@end

NS_ASSUME_NONNULL_END