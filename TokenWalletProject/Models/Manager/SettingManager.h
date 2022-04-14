//
//  SettingManager.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/29.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wallet.h"

static NSString * _Nonnull const kETHChainId = @"1";
static NSString * _Nonnull const kBSCChainId = @"56";
static NSString * _Nonnull const kHECOChainId = @"128";
static NSString * _Nonnull const kCVNChainId = @"168";

static NSString * _Nonnull const kETHRPCUrl = @"https://mainnet.infura.io/v3/02979c20665f4db5a07f7f0e4fc14fb7";
static NSString * _Nonnull const kBSCRPCUrl = @"https://bsc-dataseed1.binance.org";
static NSString * _Nonnull const kHECORPCUrl = @"https://http-mainnet.hecochain.com";
static NSString * _Nonnull const kCVNRPCUrl = @"http://52.220.97.222:1235";

@interface SettingManager : NSObject

+(instancetype)sharedInstance;

//当前是否使用touch id
@property (nonatomic, assign) BOOL isUseTouchID;

//当前u语言
@property (nonatomic, strong) NSString *langage;

//当前货币
@property (nonatomic, strong) NSString *money;

- (void)checkImportWallet;
- (NSString * _Nullable)getCurrentAddress;
- (Wallet * _Nullable)getCurrentWallet;

//设置当前选的节点
-(void)setNode:(NSString *)node chianId:(NSString *)chianId;
-(NSString *)getNodeWithChainId:(NSString *)chainId;
//当前选的节点
-(int)getNodeChainId;
-(NSString *)getChainType;
-(NSString *)getChainCoinName;
-(NSString *)getNodeNameWithChainId:(NSString *)chainId;
-(NSArray *)getNodeArrayWithChainId:(NSString *)chainId;
-(void)getNodeChainIdWithCompletionHandler:(void (^ _Nullable)(NSString * _Nullable chainId))completionHandler;
//预制的节点
-(NSArray *)getCurrentNode;
//自定义节点
-(void)setCustomNodeArray:(NSArray *)array;
-(NSArray *)getCustomNodeArray;

-(void)addNode:(NSDictionary *)dic;

//地址
-(void)setAddressArray:(NSArray *)array;

-(NSArray *)getAddressArray;

- (BOOL)isExistAddress:(NSString *)addr;

-(void)addAddress:(NSDictionary *)dic;

-(void)deleteAddress:(NSString *)address;

-(void)editOldAddress:(NSString *)addr forNewAddress:(NSDictionary *)dic;

@end
