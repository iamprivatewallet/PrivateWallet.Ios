//
//  PW_NFTClassifyModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTClassifyModel : PW_BaseModel

@property (nonatomic, copy) NSString *cId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *slug;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *bannerImageUrl;

@end

NS_ASSUME_NONNULL_END
