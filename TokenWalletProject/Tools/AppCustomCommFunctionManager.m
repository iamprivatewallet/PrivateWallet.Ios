//
//  AppCustomCommFunctionManager.m
//  CreditApp
//
//  Created by sunlinlin on 16/1/28.
//  Copyright © 2016年 Shanghai DianRong Financial Services Co., Ltd. All rights reserved.
//

#import "AppCustomCommFunctionManager.h"
#import "sys/utsname.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/sysctl.h>
#import <CoreLocation/CLLocationManager.h>

static AppCustomCommFunctionManager* g_appCustomCommFuntionManager = nil;
static dispatch_once_t g_predicate;

@implementation AppCustomCommFunctionManager

+(AppCustomCommFunctionManager*)appCustomCommFunctionManagerInstance
{
    dispatch_once(&g_predicate, ^{
        g_appCustomCommFuntionManager = [[AppCustomCommFunctionManager alloc]init];
    });

    return g_appCustomCommFuntionManager;
}

- (id)init{
    if (self=[super init]) {
        
    }
    return self;
}

//判断是否都是数字
- (BOOL)isAllDigit:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//获取系统版本
- (NSString*)getSystemVersion{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion;
}

//获取Appversion
- (NSString*)getAppVersionString{
    NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
    NSString* versionStr = [localDic objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@",versionStr];
}

//判断是否是全英文
- (BOOL)isChinese:(NSString*)content{
    for(int i=0; i< [content length];i++)
    {
        int a = [content characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

//根据时间戳获得时间
- (NSString*)fromatStringFromSecond:(NSInteger)time format:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *strdate = [dateFormatter stringFromDate:messageDate];
    if([strdate hasPrefix:@"1970-01-01"]){
        return @"";
    }
    return strdate;
}

//上个月的的时间
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

//获取某年某月的天数
- (NSInteger)daysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}

- (NSString *)getLoanUnit:(NSString *)unit{
    if ([unit isEqual:@"MONTHLY"]) {
        return @"个月";
    }else if ([unit isEqual:@"DOUBLEWEEKLY"]){
        return @"个双周";
    }else if ([unit isEqual:@"DAILY"]){
        return @"天";
    }else if ([unit isEqual:@"WEEKLY"]){
        return @"周";
    }

    return @"个月";
}

//判断定位是否打开
- (BOOL)determineWhetherTheAPPOpensTheLocation{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] ==kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] ==kCLAuthorizationStatusAuthorizedAlways)){
        return YES;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        return NO;

    }else{
        return NO;
    }
}

- (NSDate *)getLastOneMonth:(NSDate *)date value:(NSInteger)value{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -value;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

//下一个月的时间
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSString *)timeStringFromDateAndFormatter:(NSDate *)date formatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [dateFormatter stringFromDate:date];

}

//获取下某一个月的时间
- (NSDate *)getNextOneMonth:(NSDate *)date value:(NSInteger)value{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +value;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

//时间
- (NSString*)stringFromTime:(NSInteger)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *strdate = [dateFormatter stringFromDate:messageDate];

    NSTimeInterval late = [messageDate timeIntervalSince1970];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    NSTimeInterval sub = now - late;
    if (sub / 86400 < 1) {
        return  [NSString stringWithFormat:@"今天"];
    } else if (sub / 86400 >= 1 && sub / 86400 < 2) {
        return  [NSString stringWithFormat:@"昨天"];
    } else {
        return  strdate;
    }
}

- (NSDate*)dateFromStr:(NSString*)dateStr format:(NSString*)format{
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:GTMzone];
    NSDate *bdate = [dateFormatter dateFromString:dateStr];
    return bdate;
}

