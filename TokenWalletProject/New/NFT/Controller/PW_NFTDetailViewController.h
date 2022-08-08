//
//  PW_NFTDetailViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/4.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_NFTTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTDetailViewController : PW_BaseViewController

@property (nonatomic, strong) PW_NFTTokenModel *model;

@end

NS_ASSUME_NONNULL_END
