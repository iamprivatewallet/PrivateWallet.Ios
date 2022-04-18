//
//  PW_ChooseAddressTypeModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_ChooseAddressTypeModel : PW_BaseModel

+ (instancetype)IconName:(NSString *)iconName title:(NSString *)title subTitle:(NSString *)subTitle chainId:(NSString *)chainId selected:(BOOL)selected;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *chainId;

@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
