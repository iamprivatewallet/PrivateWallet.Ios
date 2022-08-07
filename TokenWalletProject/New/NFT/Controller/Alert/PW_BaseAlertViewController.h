//
//  PW_BaseAlertViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_BaseAlertViewController : PW_BaseViewController

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeBtn;
- (void)show;
- (void)closeAction;

@end

NS_ASSUME_NONNULL_END
