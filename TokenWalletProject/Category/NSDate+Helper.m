//
// NSDate+Helper.h
//
// Created by Billy Gray on 2/26/09.
// Copyright (c) 2009–2012, ZETETIC LLC
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the ZETETIC LLC nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY ZETETIC LLC ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "NSDate+Helper.h"

static NSString *kNSDateHelperFormatFullDateWithTime    = @"MMM d, yyyy h:mm a";
static NSString *kNSDateHelperFormatFullDate            = @"MMM d, yyyy";
static NSString *kNSDateHelperFormatShortDateWithTime   = @"MMM d h:mm a";
static NSString *kNSDateHelperFormatShortDate           = @"MMM d";
static NSString *kNSDateHelperFormatWeekday             = @"EEEE";
static NSString *kNSDateHelperFormatWeekdayWithTime     = @"EEEE h:mm a";
static NSString *kNSDateHelperFormatTime                = @"h:mm a";
static NSString *kNSDateHelperFormatTimeWithPrefix      = @"'at' h:mm a";
static NSString *kNSDateHelperFormatSQLDate             = @"yyyy-MM-dd";
static NSString *kNSDateHelperFormatSQLTime             = @"HH:mm:ss";
static NSString *kNSDateHelperFormatSQLDateWithTime     = @"yyyy-MM-dd HH:mm:ss";

@implementation NSDate (Helper)

static NSCalendar *_calendar = nil;
static NSDateFormatter *_displayFormatter = nil;

+ (void)initializeStatics {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (_calendar == nil) {
#if __has_feature(objc_arc)
                _calendar = [NSCalendar currentCalendar];
#else
                _calendar = [[NSCalendar currentCalendar] retain];
#endif
            }
            if (_displayFormatter == nil) {
                _displayFormatter = [[NSDateFormatter alloc] init];
            }
        }
    });
}

+ (NSCalendar *)sharedCalendar {
    [self initializeStatics];
    return _calendar;
}

+ (NSDateFormatter *)sharedDateFormatter {
    [self initializeStatics];
    return _displayFormatter;
}

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
- (NSUInteger)daysAgo {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
	return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[self class] sharedDateFormatter];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
	return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
	NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
	NSString *text = nil;
	switch (daysAgo) {
		case 0:
			text = NSLocalizedString(@"Today", nil);
			break;
		case 1:
			text = NSLocalizedString(@"Yesterday", nil);
			break;
		default:
			text = [NSString stringWithFormat:@"%ld days ago", (long)daysAgo];
	}
	return text;
}

- (NSUInteger)hour {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitHour) fromDate:self];
	return [weekdayComponents hour];
}

- (NSUInteger)minute {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:self];
	return [weekdayComponents minute];
}

- (NSUInteger)year {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitYear) fromDate:self];
	return [weekdayComponents year];
}

- (NSUInteger)month
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:self];
    return [weekdayComponents month];
}

-(NSUInteger)day
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
    return [weekdayComponents day];
}

- (long int)utcTimeStamp{
    return lround(floor([self timeIntervalSince1970]));
}

- (NSUInteger)weekday {
    NSDateComponents *weekdayComponents = [[[self class] sharedCalendar] components:(NSCalendarUnitWeekday) fromDate:self];
	return [weekdayComponents weekday];
}

- (NSUInteger)weekNumber {
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitWeekOfYear) fromDate:self];
    return [dateComponents weekOfYear];
}

