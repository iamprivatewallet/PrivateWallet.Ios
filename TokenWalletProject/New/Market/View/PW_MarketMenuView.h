//
//  PW_MarketMenuView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_MarketMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_MarketMenuView : UIView

@property (nonatomic, copy) NSArray <PW_MarketMenuModel *> *dataArr;
@property (nonatomic, copy) void(^clickBlock)(NSInteger idx, PW_MarketMenuModel *model);

@end

NS_ASSUME_NONNULL_END
