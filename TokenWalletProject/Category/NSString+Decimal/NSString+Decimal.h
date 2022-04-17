//
//  NSString+Decimal.h
//  TokenWalletProject
//
//  Created by jackygood on 2018/12/25.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Decimal)

- (NSString*)stringRaisingToPower18;
- (NSString*)stringDownToPower18;
- (NSString*)stringDownPower:(short)power;//次方
- (NSString*)stringDownPower:(short)power decimal:(short)decimal;
- (NSString*)stringDownDecimal:(short)decimal;//保留几位小数
- (NSString*)stringDownAdding:(NSString *)other;
- (NSString*)stringDownAdding:(NSString *)other decimal:(short)decimal;
- (NSString*)stringDownSubtracting:(NSString *)other;
- (NSString*)stringDownSubtracting:(NSString *)other decimal:(short)decimal;
- (NSString*)stringDownMultiplyingBy:(NSString *)other;
- (NSString*)stringDownMultiplyingBy:(NSString *)other decimal:(short)decimal;
- (NSString*)stringDownDividingBy:(NSString *)other;
- (NSString*)stringDownDividingBy:(NSString *)other decimal:(short)decimal;
- (NSString*)stringDownMultiplyingBy10Power:(short)power;//乘10的power次方
- (NSString*)stringDownMultiplyingBy10Power:(short)power scale:(short)scale;
- (NSString*)stringDownDividingBy10Power:(short)power;//除10的power次方
- (NSString*)stringDownDividingBy10Power:(short)power scale:(short)scale;
- (NSString*)stringDownToPowerL:(NSUInteger)number;
- (NSData *)toHexData;
- (NSString *)HexStringWithData:(NSData *)data;
- (int)stringTo10;
- (NSString *)getHex;
- (BOOL)isContract;
- (NSString*)formatToEth;//+0x
- (NSString*)formatToCVN;//+cvn
- (NSString*)contractPrefix;
- (NSString*)formatDelCVN;//-cvn
- (NSString*)formatDelEth;//-0x
- (NSString*)toFloat0;
- (NSString*)trim;
- (NSString *)hexString;
-(NSString *)NSDecimalNumberHandler;

@end

NS_ASSUME_NONNULL_END
