//
//  PW_CollectionViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_TokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_CollectionViewController : PW_BaseViewController

@property (nonatomic, strong) PW_TokenModel *model;

@end

NS_ASSUME_NONNULL_END
