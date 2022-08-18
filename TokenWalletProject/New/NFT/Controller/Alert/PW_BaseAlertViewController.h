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
@property (nonatomic, assign) BOOL isNeedAnimation;
- (void)show;
- (void)showInVc:(UIViewController *)vc;
- (void)closeAction;
- (void)closeWithCompletion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
