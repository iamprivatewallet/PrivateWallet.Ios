//
//  MOSETHGasModel.h
//  MOS_Client_IOS
//
//  Created by mnz on 2020/12/7.
//  Copyright © 2020 WangQJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOSETHGasModel : NSObject

@property (nonatomic, assign) NSUInteger fast;
@property (nonatomic, assign) NSUInteger fastest;
@property (nonatomic, assign) NSUInteger safeLow;
@property (nonatomic, assign) NSUInteger average;
@property (nonatomic, assign) NSTimeInterval block_time;
@property (nonatomic, assign) NSUInteger blockNum;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat safeLowWait;
@property (nonatomic, assign) CGFloat avgWait;
@property (nonatomic, assign) CGFloat fastWait;
@property (nonatomic, assign) CGFloat fastestWait;
@property (nonatomic, copy) NSDictionary *gasPriceRange;

//将上边的值转成gwei
+ (NSString *)getGweiWithValue:(NSUInteger)value;
//根据Gwei和gas计算法币价值，以太坊转账gaslimit基本只要21000左右，ERC20代币4-50000左右。
+ (NSString *)calcRMBGwei:(CGFloat)gwei gas:(CGFloat)gas ethRMBPrice:(NSString *)ethPrice;
//gwei转gasPrice十六进制
+ (NSString *)gasPriceHexWithGwei:(NSString *)gwei;

//"fast":230,
//"fastest":360,
//"safeLow":132,
//"average":150,
//"block_time":11.535714285714286,
//"blockNum":11403329,
//"speed":0.9976548070972877,
//"safeLowWait":8.3,
//"avgWait":1.2,
//"fastWait":0.5,
//"fastestWait":0.4,
//"gasPriceRange":{
//    "4":192.3,
//    "6":192.3,
//}

@end

NS_ASSUME_NONNULL_END
