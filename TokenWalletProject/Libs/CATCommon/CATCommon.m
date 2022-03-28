//
//  CATCommon.m
//  Catering
//
//  Created by 王 强 on 14-8-12.
//  Copyright (c) 2014年 jackygood. All rights reserved.
//

#import "CATCommon.h"
#import "MBProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#include <sys/param.h>
#include <sys/mount.h>
#import <Accelerate/Accelerate.h>
#include <sys/xattr.h>
#import <CommonCrypto/CommonDigest.h>
#import <ImageIO/ImageIO.h>

@implementation CATCommon

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (NSString *)numberFormat:(int)number
{
    NSMutableString * mutString = [NSMutableString stringWithFormat:@"%d",number];
    if (number < 1000) {
        
    }else if((number >= 1000)&&(number < 10000)){
        [mutString insertString:@"," atIndex:[mutString length]-3];
        
    }else{
        if((number >= 10000)&&(number < 10000000)){
            [mutString insertString:@"." atIndex:[mutString length]- 4];
        } else {
            
            [mutString insertString:@"," atIndex:[mutString length] - 7];
            [mutString insertString:@"." atIndex:[mutString length] - 4];
        }
        [mutString deleteCharactersInRange:NSMakeRange([mutString rangeOfString:@"."].location + 2, 2)];
        [mutString appendString:@"万"];
    }
    return mutString;
}

+ (NSString *)datsStringWithTimeInterval:(long long)interval
{
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:interval/1000];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *tempString=[dateFormatter stringFromDate:date];
    
    tempString = [CATCommon modifyTimeDisp:tempString];
    return tempString;
}

+(NSString *)modifyTimeDisp:(NSString *)_timeString
{
    NSString *tempTimeString=[NSString stringWithFormat:@"%@",_timeString];
    NSString *retTimeString=@"";
    if([tempTimeString isEqualToString:@""])
    {
        retTimeString=@" ";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [dateFormatter dateFromString:tempTimeString];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *tempValue=[dateFormatter stringFromDate:date];
        //判断是否为今天
        if([tempValue isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
        {
            NSTimeInterval timeInterval=[[NSDate date] timeIntervalSinceDate:date];
            //判断时间差是否在一个小时之内
            if(timeInterval<3600)
            {
                //显示"多少分钟前"
                int tempValue=timeInterval/60;
                retTimeString=[NSString stringWithFormat:@"%d分钟前",tempValue];
            }
            else
            {
                //显示"多少小时前"
                int tempValue=timeInterval/(60 * 60);
                retTimeString=[NSString stringWithFormat:@"%d小时前",tempValue];
            }
        }
        else
        {
            //显示"几几年几月几号"
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            retTimeString=[dateFormatter stringFromDate:date];
        }
    }
    return retTimeString;
}

//获取图片
+(UIImage *)imageNamed:(NSString *)_imageName
{
    UIImage *tempImage = nil;
    if (_imageName ==nil
        ||_imageName.length == 0)
    {
        
    }
    else if ([_imageName hasSuffix:@".png"]
             ||[_imageName hasSuffix:@".jpg"])
    {
        NSString *extension = [_imageName pathExtension];
        NSString *path = [[NSBundle mainBundle] pathForResource:[_imageName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",extension] withString:@""] ofType:extension];
        tempImage = [UIImage imageWithContentsOfFile:path];
    }
    else
    {
        int scale = (int)[UIScreen mainScreen].scale;
        if (scale<=2)
        {
            scale = 2;
        }
        else
        {
            scale = 3;
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx",_imageName,scale] ofType:@"png"];
        tempImage = [UIImage imageWithContentsOfFile:path];
    }
    return tempImage;
}

+ (BOOL)isHaveAuthorForCamer
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (authStatus == AVAuthorizationStatusDenied)
        {
            NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
            
            TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"相机相关权限被禁止了" message:[NSString stringWithFormat:@"请在 设置 - 隐私 - 相机 中\n开启%@的访问权限",appName]];
            [alertView addAction:[TYAlertAction actionWithTitle:@"知道了" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
                
            }]];
            [alertView showInWindow];
            
            return NO;
        }
        return YES;
    }
    return YES;
}

+ (BOOL)isHaveAuthorForLibrary
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
    {
        //无权限
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"相机相关权限被禁止了" message:[NSString stringWithFormat:@"请在 设置 - 隐私 - 相册 中\n开启%@的访问权限",appName]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"知道了" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            
        }]];
        [alertView showInWindow];
        
        return NO;
    }
    return YES;
}
+(int)getSysUTCTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *tempString=[dateFormatter stringFromDate:[NSDate date]];
    
    int timestamp=[[NSDate date]timeIntervalSince1970];
    timestamp=[[dateFormatter dateFromString:tempString] timeIntervalSince1970];
    return timestamp;
}

+(BOOL)isEmailAddress:(NSString*)email
{
    
    //NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}


+(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+(UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}

//绘制渐变色颜色的方法
+(CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}

+(NSString *)hexString:(NSString *)string minLength:(NSInteger)mLength
{
    //补位
    NSMutableString *hexStr=[[NSMutableString alloc]initWithCapacity:mLength];
    for (int i = 0; i < mLength - string.length; ++i) {
        [hexStr appendString:@"0"];
    }
    return [NSString stringWithFormat:@"%@%@",hexStr,string];
}

+ (NSString *)getRandomStringWithNum:(NSInteger)num
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

+ (BOOL)isEmptyWith:(NSString*)text
{
    if (text && ![text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

+(NSString *)timeStampConversionNSString:(NSString *)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

#pragma json转字典字符串方法
+(NSDictionary *)JSONTurnDict:(NSString *)Json{
    if (Json.length == 0) {
        return @{};
    }
    NSData *jsonData = [Json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    return dic;
}
#pragma 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+(NSString *)JSONString:(NSString *)aString {
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}
#pragma 十六进制转data
+ (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}
+(NSString *)balanceToPower18:(NSString *)balance{
    if (balance.length == 0) {
        balance = @"0";
    }else{
        balance = balance;
    }
    NSDecimalNumber* chufa1 = [NSDecimalNumber decimalNumberWithMantissa:1
                                                                exponent:18
                                                              isNegative:NO];
    NSDecimalNumber*chufa2 = [NSDecimalNumber decimalNumberWithString:balance];
    NSDecimalNumber* ethV = [chufa2 decimalNumberByDividingBy:chufa1];
    return [self DecimalDigits:[NSString stringWithFormat:@"%@",ethV] Scale:4];
}
+(NSString *)DecimalDigits:(NSString *)decimal Scale:(int)scale{
    if (decimal.length != 0) {
        NSArray *array = [decimal componentsSeparatedByString:@"."];
        if (array.count == 2) {
            NSString *str = array[1];
            if (str.length > 0) {
                NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                NSDecimalNumber*ouncesDecimal;
                NSDecimalNumber*roundedOunces;
                ouncesDecimal = [NSDecimalNumber decimalNumberWithString:decimal];
                roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
                NSString *rounded;
                NSArray *array = [[NSString stringWithFormat:@"%@",roundedOunces] componentsSeparatedByString:@"."];
                NSString *str = array[1];
                if (str.length == 1) {
                    rounded = [NSString stringWithFormat:@"%@0",roundedOunces];
                }else{
                    rounded = [NSString stringWithFormat:@"%@",roundedOunces];
                }
                return rounded;
            }
        }else{
            return [NSString stringWithFormat:@"%@.00",decimal];
        }
    }
    return @"0.00";
}
@end
