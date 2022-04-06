//
//  PW_TokenDetailModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/6.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_TokenDetailModel : PW_BaseModel

@property (nonatomic, copy) NSString *tokenLogo;
@property (nonatomic, assign) NSTimeInterval timeStamp;
@property (nonatomic, copy) NSString *hashStr;
@property (nonatomic, copy) NSString *fromAddress;
@property (nonatomic, copy) NSString *toAddress;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *gas;
@property (nonatomic, copy) NSString *gasPrice;
@property (nonatomic, copy) NSString *gasUsed;
@property (nonatomic, copy) NSString *contractAddress;
@property (nonatomic, copy) NSString *tokenName;
@property (nonatomic, assign) NSInteger tokenDecimals;
@property (nonatomic, assign) NSInteger transactionStatus;
@property (nonatomic, copy) NSString *detaInfoUrl;
@property (nonatomic, assign) BOOL isOut;

@end

NS_ASSUME_NONNULL_END
