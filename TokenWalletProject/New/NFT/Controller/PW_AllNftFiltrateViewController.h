//
//  PW_AllNftFiltrateViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_AllNftFiltrateGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_AllNftFiltrateViewController : PW_BaseViewController

@property (nonatomic, copy) NSArray<PW_AllNftFiltrateGroupModel *> *filtrateArr;
@property (nonatomic, copy) void(^sureBlock)(NSArray<PW_AllNftFiltrateGroupModel *> *filtrateArr);

@end

NS_ASSUME_NONNULL_END
