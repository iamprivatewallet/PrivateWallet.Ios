//
//  PW_NFTTokenDetailHeaderView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/3.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_NFTDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTTokenDetailHeaderView : UIView

@property (nonatomic, strong) PW_NFTDetailModel *model;
@property (nonatomic, copy) void(^transferBlock)(void);
@property (nonatomic, copy, nullable) void(^addRemoveMarketBlock)(void);

@end

NS_ASSUME_NONNULL_END
