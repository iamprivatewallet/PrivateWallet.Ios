//
//  User.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/18.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property (copy, nonatomic) NSString<Optional> *user_name;
@property (copy, nonatomic) NSString<Optional> *user_pass;
@property (copy, nonatomic) NSString<Optional> *user_pass_tip;
@property (copy, nonatomic) NSString<Optional> *user_mnemonic;

@property (assign, nonatomic) BOOL user_is_backup;

@property (assign, nonatomic) BOOL user_is_login;

@property (strong, nonatomic) UIImage *user_image;

@property (copy, nonatomic) NSString<Optional> *current_name;
@property (copy, nonatomic) NSString<Optional> *current_chainId;
@property (copy, nonatomic) NSString<Optional> *current_Node;


@property (copy, nonatomic) NSString<Optional> *chooseWallet_type;
@property (copy, nonatomic) NSString<Optional> *chooseWallet_address;

@property (strong, nonatomic, readonly) NSDictionary *user_info;


@end

NS_ASSUME_NONNULL_END
