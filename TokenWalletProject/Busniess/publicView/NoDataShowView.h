//
//  NoDataShowView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoDataShowView : UIView

+ (NoDataShowView *)showView:(UIView *)view image:(NSString *)image text:(NSString *)text;
+ (NoDataShowView *)showView:(UIView *)view image:(NSString *)image text:(NSString *)text offsetY:(CGFloat)offsetY;
@property (nonatomic, assign) CGFloat offsetY;
- (void)dismissView;

@end

NS_ASSUME_NONNULL_END
