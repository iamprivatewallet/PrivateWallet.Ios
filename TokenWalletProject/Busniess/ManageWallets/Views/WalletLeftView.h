//
//  WalletLeftView.h
//  GCSWallet
//
//  Created by MM on 2020/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WalletLeftViewDelegate <NSObject>

- (void)clickTagButtonIndex:(NSInteger)index;

@end

@interface WalletLeftView : UIView

@property (nonatomic, weak) id<WalletLeftViewDelegate> delegate;

- (void)chooseItem:(NSInteger)index;

- (void)refreshWalletLeftView;

@end

NS_ASSUME_NONNULL_END
