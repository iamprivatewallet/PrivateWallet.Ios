//
//  PW_AddressBookModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddressBookModel.h"

@implementation PW_AddressBookModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.time = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

@end