//时间格式2
- (NSString*)stringNewFormatFromTime:(NSInteger)time{
    NSDate* messageDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSTimeInterval late = [messageDate timeIntervalSince1970];
    NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    NSTimeInterval sub = now - late;

    NSString* timeFrom = [self fromatStringFromSecond:time format:@"yyyy-MM-dd"];
    NSDate* dateFrom = [self dateFromStr:timeFrom format:@"yyyy-MM-dd"];

    NSString* timeTo = [self stringFromDate:nowDate format:@"yyyy-MM-dd"];
    NSDate* dateTo = [self dateFromStr:timeTo format:@"yyyy-MM-dd"];
    if (sub / 86400 < 1) {
        NSInteger hour = sub/3600;
        if (hour == 0) {
           return [self fromatStringFromSecond:time format:@"HH:mm"];
        }else{
            NSInteger day = [self xiangChaDays:dateFrom dateToday:dateTo];
            if (day == 1) {
                //return  [NSString stringWithFormat:@"昨天%@",[self fromatStringFromSecond:time format:@"HH:mm"]];
                return  [NSString stringWithFormat:@"昨天"];
            }else{
                //return [NSString stringWithFormat:@"%ld小时前",(long)hour];
                return  [NSString stringWithFormat:@"今天"];
            }
        }
    } else if (sub / 86400 >= 1 && sub / 86400 < 2) {
        NSInteger day = [self xiangChaDays:dateFrom dateToday:dateTo];
        if (day == 1) {
            //return  [NSString stringWithFormat:@"昨天%@",[self fromatStringFromSecond:time format:@"HH:mm"]];
            return  [NSString stringWithFormat:@"昨天"];
        }else{
            return [self fromatStringFromSecond:time format:@"yyyy-MM-dd"];
        }

    } else {
        return [self fromatStringFromSecond:time format:@"yyyy-MM-dd"];
    }
    
}

//计算日期相差的天数
- (NSInteger)xiangChaDays:(NSDate*)dateStart dateToday:(NSDate*)dateToday{

    //创建一个日历牌对象
    NSCalendar *calender=[NSCalendar currentCalendar];

    //枚举保存日期的每一天
    NSCalendarUnit unitsave=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;

    //计算日期
    NSDateComponents *comTogether=[calender components:unitsave fromDate:dateStart toDate:dateToday options:NSCalendarMatchFirst];

    return comTogether.day;
}
//获取手机型号
- (NSString*)getPhoneModel{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([model isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([model isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([model isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([model isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([model isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([model isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([model isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([model isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([model isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([model isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([model isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([model isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([model isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([model isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([model isEqualToString:@"iPhone8,1"])    return @"iPhone 6s Plus";
    if ([model isEqualToString:@"iPhone8,2"])    return @"iPhone 6s";
    return model;
}

- (NSString *)getDevicePlatform {
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])
    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])
    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])
    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])
    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])
    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])
    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])
    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])
    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])
    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])
    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,4"])
    return @"iPhone 5c (UK+Europe+Asis+China)";
    if ([platform isEqualToString:@"iPhone6,1"])
    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,2"])
    return @"iPhone 5s (UK+Europe+Asis+China)";
    if ([platform isEqualToString:@"iPhone7,1"])
    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])
    return @"iPhone 6";

    if ([platform isEqualToString:@"iPod1,1"])
    return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])
    return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])
    return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])
    return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])
    return @"iPod Touch (5 Gen)";

    if ([platform isEqualToString:@"iPad1,1"])
    return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])
    return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])
    return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])
    return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])
    return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])
    return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])
    return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])
    return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])
    return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])
    return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])
    return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])
    return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])
    return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])
    return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])
    return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])
    return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])
    return @"iPad Air (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,4"])
    return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])
    return @"iPad Mini Retina (GSM+CDMA)";

    if ([platform isEqualToString:@"i386"])
    return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])
    return @"Simulator";
    return platform;
}

//返回当前月数和号数的字符串
- (NSString*)currentDayAndMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;

    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];

    NSInteger iCurMonth = [components month];  //当前的月份

    NSInteger iCurDay = [components day];  // 当前的号数

    return [NSString stringWithFormat:@"%lu.%lu",(long)iCurMonth,(long)iCurDay];
}

//返回当前年月日 例如：[components year], [components month], [components day]
- (NSDateComponents *)currentYearMonthDay {
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    return components;
}

- (NSDateComponents *)componentsByDate:(NSDate *)date{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    return components;

}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (NSString *)getYesterDayDate:(NSDate *)date format:(NSString *)format{
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
    return [self timeStringFromDateAndFormatter:lastDay formatter:format];
}
//这个月有几天
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}
//获取当前月有多少天
- (NSInteger)daysOfCurrentMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];

    NSUInteger numberOfDaysInMonth = range.length;

    return numberOfDaysInMonth;
}

//NSdate转NSString
- (NSString*)stringFromDate:(NSDate*)date format:(NSString*)format
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString* strDate = [dateFormatter stringFromDate:date];

    return strDate;
}

