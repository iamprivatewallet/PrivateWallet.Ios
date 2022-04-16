//
//  PW_ChooseCurrencyViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/15.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_TokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_ChooseCurrencyViewController : PW_BaseViewController

@property (nonatomic, copy) NSString *selectedTokenContract;
@property (nonatomic, copy) void(^chooseBlock)(PW_TokenModel *model);

@end

NS_ASSUME_NONNULL_END
