//
//  PW_NFTAssetContractModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/10.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTAssetContractModel : PW_BaseModel

@property (nonatomic, copy, nullable) NSString *cId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy, nullable) NSString *address;
@property (nonatomic, copy, nullable) NSString *assetContractType;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *owner;
@property (nonatomic, copy, nullable) NSString *schemaName;
@property (nonatomic, copy, nullable) NSString *symbol;
@property (nonatomic, copy, nullable) NSString *createTime;
@property (nonatomic, copy, nullable) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
