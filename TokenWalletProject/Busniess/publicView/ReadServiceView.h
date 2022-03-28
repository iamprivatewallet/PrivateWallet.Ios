//
//  ReadServiceView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/9/6.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadServiceView : UIView
+(ReadServiceView *)showServiceViewWithAction:(void(^)(void))action;

@end

NS_ASSUME_NONNULL_END
