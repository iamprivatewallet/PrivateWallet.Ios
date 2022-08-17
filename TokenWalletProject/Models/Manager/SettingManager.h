//
//  SettingManager.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/29.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wallet.h"

@interface SettingManager : NSObject

+(instancetype)sharedInstance;

//当前是否使用touch id
@property (nonatomic, assign) BOOL isUseTouchID;

//当前u语言
@property (nonatomic, strong) NSString *langage;

//当前货币
@property (nonatomic, strong) NSString *money;

- (NSString * _Nullable)getCurrentAddress;
- (Wallet * _Nullable)getCurrentWallet;

//设置当前选的节点
-(void)setNode:(NSString *)node chianId:(NSString *)chianId;
-(NSString *)getNodeWithChainId:(NSString *)chainId;
//当前选的节点
-(int)getNodeChainId;
-(NSString *)getChainType;
-(NSString *)getChainCoinName;
-(NSString *)getNetworkNameWithChainId:(NSString *)chainId;
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
