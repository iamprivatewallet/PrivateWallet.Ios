//
//  PW_filtrateNFTModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_filtrateNFTModel : PW_BaseModel

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^clickBlock)(void);
+ (instancetype)modelImageName:(NSString *)imageName title:(NSString *)title clickBlock:(void(^)(void))clickBlock;

@end

NS_ASSUME_NONNULL_END
