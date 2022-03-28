//
//  TransferInputModel.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/26.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferInputModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *tips;
@property (nonatomic, copy) NSString *gas_price;
@property (nonatomic, copy) NSString *gas;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *all_gasPrice;

@property (nonatomic, copy) NSString *netUrl;

@end

NS_ASSUME_NONNULL_END
