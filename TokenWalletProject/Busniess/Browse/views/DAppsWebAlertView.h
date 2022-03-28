//
//  DAppsWebAlertView.h
//  TokenWalletProject
//
//  Created by FChain on 2021/9/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DAppsWebAlertView : UIView
+(DAppsWebAlertView *)showWebAlertViewWithUrl:(NSString *)url action:(void(^)(NSInteger index))action;
@end

NS_ASSUME_NONNULL_END
