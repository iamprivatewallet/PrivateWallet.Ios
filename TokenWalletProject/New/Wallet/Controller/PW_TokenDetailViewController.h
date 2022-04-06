//
//  PW_TokenDetailViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/5.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_TokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_TokenDetailViewController : PW_BaseViewController

@property (nonatomic, strong) PW_TokenModel *model;

@end

NS_ASSUME_NONNULL_END
