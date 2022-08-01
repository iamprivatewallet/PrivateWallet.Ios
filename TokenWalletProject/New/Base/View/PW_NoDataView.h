//
//  PW_NoDataView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_NoDataView : UIView

+ (instancetype)showView:(UIView *)view;
+ (instancetype)showView:(UIView *)view offsetY:(CGFloat)offsetY;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *text;
- (void)dismissView;

@end

NS_ASSUME_NONNULL_END
