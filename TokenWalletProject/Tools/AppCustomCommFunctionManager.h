//
//  AppCustomCommFunctionManager.h
//  CreditApp
//
//  Created by sunlinlin on 16/1/28.
//  Copyright © 2016年 Shanghai DianRong Financial Services Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppCustomCommFunctionManager : NSObject

+(AppCustomCommFunctionManager*)appCustomCommFunctionManagerInstance;

//判断是否都是数字
- (BOOL)isAllDigit:(NSString *)string;
//获取系统版本
- (NSString *)getSystemVersion;
//获取手机型号
- (NSString *)getPhoneModel;
//返回当前月数和号数的字符串
- (NSString*)currentDayAndMonth;
//获取当前年月日；
- (NSDateComponents *)currentYearMonthDay;
- (NSDateComponents *)componentsByDate:(NSDate *)date;
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
- (NSString *)getYesterDayDate:(NSDate *)date format:(NSString *)format;
//获取当前月所有的天数
- (NSMutableArray*)currentMonthAllDays:(int)type;
//这个月有几天
- (NSInteger)totaldaysInMonth:(NSDate *)date;
//获取当前月有多少天
- (NSInteger)daysOfCurrentMonth;
//时间
- (NSString*)stringFromTime:(NSInteger)time;
//时间格式2
- (NSString*)stringNewFormatFromTime:(NSInteger)time;
//根据时间戳获得时间
- (NSString*)fromatStringFromSecond:(NSInteger)time format:(NSString*)format;
- (NSInteger)timeIntergerFormString:(NSString *)dateStr formatter:(NSString *)formatter;
//NSdate转NSString
- (NSString*)stringFromDate:(NSDate*)date format:(NSString*)format;
//获取当前星期的第一天
- (NSString*)getTheFirstDayOfWeek:(NSString*)format;
//获取上一个星期
- (NSMutableArray*)getLastWeek:(NSString*)format;
//上个月的的时间
- (NSDate *)lastMonth:(NSDate *)date;
- (NSDate *)getLastOneMonth:(NSDate *)date value:(NSInteger)value;
- (NSInteger)daysInThisYear:(NSInteger)year withMonth:(NSInteger)month;
//下一个月的时间
- (NSDate*)nextMonth:(NSDate *)date;
//获取下某一个月的时间
- (NSDate *)getNextOneMonth:(NSDate *)date value:(NSInteger)value;
//上个礼拜的的时间
- (NSDate *)lastWeekDay:(NSDate *)date;
- (NSString *)timeStringFromDateAndFormatter:(NSDate *)date formatter:(NSString *)formatter;
//获取当前的一星期
-(NSMutableArray*)getWeekFromToday;
//获取上一个月的月份
- (NSInteger)lastMonth;
//获取本机ip地址
- (NSString *)deviceIPAddress;
//上个月的的时间
- (NSDate *)lastMonthByDate:(NSDate *)date;
//下一个月的时间
- (NSDate*)nextMonthByDate:(NSDate *)date;
//计算两个时间的时间差
- (NSDateComponents *)dateComponentsBetweenStartAndEnd:(NSString *)startTime endTime:(NSString *)endTime;
//返回顶层view
- (UIView *)topView;
//获取app当前版本
- (NSString*)getAppVersionString;
//判断是否是全英文
- (BOOL)isChinese:(NSString*)content;
//复制
- (void)copyLink:(NSString*)url;
//拨打电话
- (void)telephoneCall:(NSString*)number;
//获取文字高度
- (CGSize)getTextSize:(NSString *)text rect:(CGSize)rect attribute:(NSDictionary *)attribute;
- (NSString *)defaultCurrencyFormatString:(NSNumber *)num;
//客户推荐类型
- (NSString *)recommendType:(NSString *)sourceType;
//手机号码隐藏中间4位
- (NSString *)hideMiddleFourNumbers:(NSString *)phoneNum;
+ (NSString *)formatLargeMoney:(id)item;
- (NSString *)getDevicePlatform;
+ (NSString *)reviseStringForNumber:(NSNumber *)num;
- (NSString *)getLoanUnit:(NSString *)unit;
//判断定位是否打开
- (BOOL)determineWhetherTheAPPOpensTheLocation;
- (NSString *)qiniuThumbnail:(NSString *)source width:(int)width height:(int)height;
//七牛瘦身
- (NSString*)qiniuImageslim:(NSString *)source;
- (NSString *)qiniuImagesLim:(NSString *)source quality:(NSInteger)quality;
- (NSString *)qiniuLevelImagesLim:(NSString *)source level:(int)level;
- (BOOL)isIPhoneXSeries;
//跳转到系统相册
- (void)openSystmePhotos;
- (UINavigationController *)currentNavigationController;

@end
