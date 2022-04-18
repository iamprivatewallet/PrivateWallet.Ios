//
//  PW_LanguageModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_LanguageModel : PW_BaseModel

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *languageCode;
@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
