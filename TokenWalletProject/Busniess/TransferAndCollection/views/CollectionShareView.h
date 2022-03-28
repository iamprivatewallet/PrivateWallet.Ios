//
//  CollectionShareView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/12.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionShareView : UIView

+(void)showShareViewWithInfo:(id)info amount:(NSString *)amount shareAction:(void(^)(void))action;

@end

NS_ASSUME_NONNULL_END
