//
//  TransferView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/13.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TransferViewDelegate <NSObject>
@optional
- (void)nextStepActionWithData:(TransferInputModel *)data;
- (void)advancedModeAction;
- (void)addressAction;
- (void)minersfeeAction;
- (void)exchangeAction;

@end
@interface TransferView : UIView

@property (nonatomic, weak) id<TransferViewDelegate> delegate;
@property (nonatomic, strong) UITextField *addrTF;
@property (nonatomic, strong) UITextField *amountTF;
@property (nonatomic, strong) UILabel *gasPriceLbl;

- (void)setViewWithModel:(id)model;

- (void)setGasPriceWithData:(id)data;

- (void)setCodeInfoWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
