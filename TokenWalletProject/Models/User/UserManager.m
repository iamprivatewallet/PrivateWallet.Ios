//
//  UserManage.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/18.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager
+(instancetype)sharedInstance
{
    static UserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init
{
    if (self = [super init]) {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:User_Info_Key];
        NSString *user_name = [userInfo objectForKey:@"user_name"];
        NSString *user_pass = [userInfo objectForKey:@"user_pass"];
        NSString *user_pass_tip = [userInfo objectForKey:@"user_pass_tip"];
        NSString *user_mnemonic = [userInfo objectForKey:@"user_mnemonic"];
        NSString *currentNode = [userInfo objectForKey:@"current_Node"];
        NSString *currentNodeName = [userInfo objectForKey:@"current_name"];
        NSString *currentNodeChainId = [userInfo objectForKey:@"current_chainId"];
        NSString *chooseWallet_type = [userInfo objectForKey:@"chooseWallet_type"];
        NSString *chooseWallet_address = [userInfo objectForKey:@"chooseWallet_address"];

        BOOL login = [[userInfo objectForKey:@"user_login"] boolValue];
        BOOL backup = [[userInfo objectForKey:@"user_backup"] boolValue];

        User *user= [[User alloc] init];
        user.user_name = [user_name isNoEmpty] ? user_name : kDefaultUserName;
        user.user_pass = [user_pass isNoEmpty] ? user_pass : @"";
        user.user_is_login = login;
        user.user_is_backup = backup;
        user.user_mnemonic = user_mnemonic;
        user.user_pass_tip = user_pass_tip;
        user.user_image = [self fetchUserImage];
        user.current_Node = currentNode;
        user.current_chainId = currentNodeChainId;
        user.current_name = currentNodeName;
        user.chooseWallet_address = chooseWallet_address;
        user.chooseWallet_type = chooseWallet_type;
        _currentUser = user;
    }
    return self;
}

-(BOOL)isLogin {
    return self.currentUser.user_is_login;
}
-(BOOL)isBackup {
    return self.currentUser.user_is_backup;
}
// 用户登录
- (BOOL)loginWithUserName:(NSString *)username
             withPassword:(NSString *)password
                withPwTip:(NSString *)tips
             withMnemonic:(NSString *)mnemonic
             isBackup:(BOOL)isBackup {
    if (password.length <= 0) {
        [[ToastHelper sharedToastHelper] toast:LocalizedStr(@"text_fail")];
        return NO;
    }
    User *user= [[User alloc] init];
    user.user_name = username;
    user.user_pass = password;
    user.user_pass_tip = tips;
    user.user_is_login = YES;
    user.user_is_backup = isBackup;
    user.user_mnemonic = mnemonic;
    user.user_image = [self fetchUserImage];
    user.current_name = [[SettingManager sharedInstance] getNodeNameWithChainId:kETHChainId];
    user.current_Node = [[SettingManager sharedInstance] getNodeWithChainId:kETHChainId];
    user.current_chainId = kETHChainId;
    SetUserDefaultsForKey(@"1", @"isFirstTransfer");
    [self saveCurrentUser:user];
    return YES;
}

// 用户登出
- (void)logout {
    self.currentUser.user_is_login = NO;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:User_Info_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [PW_GlobalTool clear];
    [PW_DBGlobalTool clear];
//    //删除数据库
//    NSString *dbName = @"JQFMDB.sqlite";
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
//    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}
-(void)saveCurrentUser:(User *)currentUser
{
    _currentUser = currentUser;
//    [self UserImageDeleting];
    [[NSUserDefaults standardUserDefaults] setObject:currentUser.user_info forKey:User_Info_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveTask{
    User *user = [[User alloc] init];
    user.user_name = self.currentUser.user_name;
    user.user_pass = self.currentUser.user_pass;
    user.user_pass_tip = self.currentUser.user_pass_tip;
    user.user_is_backup = self.currentUser.user_is_backup;
    user.user_is_login = self.currentUser.user_is_login;
    user.user_mnemonic = self.currentUser.user_mnemonic;
    user.user_image = [self fetchUserImage];
    user.current_name = self.currentUser.current_name;
    user.current_Node = self.currentUser.current_Node;
    user.current_chainId = self.currentUser.current_chainId;
    user.chooseWallet_type = self.currentUser.chooseWallet_type;
    user.chooseWallet_address = self.currentUser.chooseWallet_address;

    [self saveCurrentUser:user];
}

-(void)updateCurrentNode:(NSString *)node chainId:(NSString *)chainId name:(NSString *)name
{
    self.currentUser.current_Node = node;
    self.currentUser.current_name = name;
    self.currentUser.current_chainId = chainId;
    [self saveCurrentUser:self.currentUser];
}
-(void)updateChooseWallet:(Wallet *)wallet
{
    self.currentUser.chooseWallet_type = wallet.type;
    self.currentUser.chooseWallet_address = wallet.address;
    [self saveCurrentUser:self.currentUser];
}
-(void)updateUserName:(NSString *)name
{
    [[PW_WalletManager shared] updateWalletOwner:name];
    self.currentUser.user_name = name;
    [self saveCurrentUser:self.currentUser];
}

-(void)saveMnemonic:(NSString *)mnemonic
{
    self.currentUser.user_mnemonic = mnemonic;
    [self saveCurrentUser:self.currentUser];
}

-(void)updateUserImage:(UIImage *)image
{
    self.currentUser.user_image = image;
    NSData * data = UIImageJPEGRepresentation(image, .5);
    [data writeToFile:[self userImagePath] atomically:YES];
}

-(NSString *)userImagePath
{
    NSArray *documents =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *document = documents.firstObject;
    NSString *path = [document stringByAppendingPathComponent:@"user_image"];
    return path;
}
-(void)UserImageDeleting{
    NSFileManager *fileMger = [NSFileManager defaultManager];
    NSArray *documents =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *document = documents.firstObject;
    NSString *path = [document stringByAppendingPathComponent:@"user_image"];
    BOOL bRet = [fileMger fileExistsAtPath:path];
    if (bRet) {
        NSError *err;
        [fileMger
         removeItemAtPath:path
         error:&err];
    }
}
-(UIImage *)fetchUserImage
{
    UIImage *image = nil;
    NSData *data = [NSData dataWithContentsOfFile:[self userImagePath]];
    if (data) {
        image = [[UIImage alloc] initWithData:data];
    } else {
        image = [UIImage imageNamed:@"touxiang"];;
    }
    return image;
}

@end
