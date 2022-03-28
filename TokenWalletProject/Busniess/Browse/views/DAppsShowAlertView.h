//
//  DAppsShowAlertView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/9/11.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAppsShowAlertView : UIView
+(DAppsShowAlertView *_Nullable)showAlertViewIsVisitExplain:(BOOL)isExplain netUrl:(nullable NSString *)netUrl action:(void(^_Nullable)(NSInteger index, BOOL isNoAlert))action;


//+(DAppsShowAlertView *)showTradeViewWithAction:(void(^)(NSInteger index))action;

@end
