//
//  PW_TransferNFTViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/3.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_NFTTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_TransferNFTViewController : PW_BaseViewController

@property (nonatomic, strong) PW_NFTTokenModel *model;
@property (nonatomic, copy) NSString *toAddress;
@property (nonatomic, copy) void(^transferSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
