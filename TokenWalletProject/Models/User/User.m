//
//  User.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/18.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "User.h"

@implementation User
-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

-(NSDictionary *)user_info
{
    NSDictionary *info = @{
        @"user_name":self.user_name?:@"",
        @"user_pass":self.user_pass?:@"",
        @"user_login": [NSNumber numberWithBool:self.user_is_login],
        @"user_backup": [NSNumber numberWithBool:self.user_is_backup],
        @"user_pass_tip":self.user_pass_tip?:@"",
        @"user_mnemonic":self.user_mnemonic?:@"",
        @"current_Node":self.current_Node?:@"",
        @"current_name":self.current_name?:@"",
        @"current_chainId":self.current_chainId?:@"",
        @"chooseWallet_type":self.chooseWallet_type?:@"",
        @"chooseWallet_address":self.chooseWallet_address?:@""
    };
    return info;
}

@end
