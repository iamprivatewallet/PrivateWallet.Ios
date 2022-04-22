//
//  PW_WalletListView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_WalletListView : UIView

+ (instancetype)shared;
+ (void)show;
+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END