+ (NSDate *)dateFromString:(NSString *)string {
	return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *formatter = [self sharedDateFormatter];
	[formatter setDateFormat:format];
	NSDate *date = [formatter dateFromString:string];
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime {
    /*
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
	NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [[self sharedCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                                  fromDate:today];
	NSDate *midnight = [[self sharedCalendar] dateFromComponents:offsetComponents];
	NSString *displayString = nil;
	// comparing against midnight
    NSComparisonResult midnight_result = [date compare:midnight];
	if (midnight_result == NSOrderedDescending) {
		if (prefixed) {
			[[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatTimeWithPrefix]; // at 11:30 am
		} else {
			[[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatTime]; // 11:30 am
		}
	} else {
		// check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [[self sharedCalendar] dateByAddingComponents:componentsToSubtract toDate:today options:0];
#if !__has_feature(objc_arc)
		[componentsToSubtract release];
#endif
        NSComparisonResult lastweek_result = [date compare:lastweek];
		if (lastweek_result == NSOrderedDescending) {
            if (displayTime) {
                [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatWeekdayWithTime];
            } else {
                [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatWeekday]; // Tuesday
            }
		} else {
			// check if same calendar year
			NSInteger thisYear = [offsetComponents year];
			NSDateComponents *dateComponents = [[self sharedCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                            fromDate:date];
			NSInteger thatYear = [dateComponents year];
			if (thatYear >= thisYear) {
                if (displayTime) {
                    [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatShortDateWithTime];
                }
                else {
                    [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatShortDate];
                }
			} else {
                if (displayTime) {
                    [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatFullDateWithTime];
                }
                else {
                    [[self sharedDateFormatter] setDateFormat:kNSDateHelperFormatFullDate];
                }
			}
		}
		if (prefixed) {
			NSString *dateFormat = [[self sharedDateFormatter] dateFormat];
			NSString *prefix = @"'on' ";
			[[self sharedDateFormatter] setDateFormat:[prefix stringByAppendingString:dateFormat]];
		}
	}
	// use display formatter to return formatted date string
	displayString = [[self sharedDateFormatter] stringFromDate:date];
	return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
	return [[self class] stringForDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
	return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
	[[[self class] sharedDateFormatter] setDateFormat:format];
	NSString *timestamp_str = [[[self class] sharedDateFormatter] stringFromDate:self];
	return timestamp_str;
}

- (NSString *)string {
	return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	[[[self class] sharedDateFormatter] setDateStyle:dateStyle];
	[[[self class] sharedDateFormatter] setTimeStyle:timeStyle];
	NSString *outputString = [[[self class] sharedDateFormatter] stringFromDate:self];
	return outputString;
}

- (NSDate *)beginningOfWeek {
	// largely borrowed from "Date and Time Programming Guide for Cocoa"
	// we'll use the default calendar and hope for the best
	NSCalendar *calendar = [[self class] sharedCalendar];
    NSDate *beginningOfWeek = nil;
	BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginningOfWeek
						   interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	}
	// couldn't calc via range, so try to grab Sunday, assuming gregorian style
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
	 */
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
#if !__has_feature(objc_arc)
	[componentsToSubtract release];
#endif
	//normalize to midnight, extract the year, month, and day components and create a new date from those components.
	NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
											   fromDate:beginningOfWeek];
	return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
    NSCalendar *calendar = [[self class] sharedCalendar];
    // Get the weekday component of the current date
	NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
											   fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
    NSCalendar *calendar = [[self class] sharedCalendar];
    // Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	// to get the end of week for a particular date, add (7 - weekday) days
	[componentsToAdd setDay:(7 - [weekdayComponents weekday])];
	NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
#if !__has_feature(objc_arc)
	[componentsToAdd release];
#endif
	return endOfWeek;
}

+ (NSString *)dateFormatString {
	return kNSDateHelperFormatSQLDate;
}

+ (NSString *)timeFormatString {
	return kNSDateHelperFormatSQLTime;
}

+ (NSString *)timestampFormatString {
	return kNSDateHelperFormatSQLDateWithTime;
}

// preserving for compatibility
+ (NSString *)dbFormatString {
	return [NSDate timestampFormatString];
}

//phil -->
+ (NSString *)dateStringCurrent{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH:mm:ss";
    NSDate *dateUTC = [NSDate date];
    NSString *currentDate = [formatter stringFromDate:dateUTC];
    return currentDate;
}

+ (NSString *)dateWithInterval:(NSTimeInterval)time{
    
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time + 8 * 3600.f];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *currentDate = [formatter stringFromDate:date];
    return currentDate;
}

+ (NSTimeInterval )getTodayFormer:(NSTimeInterval)time{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger hour = [comps hour];
    NSInteger min  = [comps minute];
    NSInteger sec = [comps second];
    NSTimeInterval todayFormer = hour*3600.f + min * 60.f + sec;
    return todayFormer;
}

+ (NSTimeInterval )getTodayBehind:(NSTimeInterval )time{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger hour = [comps hour];
    NSInteger min  = [comps minute];
    NSInteger sec = [comps second];
    NSTimeInterval todayFormer = hour*3600.f + min * 60.f + sec - 3600 *8 ;
    return 24*3600 - todayFormer;
}

+ (NSDate *)dateWithYearAgo:(NSUInteger)year{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitYear) fromDate:[NSDate date]];
    NSUInteger currentYear = [weekdayComponents year];
    
    NSDateFormatter * fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSString * timeStr =[NSString stringWithFormat:@"%lu/01/01 00:00:00",currentYear-year];
    return [fm dateFromString:timeStr];
}

+ (NSUInteger )ageWith1970:(NSTimeInterval )time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSInteger currentYear = [[NSDate date] year];
    return currentYear-[date year];
}

+ (BOOL)isEqualto1970:(NSDate *)date{
    NSTimeInterval diffTime = [date timeIntervalSince1970];
    if (diffTime == 0) {
        return YES;
    }
    else{
        return NO;
    }
}


+ (NSArray*)getOrderDateFormate1:(NSTimeInterval )time {
    NSMutableArray *timeArray = [NSMutableArray array];
    
    NSDate *currentDate = [NSDate date];
    
    NSInteger currentTimeInterval = [[NSNumber numberWithDouble:[currentDate timeIntervalSince1970]*1000] integerValue] - 30000;
    float nSecs = (NSInteger)(time - currentTimeInterval)/1000;
    float oneDaySecs = 24*3600;
    float i = nSecs / oneDaySecs;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"MM-dd"];
    NSString *date =  [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000]];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    NSLog(@"%@", timeLocal);
    
    NSDateFormatter * formatter2 = [[NSDateFormatter alloc ] init];
    [formatter2 setDateFormat:@"HH:mm"];
    NSString *date2 =  [formatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000]];
    NSString *timeLocal2 = [[NSString alloc] initWithFormat:@"%@", date2];
    NSLog(@"%@", timeLocal2);
    
