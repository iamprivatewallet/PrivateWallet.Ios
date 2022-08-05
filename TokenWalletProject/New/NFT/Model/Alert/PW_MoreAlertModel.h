//
//  PW_MoreAlertModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_MoreAlertModel : PW_BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) void(^didClick)(PW_MoreAlertModel *model);

+ (instancetype)modelIconName:(NSString *)iconName title:(NSString *)title didClick:(void(^)(PW_MoreAlertModel *model))didClick;

@end

NS_ASSUME_NONNULL_END
