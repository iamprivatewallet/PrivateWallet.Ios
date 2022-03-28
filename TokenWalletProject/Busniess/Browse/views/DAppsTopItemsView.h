//
//  DappsTopItemsView.h
//  TokenWalletProject
//
//  Created by FChain on 2021/9/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DAppsTopItemsView : UIView

@property (nonatomic, copy) void(^changeItemBlock)(NSInteger);
- (void)makeViewsWithArr:(NSArray *)list;

@end

NS_ASSUME_NONNULL_END
