//
//  PW_SetUpModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_SetUpModel : PW_BaseModel

+ (instancetype)SetUpIconName:(NSString *)iconName title:(NSString *)title;
+ (instancetype)SetUpIconName:(NSString *)iconName title:(NSString *)title desc:(NSString *)desc;
+ (instancetype)SetUpIconName:(NSString *)iconName title:(NSString *)title isSwitch:(BOOL)isSwitch;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) BOOL isSwitch;
@property (nonatomic, assign) BOOL isOpen;

@end

NS_ASSUME_NONNULL_END
