//
//  PW_WalletManageHeaderView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/14.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_WalletManageHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^addBlock)(void);

@end

NS_ASSUME_NONNULL_END
