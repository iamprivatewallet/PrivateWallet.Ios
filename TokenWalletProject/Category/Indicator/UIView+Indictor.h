//
//  UIView+Indictor.h
//  TokenWalletProject
//
//  Created by jinkh on 2019/1/9.
//  Copyright © 2019 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Indictor)

- (void)showLoadingIndicator;

- (void)hideLoadingIndicator;


-(void)addWholeRound:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
