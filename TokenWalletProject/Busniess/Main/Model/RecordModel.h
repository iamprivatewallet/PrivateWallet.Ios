//
//  RecordModel.h
//  TokenWalletProject
//
//  Created by FChain on 2021/10/11.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordModel : NSObject
@property (nonatomic, copy) NSString *blockNumber;
@property (nonatomic, copy) NSString *blockHash;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *hashStr;
@property (nonatomic, copy) NSString *nonce;
@property (nonatomic, copy) NSString *transactionIndex;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *gas;//gasLimit
@property (nonatomic, copy) NSString *gasPrice;
@property (nonatomic, copy) NSString *input;
@property (nonatomic, copy) NSString *contractAddress;
@property (nonatomic, copy) NSString *cumulativeGasUsed;
@property (nonatomic, copy) NSString *gasUsed;
@property (nonatomic, copy) NSString *confirmations;
@property (nonatomic, copy) NSString *isError;
@property (nonatomic, copy) NSString *direction;
@property (nonatomic, copy) NSString *is_to_more;
@property (nonatomic, copy) NSString *detaInfoUrl;//hash详情
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL is_out;
@property (nonatomic, assign) NSInteger decimals;

@property (nonatomic, copy) NSString *token_name;


@end

NS_ASSUME_NONNULL_END
