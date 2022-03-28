//
//  ETHTransfer.h
//  FunnyProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETHTransfer : JSONModel

@property (strong, nonatomic) NSString<Optional> *tx_id;
@property (strong, nonatomic) NSString<Optional> *tx_status;
@property (strong, nonatomic) NSString<Optional> *block_check_count;
@property (strong, nonatomic) NSString<Optional> *tx_type;
@property (strong, nonatomic) NSString<Optional> *gas_used;
@property (strong, nonatomic) NSString<Optional> *cumulative_gas_used;
@property (strong, nonatomic) NSString<Optional> *from_addr;
@property (strong, nonatomic) NSString<Optional> *to_addr;
@property (strong, nonatomic) NSString<Optional> *contract_addr;
@property (strong, nonatomic) NSString<Optional> *block_hash;
@property (strong, nonatomic) NSString<Optional> *block_number;
@property (strong, nonatomic) NSString<Optional> *block_tx_index;
@property (strong, nonatomic) NSString<Optional> *des;
@property (strong, nonatomic) NSString<Optional> *err_msg;
@property (strong, nonatomic) NSString<Optional> *created_time;
@property (strong, nonatomic) NSString<Optional> *err_code;
@property (strong, nonatomic) NSString<Optional> *msg;
@property (strong, nonatomic) NSString<Optional> *value;
@property (strong, nonatomic) NSString<Optional> *signed_message;
@property (strong, nonatomic) NSString<Optional> *ext_data;
@property (strong, nonatomic) NSString<Optional> *type;

@property (strong, nonatomic) NSString<Optional> *block_height;
@property (strong, nonatomic) NSString<Optional> *status;
@property (strong, nonatomic) NSString<Optional> *timestamp;
@property (strong, nonatomic) NSString<Optional> *from;
@property (strong, nonatomic) NSString<Optional> *to;
@property (strong, nonatomic) NSString<Optional> *quantity;
@property (strong, nonatomic) NSString<Optional> *from_tag;
@property (strong, nonatomic) NSString<Optional> *to_tag;
@property (strong, nonatomic) NSString<Optional> *transaction_hash;
@property (strong, nonatomic) NSString<Optional> *nonce;
@property (strong, nonatomic) NSString<Optional> *is_to_more;
@property (strong, nonatomic) NSString<Optional> *direction;
@property (strong, nonatomic) NSString<Optional> *vHash;



@end

NS_ASSUME_NONNULL_END
