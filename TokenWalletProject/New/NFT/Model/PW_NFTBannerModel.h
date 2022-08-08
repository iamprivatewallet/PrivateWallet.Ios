//
//  PW_NFTBannerModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTBannerModel : PW_BaseModel

@property (nonatomic, copy) NSString *bId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *imgWeb;
@property (nonatomic, copy) NSString *imgH5;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *videoImg;
@property (nonatomic, copy) NSString *videoUrlH5;
@property (nonatomic, copy) NSString *videoImgH5;
@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, copy) NSString *clickUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
