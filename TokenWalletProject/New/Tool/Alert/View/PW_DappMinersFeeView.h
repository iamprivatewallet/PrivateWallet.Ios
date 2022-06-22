//
//  PW_DappMinersFeeView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/28.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_GasModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappMinersFeeView : UIView

@property (nonatomic, strong) PW_GasToolModel *toolModel;
@property (nonatomic, copy, readonly) NSString *title;
- (PW_GasModel *)getCurrentGasModel;

@end

NS_ASSUME_NONNULL_END
