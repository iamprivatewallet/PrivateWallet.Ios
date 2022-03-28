//
//  RecordModel.m
//  TokenWalletProject
//
//  Created by FChain on 2021/10/11.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "RecordModel.h"

@implementation RecordModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"hashStr":@"hash",@"status":@"transactionStatus"};
}
@end
