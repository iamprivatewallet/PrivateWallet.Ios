//
//  SubscribeToMailView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/9/8.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubscribeToMailView : UIView

+(void)showMailViewWithAction:(void(^)(NSString *emailStr))action;

@end

NS_ASSUME_NONNULL_END
