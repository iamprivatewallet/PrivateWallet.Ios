//
//  PW_PasswordView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/22.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_PasswordView : UIView

@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy) void(^changeBlock)(PW_PasswordView *view, NSString *text);
@property (nonatomic, copy) void(^completeBlock)(PW_PasswordView *view, NSString *text);
- (void)becomeFirstResponder;
- (void)reset;

@end

NS_ASSUME_NONNULL_END
