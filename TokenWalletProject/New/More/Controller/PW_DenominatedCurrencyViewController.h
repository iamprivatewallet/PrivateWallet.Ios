//
//  PW_DenominatedCurrencyViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DenominatedCurrencyViewController : PW_BaseViewController

@property (nonatomic, copy) void(^changeBlock)(PW_DenominatedCurrencyType type);

@end

NS_ASSUME_NONNULL_END
