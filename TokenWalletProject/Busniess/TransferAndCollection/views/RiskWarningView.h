//
//  RiskWarningView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/25.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiskWarningView : UIView
+(RiskWarningView *)getRiskWarningViewWithAction:(void(^)(void))action;
@end

NS_ASSUME_NONNULL_END
