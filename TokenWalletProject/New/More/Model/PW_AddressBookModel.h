//
//  PW_AddressBookModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_AddressBookModel : PW_BaseModel

@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, copy) NSString *chainName;

@end

NS_ASSUME_NONNULL_END
