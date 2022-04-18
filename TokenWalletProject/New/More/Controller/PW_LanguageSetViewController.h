//
//  PW_LanguageSetViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_LanguageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_LanguageSetViewController : PW_BaseViewController

@property (nonatomic, copy) void(^changeBlock)(PW_LanguageModel *model);

@end

NS_ASSUME_NONNULL_END