//获取上一个月的月份
- (NSInteger)lastMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *adcomps = [[NSDateComponents alloc] init];

    [adcomps setYear:0];

    [adcomps setMonth:-1];

    [adcomps setDay:0];

     NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    NSString* time = [self stringFromDate:newdate format:@"MM"];

    return [time integerValue];
}

//获取当前星期的第一天
- (NSString*)getTheFirstDayOfWeek:(NSString*)format{
    NSDate* date=[NSDate date];
    date = [[AppCustomCommFunctionManager appCustomCommFunctionManagerInstance] dateStartOfWeek:date];
    NSString* dateStr = [self stringFromDate:date format:format];
    return dateStr;
}

//获取当前的一星期
-(NSMutableArray*)getWeekFromToday
{
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
    NSDate* date=[NSDate date];
    date = [[AppCustomCommFunctionManager appCustomCommFunctionManagerInstance] dateStartOfWeek:date];
    NSString* dateStr = [self stringFromDate:date format:@"yyyy-MM-dd HH:mm:ss"];
    date = [self dateFromStr:dateStr];
    [muArr addObject:date];

    for(int i=0;i<6;i++)
    {
        date = [self GetTomorrowDay:date];
        NSString* dateStr = [self stringFromDate:date format:@"MM.dd"];
        [muArr addObject:dateStr];
    }

    return muArr;
}

//上个月的的时间
- (NSDate *)lastMonthByDate:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

//下一个月的时间
- (NSDate*)nextMonthByDate:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

//计算两个时间的时间差
- (NSDateComponents *)dateComponentsBetweenStartAndEnd:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc]init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSDate *endDate = [dateFomatter dateFromString:endTime];
    NSDate *startDate = [dateFomatter dateFromString:startTime];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents *dateCom = [calendar components:unit fromDate:startDate toDate:endDate options:0];

    return dateCom;
}


//获取上一个星期
- (NSMutableArray*)getLastWeek:(NSString*)format{
    NSMutableArray* muArr = [[NSMutableArray alloc]init];
    NSDate* date=[self lastWeekDay:[NSDate date]];
    date = [[AppCustomCommFunctionManager appCustomCommFunctionManagerInstance] dateStartOfWeek:date];
    NSString* dateStr = [self stringFromDate:date format:format];
    [muArr addObject:dateStr];

    for(int i=0;i<6;i++)
    {
        date = [self GetTomorrowDay:date];
        NSString* dateStr = [self stringFromDate:date format:format];
        [muArr addObject:dateStr];
    }

    return muArr;
}

- (NSDate*)dateFromStr:(NSString*)dateStr
{
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:GTMzone];
    NSDate *bdate = [dateFormatter dateFromString:dateStr];
    return bdate;
}

- (NSInteger)timeIntergerFormString:(NSString *)dateStr formatter:(NSString *)formatter{
    NSTimeZone* GTMzone = [NSTimeZone systemTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setTimeZone:GTMzone];
    NSDate *bdate = [dateFormatter dateFromString:dateStr];
    NSTimeInterval timeInterVal = [bdate timeIntervalSince1970];
    return timeInterVal;
}

-(NSDate *)GetTomorrowDay:(NSDate *)aDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];

    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    return beginningOfWeek;
}

//上个礼拜的的时间
- (NSDate *)lastWeekDay:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.weekday = -7;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSString *)deviceIPAddress{
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;

    success = getifaddrs(&interfaces);

    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}


//判断时间是否是同一星期返回传入时间的开始日期,如果两个开始日期相同则是同一星期
/*
 NSGregorianCalendar 阳历
 NSBuddhistCalendar 佛历
 NSChineseCalendar 中国日历
 NSHebrewCalendar 希伯来日历
 NSIslamicCalendar 伊斯兰日历
 NSIslamicCivilCalendar 伊斯兰民事日历
 NSJapaneseCalendar 日本日历
 */
- (NSDate*)dateStartOfWeek:(NSDate*)date
{
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    [gregorian setFirstWeekday:2];//设置星期从星期一开始

    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];

    NSDateComponents* componentsToSubtract = [[NSDateComponents alloc] init];

    [componentsToSubtract setDay:-((([components weekday]-[gregorian firstWeekday])+7)%7)];

    NSDate* beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];

    return beginningOfWeek;
}

