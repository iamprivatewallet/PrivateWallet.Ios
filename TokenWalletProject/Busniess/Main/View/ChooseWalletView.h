//
//  ChooseWalletView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/2.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, kChooseWalletType) {
    kChooseWalletTypeAll,
    kChooseWalletTypeETH,
//    kChooseWalletTypeBSC,
//    kChooseWalletTypeHECO,
    kChooseWalletTypeCVN
};
@protocol ChooseWalletViewDelegate <NSObject>

- (void)chooseWallet:(id)wallet;
- (void)jumpToManageVC;

@end
@interface ChooseWalletView : UIView
@property (nonatomic, weak) id<ChooseWalletViewDelegate> delegate;

@property(nonatomic, assign) kChooseWalletType walletType;
@property (nonatomic, strong) UIView *bgWhiteView;

+(ChooseWalletView *)getChooseWallet;

@end

NS_ASSUME_NONNULL_END
