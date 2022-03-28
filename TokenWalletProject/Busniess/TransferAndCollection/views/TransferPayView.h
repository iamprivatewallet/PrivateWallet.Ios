//
//  PayPasswordView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/25.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TransferPayViewDelegate <NSObject>

- (void)transferPayAction;

- (void)secretFreePaymentAction;


@end
@interface TransferPayView : UIView

@property (nonatomic, weak) id<TransferPayViewDelegate> delegate;

+(TransferPayView *)showView:(UIView *)view
                   inputData:(id)inputData
                  walletData:(id)walletData
                 isDAppsShow:(BOOL)isDApps
                    delegate:(id)delegate;
@end

NS_ASSUME_NONNULL_END