//    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComps = [currentCalendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];

    NSDate *today = [currentCalendar dateFromComponents:currentComps];

    NSTimeInterval timeInterval = [today timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:time/1000]];
    
//    if (timeInterval <= -86400.0 && -172776.44799995422)timeInterval    NSTimeInterval    -172776.44799995422 timeInterval    NSTimeInterval    -259152.89599990845
    
    if (timeInterval >-259153.0 && timeInterval <-172776.0) {
        //后天
        [timeArray addObject:@"后天"];
        [timeArray addObject:timeLocal2];
    } else if (timeInterval >-172776.0 && timeInterval <-86400.0) {
        //明天
        [timeArray addObject:@"明天"];
        [timeArray addObject:timeLocal2];
    } else if (timeInterval >-86400.0 && timeInterval<0) {
        //今天
        [timeArray addObject:@"今天"];
        [timeArray addObject:timeLocal2];
    } else if (timeInterval < 86400.0) {
        //昨天
//        return [date stringWithFormat:@"昨天 HH:mm"];
        [timeArray addObject:@"昨天"];
        [timeArray addObject:timeLocal2];
    }
//    else if (timeInterval < 86400.0 * 6) {
////        NSArray *weekDays = @[@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
////        //一周内
////        NSInteger weekDay = [currentCalendar component:NSCalendarUnitWeekday fromDate:date] - 1;
////        NSString *time = [date stringWithFormat:@"HH:mm"];
////        return [NSString stringWithFormat:@"%@ %@", weekDays[weekDay], time];
//
//    }
    else {
        //        return [NSString stringWithFormat:@"%@ %@", timeLocal, timeLocal2];;
        [timeArray addObject:timeLocal];
        [timeArray addObject:timeLocal2];
    }
//    else if (ti){
////        return [date stringWithFormat:@"MM-dd HH:mm"];
//    }
    
    
//    if (i>-1 && i< 1) {
//        [timeArray addObject:@"今天"];
//        [timeArray addObject:timeLocal2];
////        return [NSString stringWithFormat:@"今天 %@", timeLocal2];
//    } else if (i >= 1 && i<1.5) {
////        return [NSString stringWithFormat:@"明天 %@", timeLocal2];
//        [timeArray addObject:@"明天"];
//        [timeArray addObject:timeLocal2];
//    } else if (i >=1.5 && i<=3) {
////        return [NSString stringWithFormat:@"后天 %@", timeLocal2];
//        [timeArray addObject:@"后天"];
//        [timeArray addObject:timeLocal2];
//    } else if (i<-1 && i>-2) {
//        //        return [NSString stringWithFormat:@"后天 %@", timeLocal2];
//        [timeArray addObject:@"昨天"];
//        [timeArray addObject:timeLocal2];
//    } else {
////        return [NSString stringWithFormat:@"%@ %@", timeLocal, timeLocal2];;
//        [timeArray addObject:timeLocal];
//        [timeArray addObject:timeLocal2];
//    }
    return timeArray;
}

+ (NSString*)getOrderDateFormate2:(NSTimeInterval )time {
    return @"";
}

+ (NSString*)getOrderDateFormate3:(NSTimeInterval )time {
    NSDate *currentDate = [NSDate date];
    NSInteger currentTimeInterval = [[NSNumber numberWithDouble:[currentDate timeIntervalSince1970]*1000] integerValue];
    NSInteger nSecs = (NSInteger)(time - currentTimeInterval)/1000;
    NSInteger hours = nSecs/3600;
    NSInteger releaseSecs =nSecs%3600;
    NSInteger minutes =releaseSecs/60;
    if (nSecs<0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%ld小时 %ld分后恢复接单",hours, minutes];
}

+ (NSArray*)getOrderDateFormate4:(NSTimeInterval )time {
    NSDate *currentDate = [NSDate date];
    NSInteger currentTimeInterval = [[NSNumber numberWithDouble:[currentDate timeIntervalSince1970]*1000] integerValue];
    NSInteger nSecs = (NSInteger)(time - currentTimeInterval)/1000;
    NSInteger hours = nSecs/3600;
    NSInteger releaseSecs =nSecs%3600;
    NSInteger minutes =releaseSecs/60;
    NSInteger releaseSecs1 = releaseSecs%60;
    return [NSArray arrayWithObjects:[NSNumber numberWithInteger:hours], [NSNumber numberWithInteger:minutes], [NSNumber numberWithInteger:releaseSecs1],nil];
}

+ (NSString*)getOrderDateFormate5:(NSString* )timeString {
    NSDate *dt = [NSDate dateFromString:timeString withFormat:@"yyyy-MM-dd HH:mm"];
    NSInteger timeInterval = [[NSNumber numberWithDouble:[dt timeIntervalSince1970]*1000] integerValue];
    NSArray* array = [self getOrderDateFormate1:timeInterval];
    if (array && array.count >1) {
        return [NSString stringWithFormat:@"%@ %@", array[0], array[1]];
    } else {
        return @"";
    }
    
}

//获取当前时间戳
+ (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

@end
