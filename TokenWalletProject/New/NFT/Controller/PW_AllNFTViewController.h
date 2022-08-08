//
//  PW_AllNFTViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_NFTClassifyModel.h"

typedef enum : NSUInteger {
    PW_AllNFTAll=0,
    PW_AllNFTNew,
} PW_AllNFTType;

NS_ASSUME_NONNULL_BEGIN

@interface PW_AllNFTViewController : PW_BaseViewController

@property (nonatomic, assign) PW_AllNFTType type;
@property (nonatomic, strong) PW_NFTClassifyModel *model;

@end

NS_ASSUME_NONNULL_END
