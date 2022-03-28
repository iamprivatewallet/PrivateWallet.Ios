//
//  MainTopWalletView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/29.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MainTopWalletViewDelegate <NSObject>

- (void)clickAmountTextWithHidden;

@end

@interface MainTopWalletView : UIView

@property (nonatomic, weak) id<MainTopWalletViewDelegate> delegate;

- (void)setTopViewWithData:(id)data;
@end

NS_ASSUME_NONNULL_END