//获取当前月所有的天数
- (NSMutableArray*)currentMonthAllDays:(int)type{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;

    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];

    NSInteger iCurMonth = [components month];  //当前的月份

    NSInteger iCurDay = [components day];  // 当前的号数

    NSMutableArray *arr = [[NSMutableArray alloc]init];

    if (type==0) {
        for (NSInteger i = 1; i <= iCurDay; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }else{
        for (NSInteger i = 1; i <= iCurMonth; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }
    return arr;
}

//复制
- (void)copyLink:(NSString*)url {
    [[UIPasteboard generalPasteboard] setString:url ?: @""];
}

//拨打电话
- (void)telephoneCall:(NSString*)number{
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
}

- (UIView *)topView {
    // when showing an alertView, the keyWindow can become an _UIAlertNormalizingOverlayWindow
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (rootViewController.presentedViewController) {
        rootViewController = rootViewController.presentedViewController;
    }
    return rootViewController.view;
}

//获取文字高度
- (CGSize)getTextSize:(NSString *)text rect:(CGSize)rect attribute:(NSDictionary *)attribute{
    CGSize size = [text boundingRectWithSize:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return size;
}
//客户推荐类型
- (NSString *)recommendType:(NSString *)sourceType{
    if ([sourceType isEqualToString:@"SHUO_JIE"]) {
        return @"客户推荐";
    }
    return nil;
}

- (UINavigationController *)currentNavigationController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        topVC = ((UINavigationController *)topVC);
    }else if ([topVC isKindOfClass:[UITabBarController class]]){
            UIViewController *currentVc = [(UITabBarController *)topVC selectedViewController];
            if ([currentVc isKindOfClass:[UINavigationController class]]) {
                topVC = (UINavigationController *)currentVc;
            }
    }
    
    return (UINavigationController *)topVC;
}


- (NSString *)hideMiddleFourNumbers:(NSString *)phoneNum{
    NSString* phone = [NSString stringWithFormat:@"%@****%@",[phoneNum substringWithRange:NSMakeRange(0, 3)],[phoneNum substringWithRange:NSMakeRange(phoneNum.length-4, 4)]];
    return phone;
}

+ (NSString *)formatLargeMoney:(id)item{
    if(item){
        if ([[item description] longLongValue]) {
            long long itemValue = [[item description] longLongValue];
            NSNumber* numValue = [NSNumber numberWithLongLong:itemValue];
            if ([[item description] longLongValue] < 100000000) {
                return  [NSString stringWithFormat:@"%.2f万元",[numValue floatValue]/10000.0];
            }else{
                return [NSString stringWithFormat:@"%.4f亿元",[numValue floatValue]/100000000.0];
            }
        }else{
            return @"0.00万元";
        }
    }else{
        return @"0.00万元";
    }
}

- (NSString *)defaultCurrencyFormatString:(NSNumber *)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0;"];
    NSString *formatted = [formatter stringFromNumber:num];
    return [NSString stringWithFormat:@"%@", formatted];
}
//判断身份证是否合规
- (BOOL)isIDCardTrueFormat:(NSString*)idCard{
    NSString *emailRegex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    bool sfzNo = [emailTest evaluateWithObject:[idCard stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

    return sfzNo;
}

+ (NSString *)reviseStringForNumber:(NSNumber *)num {
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [num doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

- (NSString *)qiniuThumbnail:(NSString *)source width:(int)width height:(int)height{
    if([source containsString:@".mp4"]){
        return [NSString stringWithFormat:@"%@/w/%d/h/%d",source,width,height];
    }
    return [NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d/interlace/1",source,width*2,height*2];
}

//七牛瘦身
- (NSString*)qiniuImageslim:(NSString *)source{
    return [NSString stringWithFormat:@"%@?imageView2/0/q/10|imageslim",source];
}

- (NSString *)qiniuImagesLim:(NSString *)source quality:(NSInteger)quality{
    return [NSString stringWithFormat:@"%@?imageView2/0/q/%ld|imageslim",source,(long)quality];
}

- (NSString *)qiniuLevelImagesLim:(NSString *)source level:(int)level{
    return [NSString stringWithFormat:@"%@?imageslim/zlevel/%d",source,level];
}

- (BOOL)isIPhoneXSeries{
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}
//跳转到系统相册
- (void)openSystmePhotos{
    NSURL *url = [NSURL URLWithString:@"photos-redirect://"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end
