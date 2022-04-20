//
//  PW_WalletView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/11.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_BaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_WalletView : UIView

+ (instancetype)shared;
+ (void)show;
+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
