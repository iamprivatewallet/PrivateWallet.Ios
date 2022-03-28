//
//  MessageCenterItemsView.h
//  TokenWalletProject
//
//  Created by FChain on 2021/9/24.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageCenterItemsView : UIView

@property (nonatomic, copy) void(^clickBlock)(NSInteger index);
- (void)setIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
