//
//  PW_DappMoreModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappMoreModel : PW_BaseModel

+ (instancetype)ModelIconName:(NSString *)iconName title:(NSString *)title actionBlock:(void(^)(PW_DappMoreModel *model))actionBlock;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^actionBlock)(PW_DappMoreModel *model);

@end

NS_ASSUME_NONNULL_END
