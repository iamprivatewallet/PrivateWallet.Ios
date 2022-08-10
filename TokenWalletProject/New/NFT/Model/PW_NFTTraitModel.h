//
//  PW_NFTTraitModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/10.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTTraitModel : PW_BaseModel

@property (nonatomic, copy, nullable) NSString *tId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy, nullable) NSString *tokenId;
@property (nonatomic, copy, nullable) NSString *assetContract;
@property (nonatomic, copy, nullable) NSString *traitValue;
@property (nonatomic, copy, nullable) NSString *traitType;
@property (nonatomic, assign) NSInteger traitCount;
@property (nonatomic, copy, nullable) NSString *createTime;
@property (nonatomic, copy, nullable) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
