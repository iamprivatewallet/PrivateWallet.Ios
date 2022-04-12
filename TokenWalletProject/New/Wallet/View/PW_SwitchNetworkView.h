//
//  PW_SwitchNetworkView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/11.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_BaseTableCell.h"
#import "PW_NetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_SwitchNetworkView : UIView

+ (instancetype)shared;
+ (void)show;
+ (void)dismiss;

@end

@interface PW_SwitchNetworkCell : PW_BaseTableCell

@property (nonatomic, strong) PW_NetworkModel *model;

@end

NS_ASSUME_NONNULL_END
