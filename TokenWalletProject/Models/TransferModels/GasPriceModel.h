//
//  GasPriceModel.h
//  TokenWalletProject
//
//  Created by fchain on 2021/9/3.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GasPriceModel : NSObject

@property (nonatomic, copy) NSString *gas_speed;
@property (nonatomic, copy) NSString *gas_gwei;
@property (nonatomic, copy) NSString *gas_time;
@property (nonatomic, copy) NSString *gas;


@property (nonatomic, assign) CGFloat all_gasAmount;

@end

@interface CurrentGasPriceModel : NSObject

@property (nonatomic, copy) NSString *gas_price;
@property (nonatomic, copy) NSString *gas;


@end

NS_ASSUME_NONNULL_END
