//
//  PW_WalletSetModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_WalletSetModel : PW_BaseModel

+ (instancetype)ModelIconName:(NSString *)iconName title:(NSString *)title desc:(NSString *)desc actionBlock:(void(^)(PW_WalletSetModel *model))actionBlock;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) void(^actionBlock)(PW_WalletSetModel *model);

@end

NS_ASSUME_NONNULL_END
