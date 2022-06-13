//
//  PW_MoreModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"
@class PW_MoreModel;

NS_ASSUME_NONNULL_BEGIN

@interface PW_MoreModel : PW_BaseModel

+ (instancetype)MoreIconName:(NSString *)iconName title:(NSString *)title actionBlock:(void(^)(PW_MoreModel *model))actionBlock;
+ (instancetype)MoreIconName:(NSString *)iconName title:(NSString *)title desc:(NSString *)desc actionBlock:(void(^)(PW_MoreModel *model))actionBlock;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) void(^actionBlock)(PW_MoreModel *model);

@end

NS_ASSUME_NONNULL_END
