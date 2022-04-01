//
//  UserManage.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/18.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

#define User_manager [UserManager sharedInstance]

@interface UserManager : NSObject

@property (nonatomic, strong, readonly) User *currentUser;


+(instancetype)sharedInstance;
// 用户登录
- (BOOL)loginWithUserName:(NSString *)username
             withPassword:(NSString *)password
                withPwTip:(NSString *)tips
             withMnemonic:(NSString *)mnemonic
                 isBackup:(BOOL)isBackup;
// 用户登出
- (void)logout;

//是否登录
-(BOOL)isLogin;
//是否备份
-(BOOL)isBackup;

-(void)updateUserName:(NSString *)name;

-(void)updateUserImage:(UIImage *)image;

- (void)saveTask;

-(void)saveMnemonic:(NSString *)mnemonic;

-(void)updateCurrentNode:(NSString *)node chainId:(NSString *)chainId name:(NSString *)name;

-(void)updateChooseWallet:(Wallet *)wallet;

@end

NS_ASSUME_NONNULL_END
