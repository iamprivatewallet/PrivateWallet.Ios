//
//  CATCommon.h
//  Catering
//
//  Created by 王 强 on 14-8-12.
//  Copyright (c) 2014年 jackygood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CATCommon : NSObject


+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (NSString *)numberFormat:(int)number;

+ (NSString *)datsStringWithTimeInterval:(long long)interval;

//获取图片
+(UIImage *)imageNamed:(NSString *)_imageName;

+ (BOOL)isHaveAuthorForLibrary;

+ (BOOL)isHaveAuthorForCamer;

+(BOOL)isEmailAddress:(NSString*)email;

+(UIColor *)colorWithHexString:(NSString *)color;

+(CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

+(NSString *)hexString:(NSString *)string minLength:(NSInteger)mLength;

+ (NSString *)getRandomStringWithNum:(NSInteger)num;
+ (BOOL)isEmptyWith:(NSString*)text;

+ (NSString*)claValueWithCoin:(NSString*)coin count:(NSString*)count;
+(NSString *)timeStampConversionNSString:(NSString *)timeStamp;
+(NSString *)setUpCoinSymbol:(NSString *)coin_symbol;
+(NSString *)convertToJsonData:(NSDictionary *)dict;
+(NSString *)JSONString:(NSString *)aString;

+(NSDictionary *)JSONTurnDict:(NSString *)Json;
+ (NSData *)convertHexStrToData:(NSString *)str;
+(NSString *)balanceToPower18:(NSString *)balance;
+(NSString *)DecimalDigits:(NSString *)decimal Scale:(int)scale;
@end
