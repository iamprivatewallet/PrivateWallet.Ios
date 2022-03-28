//
//  WalletRecord.h
//  GCSWalletProject
//
//  Created by fchain on 2020/10/28.
//  Copyright © 2020 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletRecord : NSObject
@property (nonatomic, copy)NSString *from_addr;
@property (nonatomic, copy)NSString *to_addr;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, copy)NSString *amount;
@property (nonatomic, copy)NSString *trade_id;
@property (nonatomic, copy)NSString *token_name;
@property (nonatomic, copy)NSString *token_address;
@property (nonatomic, copy)NSString *gas_price;
@property (nonatomic, copy)NSString *gas;//gasLimit
@property (nonatomic, assign) BOOL is_out;
@property (nonatomic, assign) NSInteger decimals;
@property (nonatomic, assign) NSInteger status;//0pending -1失败 1成功
@end

NS_ASSUME_NONNULL_END
