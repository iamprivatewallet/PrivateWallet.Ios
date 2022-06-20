//
//  PW_TransferViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/16.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_TokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_TransferViewController : PW_BaseViewController

@property (nonatomic, strong) PW_TokenModel *model;
@property (nonatomic, copy) NSString *toAddress;
@property (nonatomic, copy) void(^transferSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
