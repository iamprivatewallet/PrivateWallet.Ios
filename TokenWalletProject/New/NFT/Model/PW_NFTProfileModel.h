//
//  PW_NFTProfileModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/10.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTProfileModel : PW_BaseModel

@property (nonatomic, copy) NSString *pId;
@property (nonatomic, copy, nullable) NSString *address;
@property (nonatomic, copy, nullable) NSString *profileImgUrl;
@property (nonatomic, copy, nullable) NSString *bannerImageUrl;
@property (nonatomic, copy, nullable) NSString *username;
@property (nonatomic, copy, nullable) NSString *desc;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
