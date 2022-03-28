//
//  UITools.m
//  EZTV
//
//  Created by Phil Xhc on 16/1/18.
//  Copyright © 2016年 Joygo. All rights reserved.
//

#import "UITools.h"
#import "NSDate+Helper.h"
#import <Photos/Photos.h>
#import "UIImage+ImageEffects.h"
#import <SDImageCache.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <ContactsUI/ContactsUI.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "JKBigDecimal.h"

@implementation UITools

+(NSString *)bigStringWith16String:(NSString *)str{
    if (!str) {
        return nil;
    }
    JKBigInteger *bigNum = [[JKBigInteger alloc]initWithString:[str formatDelEth] andRadix:16];
    NSString *ten = [bigNum stringValueWithRadix:10];
    JKBigInteger *bigNum1 = [[JKBigInteger alloc]initWithString:ten];
    NSString *sttr = [bigNum1 stringValue];
//    if (sttr.length>18) {
//        NSString *str1 = [sttr substringToIndex:sttr.length-18];
//        NSString *str2 = [sttr substringFromIndex:sttr.length-18];
//
//        sttr = [NSString stringWithFormat:@"%@.%@",str1,str2];
//    }
    return sttr;
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (CGFloat)bottomOffsetYofScrollView:(UIScrollView *)scrollView
{
    UIEdgeInsets contentInset = scrollView.contentInset;
    
    CGFloat deltaH = scrollView.contentSize.height - (scrollView.frame.size.height - contentInset.bottom - contentInset.top);
    if (deltaH > 0) {
        return deltaH - contentInset.top;
    } else {
        return - contentInset.top;
    }
}

+ (CGSize)sizeWithString:(NSString *)string attributes:(NSDictionary *)attributes bounds:(CGSize)bounds
{
    if (ISEMPTYSTR(string)) {
        return CGSizeZero;
    }
   
    CGRect stringRect =
    [string boundingRectWithSize:bounds //限制最大的宽度和高度
                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                       attributes:attributes //传入的字体属性,
                          context:nil];
    
//    UIFont *font = [attributes objectForKey:NSFontAttributeName];
//    NSParagraphStyle *style = [attributes objectForKey:NSParagraphStyleAttributeName];
//    
//    if (font && style) {
//        if ((stringRect.size.height - font.lineHeight) <= style.lineSpacing) {
//            if ([[self class] containChinese:string]) {  //如果包含中文
//                stringRect.size.height -= style.lineSpacing;
//            }
//        }
//    }
    
    return stringRect.size;
}

//判断如果包含中文
+ (BOOL)containChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[self class] sizeWithString:string attributes:attributes bounds:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(float)width
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[self class] sizeWithString:string attributes:attributes bounds:CGSizeMake(width, SCREEN_HEIGHT)];
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font height:(CGFloat)height width:(CGFloat)width
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[self class] sizeWithString:string attributes:attributes bounds:CGSizeMake(width, height)];
}

+ (NSArray *)locationOfLabel:(UILabel *)firstLabel secondLabel:(UILabel *)secondLabel string:(NSString *)string{
    CGRect firstRect = firstLabel.frame;
    CGRect secondRect = secondLabel.frame;
    NSMutableArray *locaArr = [[NSMutableArray alloc] initWithCapacity:2];
    
    
    UIFont *font = firstLabel.font;
    CGFloat fontHeight = font.pointSize;
    
    CGSize size = [UITools sizeWithString:string font:font height:fontHeight width:1000.f];
    
    if (size.width > firstRect.size.width) {
        NSInteger loca = 1;
        NSString *firstSubString = [string substringToIndex:loca];
        CGSize firstSize = [UITools sizeWithString:firstSubString font:font height:fontHeight width:1000.f];
        
        for (;firstRect.size.width - firstSize.width >= (fontHeight+1.f) && loca <= string.length - 1;loca++) {
            NSString *subString = [string substringToIndex:loca];
            
            firstSize = [UITools sizeWithString:subString font:font height:fontHeight width:1000.f];
        }
        NSNumber *firstLoca = [NSNumber numberWithInteger:loca-1];
        [locaArr addObject:firstLoca];
        
        NSString *secondString = [string substringFromIndex:[firstLoca integerValue]];
        loca = 1;
        NSString *secondSubString = [secondString substringToIndex:loca];
        CGSize secondSize = [UITools sizeWithString:secondSubString font:font height:fontHeight width:1000.f];
        for (; secondRect.size.width - secondSize.width >= (fontHeight+1.f) && loca <= secondString.length - 1; loca ++) {
            NSString *subString = [secondString substringToIndex:loca];
            secondSize = [UITools sizeWithString:subString font:font height:fontHeight width:1000.f];
        }
        NSNumber *secondLoca = [NSNumber numberWithInteger:loca-1];
        [locaArr addObject:secondLoca];
        
    }
    return locaArr;
}

+ (NSMutableAttributedString *)injForecastfirString:(NSString *)firString
                                           firColor:(UIColor *)firColor
                                            firBold:(BOOL)firBold
                                          secString:(NSString *)secString
                                           secColor:(UIColor *)secColor
                                            secBold:(BOOL)secBold
                                               font:(CGFloat)font{
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"%@",firString];
    NSRange range1 = NSMakeRange(0, str.length);
    
    [str appendFormat:@"%@",secString];
    NSRange range2 = NSMakeRange(str.length, 0);
    if (secString.length > 0) {
        range2 = NSMakeRange(range1.length, str.length - range1.length);
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];

//    
    [attrStr addAttribute:NSForegroundColorAttributeName value:firColor range:range1];
    if (secString.length > 0) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:secColor range:range2];
    }
    
    if (firBold) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:range1];
    }
    else if(secString.length > 0){
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range1];
    }
    if (secBold) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:range2];
    }
    else if(secString.length > 0){
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range2];
    }

    return attrStr;
}

+ (NSMutableAttributedString *)stringWithFirString:(NSString *)firString firColor:(UIColor *)firColor secString:(NSString *)secString secColor:(UIColor *)secColor bold:(BOOL)bold font:(CGFloat)font{
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"%@",firString];
    NSRange range1 = NSMakeRange(0, str.length);
    [str appendFormat:@"%@",secString];
    NSRange range2 = NSMakeRange(range1.length, str.length - range1.length);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    //
    [attrStr addAttribute:NSForegroundColorAttributeName value:firColor range:range1];
    if (secString.length > 0) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:secColor range:range2];
    }
    
    if (bold) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:range1];
    }
    else if(secString.length > 0){
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range1];
    }
    if (bold) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:range2];
    }
    else if(secString.length > 0){
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range2];
    }
    
    return attrStr;
}

+ (NSMutableAttributedString *)stringWithFirStringThree:(NSString *)firString
                                               firColor:(UIColor *)firColor
                                              secString:(NSString *)secString
                                               secColor:(UIColor *)secColor
                                            thirdString:(NSString *)thirdString
                                             thirdColor:(UIColor *)thirdColor
                                                   bold:(BOOL)bold
                                                   font:(CGFloat)font{
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"%@",firString];
    NSRange range1 = NSMakeRange(0, str.length);
    [str appendFormat:@"%@",secString];
    NSRange range2 = NSMakeRange(range1.length, str.length - range1.length);
    [str appendString:thirdString];
    NSRange range3 = NSMakeRange(range1.length + range2.length, str.length - range2.length - range1.length);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    //
    [attrStr addAttribute:NSForegroundColorAttributeName value:firColor range:range1];
    if (secString.length > 0) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:secColor range:range2];
    }
    if (thirdString.length > 0) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:thirdColor range:range3];
    }
    
    if (bold) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:range1];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:range2];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:range3];
    }
    if(secString.length > 0){
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range1];
    }
    if(secString.length > 0){
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range2];
    }
    if (thirdString.length > 0) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range3];
    }
    return attrStr;

}

+ (UIBarButtonItem *)addSaveBtn:(UIViewController *)viewController selector:(SEL)btnClick{
    UIBarButtonItem *navSave = [[UIBarButtonItem alloc] initWithTitle:LBLocalized(@"save") style:UIBarButtonItemStylePlain target:viewController action:btnClick];
    [navSave setTitleTextAttributes:@{NSForegroundColorAttributeName: _COLOR2_NAV_OPERATE} forState:UIControlStateNormal];
    [navSave setTitleTextAttributes:@{NSForegroundColorAttributeName: _COLOR9_NORMAL_TITLE_A} forState:UIControlStateDisabled];
    [viewController.navigationItem setRightBarButtonItem:navSave];
    [navSave setEnabled:NO];
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setFrame:CGRectMake(0.f, 0.f, 32.f, 16.f)];
//    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, -10.f)];
//    [rightBtn setTitleColor:COLORFORRGB(0xffffff) forState:UIControlStateNormal];
//    [rightBtn setTitleColor:COLORFORRGB(0x999999) forState:UIControlStateDisabled];
//    [rightBtn setTitle:LBLocalized(@"save") forState:UIControlStateNormal];
//    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
//    [rightBtn addTarget:viewController action:btnClick forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    viewController.navigationItem.rightBarButtonItem = rightBarButton;
//    [rightBarButton setEnabled:NO];
    return navSave;
}

+ (void)setPartRoundWithView:(UIView *)view corners:(UIRectCorner)corners cornerRadius:(float)cornerRadius {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
    view.layer.mask = shapeLayer;
}


+ (void)addMaskLayerToView:(UIView *)view radius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    UIBezierPath *maskPath =
    [UIBezierPath bezierPathWithRoundedRect:view.bounds
                               cornerRadius:radius];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path    =   maskPath.CGPath;
    borderLayer.fillColor  = [UIColor clearColor].CGColor;
    borderLayer.strokeColor    = color.CGColor;
    borderLayer.lineWidth      = width;
    borderLayer.frame = view.bounds;
    [view.layer addSublayer:borderLayer];
}

+ (void)addMaskLayerToView:(UIView *)view withRadius:(CGFloat)radius
{
    UIBezierPath *maskPath =
    [UIBezierPath bezierPathWithRoundedRect:view.bounds
                               cornerRadius:radius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

+ (void)addShadowToView:(UIView*)view {
    if (!view) {
        return;
    }
    view.layer.shadowOpacity = 0.1;
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowRadius = 3;
    view.layer.shadowOffset= CGSizeMake(5, 5);
}

+ (void)addEffectToView:(UIView *)view withRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    //设置圆角
    UIBezierPath *maskPath =
    [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path    =   maskPath.CGPath;
    borderLayer.fillColor  = [UIColor clearColor].CGColor;
    borderLayer.strokeColor    = color.CGColor;
    borderLayer.lineWidth      = width;
    borderLayer.frame = view.bounds;
    [view.layer addSublayer:borderLayer];
    
}

+ (void)addAnimationView:(UIView *)view withType:(AnimationType)type time:(float)time{
    CATransition *animation = [CATransition animation];
//    animation.delegate = self;
    animation.duration = time; //动画时长
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = @"moveIn"; //过度效果
    switch (type) {
        case AnimationType_Appear:{
            animation.subtype = @"fromTop";
            animation.startProgress = 0.0; //动画开始起点(在整体动画的百分比)
            animation.endProgress = 1.0;  //动画停止终点(在整体动画的百分比)
            animation.removedOnCompletion = NO;
        }
            break;
        case AnimationType_Disappear:{
            animation.subtype = @"fromBottom";
            animation.startProgress = 1.0; //动画开始起点(在整体动画的百分比)
            animation.endProgress = 0.0;  //动画停止终点(在整体动画的百分比)
            animation.removedOnCompletion = YES;
        }
            
        default:{
            animation.subtype = @"fromTop";
        }
            break;
    }
    [view.layer addAnimation:animation forKey:@"animation"];
}

+ (int)getAttributedStringHeightWithString:(NSMutableAttributedString *)string widthValue:(int)width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}

+ (NSString *)timeLabelWithDate:(NSDate *)date
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    
    if (interval < 300.0) {
        return @"刚刚";
    } else if (interval < 3600.0) {
        NSTimeInterval mins = interval/60.0;
        return [NSString stringWithFormat:@"%.0f分钟前", mins];
    } else if (interval < 86400.0) {
        NSTimeInterval hours = interval/3600.0;
        return [NSString stringWithFormat:@"%.0f小时前", hours];
    } else {
        return [date stringWithFormat:@"yyyy.MM.dd"];
    }
}
//得到当前时间相对1970时间的字符串，精度到秒，返回10位长度字符串

+ (NSString *)gs_getCurrentTimeBySecond {

    double currentTime =  [[NSDate date] timeIntervalSince1970];

    NSString *strTime = [NSString stringWithFormat:@"%.0f",currentTime];

    return strTime;

}

+ (NSString *)subRangeStr:(NSString *)string fromStart:(NSString *)startStr toEnd:(NSString *)endStr{
    NSRange start = [string rangeOfString:startStr];
    NSRange end = [string rangeOfString:endStr];
    NSString *sub = [string substringWithRange:NSMakeRange(start.location+startStr.length, end.location-(start.location+startStr.length))];
    return sub;
}

/** 得到当前时间相对1970时间的字符串，精度到毫秒，返回13位长度字符串*/

+ (NSString *)gs_getCurrentTimeStringToMilliSecond {

    double currentTime =  [[NSDate date] timeIntervalSince1970]*1000;

    NSString *strTime = [NSString stringWithFormat:@"%.0f",currentTime];

    return strTime;

}


+(NSString *)timeLabelWithTimeInterval:(NSString * )timeInterval{
    NSTimeInterval interval = [timeInterval doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)timeStringWithDate:(NSDate *)date
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComps = [currentCalendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    
    NSDate *today = [currentCalendar dateFromComponents:currentComps];
    
    NSTimeInterval timeInterval = [today timeIntervalSinceDate:date];
    
    if (timeInterval < 0) {
        //今天
        return [date stringWithFormat:@"HH:mm"];
    } else if (timeInterval < 86400.0) {
        return [date stringWithFormat:@"昨天 HH:mm"];
    } else if (timeInterval < 86400.0 * 6) {
        NSArray *weekDays = @[@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
        //一周内
        NSInteger weekDay = [currentCalendar component:NSCalendarUnitWeekday fromDate:date] - 1;
        NSString *time = [date stringWithFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"%@ %@", weekDays[weekDay], time];
    } else {
        return [date stringWithFormat:@"MM-dd HH:mm"];
    }
}

+ (NSString *)dayStringWithDate:(NSDate *)date
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComps = [currentCalendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    
    NSDate *today = [currentCalendar dateFromComponents:currentComps];
    
    NSTimeInterval timeInterval = [today timeIntervalSinceDate:date];
    
    if (timeInterval < 0) {
        //今天
        return [date stringWithFormat:@"HH:mm"];
    } else if (timeInterval < 86400.0) {
        return @"昨天";
    } else if (timeInterval < 86400.0 * 6) {
        NSArray *weekDays = @[@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
        //一周内
        NSInteger weekDay = [currentCalendar component:NSCalendarUnitWeekday fromDate:date] - 1;
        return weekDays[weekDay];
    } else {
        return [date stringWithFormat:@"MM-dd"];
    }
}
+ (CGFloat)fullScreenChatFontSize
{
    return 26;
}
+ (CGFloat)chatFontSize
{
    CGFloat fontSize = 17.f;
    if (IS_SCREEN_4_INCH || IS_SCREEN_35_INCH) {
        fontSize = 16.f;
    }
    return fontSize;
}

+ (CGFloat)fontSizeWithOriginFont:(CGFloat)fontSize{
    if (IS_SCREEN_4_INCH || IS_SCREEN_35_INCH) {
        fontSize = fontSize * 0.75;
    }
    return fontSize;

}

+ (NSString *)dayTimeStringWithDate:(NSDate *)date
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComps = [currentCalendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    
    NSDate *today = [currentCalendar dateFromComponents:currentComps];
    
    NSTimeInterval timeInterval = [today timeIntervalSinceDate:date];
    
    if (timeInterval < 0) {
        //今天
        return @"今天";
    } else if (timeInterval < 86400.0) {
        return @"昨天";
    } else if (timeInterval < 86400.0 * 6) {
        NSArray *weekDays = @[@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
        //一周内
        NSInteger weekDay = [currentCalendar component:NSCalendarUnitWeekday fromDate:date] - 1;
        return weekDays[weekDay];
    } else {
        return [date stringWithFormat:@"yyyy.MM.dd"];
    }
}

+ (NSString *)YearMonthDayTimeStringWithDate:(NSDate *)date
{
    return [date stringWithFormat:@"yyyy-MM-dd"];
}

+ (NSString *)subStringWith:(NSString *)string ToIndex:(NSInteger)index{
    
    NSString *result = string;
    if (result.length > index) {
        NSRange rangeIndex = [result rangeOfComposedCharacterSequenceAtIndex:index];
        result = [result substringToIndex:(rangeIndex.location)];
    }
    
    return result;
}


+ (NSString *)getCountDownStringWithEndTime:(NSString *)endTime {
    NSDate *nowData = [NSDate date];
      NSDate *endData=[NSDate dateWithTimeIntervalSince1970:[endTime intValue]];
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSCalendarIdentifierGregorian ];
      NSUInteger unitFlags =
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
      NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:nowData  toDate: endData options:0];
      NSInteger Hour  = [cps hour];
      NSInteger Min   = [cps minute];
      NSInteger Sec   = [cps second];
//      NSInteger Day   = [cps day];
//      NSInteger Mon   = [cps month];
//      NSInteger Year  = [cps year];
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",Hour,Min, Sec];


}



+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
//    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
//                         constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
//                             lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
//    return sizeToFit.height;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize bouningSize = CGSizeMake(width, 0);
    return [value boundingRectWithSize:bouningSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size.height;
    
    
}

+ (NSAttributedString *)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    return attributedString;
}

+ (void)setLableProperties:(UILabel*)lable withColor:(UIColor*)color andFont:(UIFont*)font; {
    lable.textColor = color;
    lable.font = font;
}



+(NSAttributedString *)setParagraphHeithWithText:(NSString *)text withHeight:(CGFloat)height{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = height;
    [att addAttributes:@{NSParagraphStyleAttributeName:paraStyle} range:NSMakeRange(0, att.length)];
    return att;
}

//在文字后面跟图片
+(NSAttributedString *)appendImageWithLabelText:(NSString *)text image:(NSString *)image{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:NSStringWithFormat(@"%@ ",text)];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:image];

    // 设置图片大小
    attch.bounds = CGRectMake(-8, -3, 14, 14);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string]; //在文字后面添加图片
    // 用label的attributedText属性来使用富文本
    return attri;
}


+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/*
 周边加阴影，并且同时圆角
 */
+ (void)addShadowToView:(UIView *)view
             withRadios:(float)shadowRadios withOpacity:(float)shadowOpacity
{
    if (!view) {
        return;
    }
    view.layer.shadowOpacity = shadowOpacity;
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowRadius = 3;
    view.layer.shadowOffset= CGSizeMake(1, 1);
    view.layer.cornerRadius = shadowRadios;
}

+ (void)addDashBackground:(UIView*)view {
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //虚线的颜色
    border.strokeColor = COLORFORRGB(0x3B4859).CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:0];
    
    //设置路径
    border.path = path.CGPath;
    
    border.frame = view.bounds;
    //虚线的宽度
    border.lineWidth = 0.8f;
    
    
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    
//    view.layer.cornerRadius = 5.f;
//    view.layer.masksToBounds = YES;
    [view.layer addSublayer:border];
}


+ (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
            NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
//    NSString * path = [NSString stringWithFormat:@"/Users/admin/work/json/5012.json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


+(id)jsonStringToDictionary:(NSString *)jsonString{
    if (jsonString == nil) {

    return nil;

    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

    NSError *err;

    id object = [NSJSONSerialization JSONObjectWithData:jsonData

    options:NSJSONReadingMutableContainers

    error:&err];
    
    if(err) {

    NSLog(@"json解析失败：%@",err);

    return nil;

    }

    return object;
    
    
}

+ (void)saveImage:(UIImage *)image
{
    //(1) 获取当前的授权状态
    PHAuthorizationStatus lastStatus = [PHPhotoLibrary authorizationStatus];
    
    //(2) 请求授权
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(status == PHAuthorizationStatusDenied) //用户拒绝（可能是之前拒绝的，有可能是刚才在系统弹框中选择的拒绝）
            {
                if (lastStatus == PHAuthorizationStatusNotDetermined) {
                    //说明，用户之前没有做决定，在弹出授权框中，选择了拒绝
                    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"common_save_fail", nil)];
                    return;
                }
                // 说明，之前用户选择拒绝过，现在又点击保存按钮，说明想要使用该功能，需要提示用户打开授权
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"jurisdiction_photos_save_tip1", nil)];
                
            }
            else if(status == PHAuthorizationStatusAuthorized) //用户允许
            {
                //保存图片---调用上面封装的方法
                UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
            }
            else if (status == PHAuthorizationStatusRestricted)
            {
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"jurisdiction_photos_save_tip2", nil)];
            }
        });
    }];
}

+ (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {

    if(error) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"common_save_fail", nil)];

    //保存失败

    }else{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"common_save_success", nil)];
    //保存成功

    }
    
}

+(NSString *)base64FromImage:(UIImage *)image{
    //UIImage图片转Base64字符串：

    UIImage *originImage = image;
    
    
    
    NSData *imgData = [image compressQualityWithMaxLength:1024];
    
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    

    return encodedImageStr;;

}

+(UIImage *)imagefromBase64:(NSString *)str{
    NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}

+ (BOOL)isNumber:(NSString *)strValue
{
    if (strValue == nil || [strValue length] <= 0)
    {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[strValue componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![strValue isEqualToString:filtered])
    {
        return NO;
    }
    return YES;
}


+ (void)ClearCache {
//    [SVProgressHUD showWithStatus:@"清除缓存中"];
    //两部分缓存:1.SDWebImage图片的缓存;2.自定义缓存
    //1.SDWebImage图片缓存
    //内存:
    [[SDImageCache sharedImageCache] clearMemory];
    //磁盘
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"cache_success", nil)];
    }];
    //2.自定义缓存
    NSString *my_CachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    [[NSFileManager defaultManager] removeItemAtPath:my_CachePath error:nil];
}

+(NSString *)md5:(NSString *)str{
    const char *input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

//+(BOOL)isOpenCameraJurisdiction{
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//     if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
//         [LCAlertView showWithTitle:NSLocalizedString(@"app_program_limit_tip", nil) message:NSLocalizedString(@"jurisdiction_camera_tip1", nil) buttonTitles:@[NSLocalizedString(@"cancel",nil),NSLocalizedString(@"app_programe_open", nil)] action:^(NSInteger index) {
//             if (index == 1) {
//                 NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                 if([[UIApplication sharedApplication] canOpenURL:url]) {
//                     NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                     [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                         [[MPTools appRootViewController]popViewControllerAnimated:YES];
//                     });
//                 }
//            }else{
//                 [[MPTools appRootViewController]popViewControllerAnimated:YES];
//             }
//         }];
//         return NO;
//
//     } else {  //做你想做的（可以去打开设置的路径）
//
//         return YES;
//     }
//}

//+(BOOL)isOpenContractJurisdiction{
//    //获取是否授权
//        __block BOOL grandted = YES;
//        
//        [[[CNContactStore alloc]init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//                if(granted){
//                    
//                }else{
//                    [LCAlertView showWithTitle:NSLocalizedString(@"app_program_limit_tip", nil) message:NSLocalizedString(@"jurisdiction_camera_tip2", nil) buttonTitles:@[NSLocalizedString(@"cancel",nil),NSLocalizedString(@"app_programe_open", nil)] action:^(NSInteger index) {
//                        if (index == 1) {
//                            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                            if([[UIApplication sharedApplication] canOpenURL:url]) {
//                                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//                                
//                            }
//                       }else{
//                        }
//                    }];
//                }
//            }];
//
//        return grandted;
//}
//
//
//+(BOOL)isOpenCameraJurisdictionNoPop{
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//     if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
//         [LCAlertView showWithTitle:NSLocalizedString(@"app_program_limit_tip", nil) message:NSLocalizedString(@"jurisdiction_camera_tip1", nil) buttonTitles:@[NSLocalizedString(@"cancel",nil),NSLocalizedString(@"app_programe_open", nil)] action:^(NSInteger index) {
//             if (index == 1) {
//                 NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                 if([[UIApplication sharedApplication] canOpenURL:url]) {
//                     NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                     [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//                     
//                 }
//            }else{
//             }
//         }];
//         return NO;
//
//     } else {  //做你想做的（可以去打开设置的路径）
//         
//         return YES;
//     }
//}
//
//+(BOOL)isOpenPhotosJurisduiction{
//    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//     if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
//            [LCAlertView showWithTitle:NSLocalizedString(@"app_program_limit_tip", nil) message:NSLocalizedString(@"jurisdiction_photos_tip1", nil) buttonTitles:@[NSLocalizedString(@"cancel",nil),NSLocalizedString(@"app_programe_open", nil)] action:^(NSInteger index) {
//                if (index == 1) {
//                    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                    if([[UIApplication sharedApplication] canOpenURL:url]) {
//                        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
////                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                            [[MPTools appRootViewController]popViewControllerAnimated:YES];
////                        });
//                    }
//               }else{
////                    [[MPTools appRootViewController]popViewControllerAnimated:YES];
//                }
//            }];
//            return NO;
//     }else{
//         return YES;
//     }
//}

//判断是否是重复连续数字 yes:是 NO：不是
+(BOOL)checkPincode:(NSString*)pincode
{
    BOOL isTure = NO;//不符合规则，pincode是相同的或连续的
    NSMutableArray *arr = [NSMutableArray new];
    for (int i=0; i<pincode.length; i++) {
        NSString *str = [pincode substringWithRange:NSMakeRange(i, 1)];
        [arr addObject:str];
    }
    if ([self isAllEqual:arr] ||[self judgeInscend:arr] || [self judgeDescend:arr]) {
        return YES;
    }
   
    return NO;
}

+(BOOL)isAllEqual:(NSArray *)arr{
    int j = 0;
     for (int i = 0; i<arr.count; i++) {
         if (i>0) {
             int num = [arr[i] intValue];
             int num_ = [arr[i-1] intValue];
             if (num == num_) {
                 j++;
             }
         }
     }
    
     if (j == arr.count - 1) {
         return YES;
     }

     return NO;
}

+ (BOOL)judgeInscend:(NSArray *)arr{
    //递增12345
    int j = 0;
    for (int i = 0; i<arr.count; i++) {
        if (i>0) {
            int num = [arr[i] intValue];
            int num_ = [arr[i-1] intValue] +1;
            if (num == num_) {
                j++;
            }
        }
    }
   
    if (j == arr.count - 1) {
        return YES;
    }

    return NO;
}

+ (BOOL)judgeDescend:(NSArray *)arr{
    //递减54321
    int j=0;//计数归零,用于递减判断
    for (int i = 0; i<arr.count; i++) {
        if (i>0) {
            int num = [arr[i] intValue];
            int num_ = [arr[i-1] intValue]-1;
            if (num == num_) {
                j++;
            }
        }
    }
    if (j == arr.count - 1) {
        return YES;
    }
    return NO;
}
 
//判断是否相等
+ (BOOL)judgeEqual:(NSArray *)arr{

    int j=0;

    int firstNum = [arr[0] intValue];

    for (int i = 0; i<arr.count; i++) {

        if (firstNum == [arr[i] intValue]) {

            j++;

        }

    }

    if (j == arr.count - 1) {

        return YES;

    }

    return NO;

}

/**
 校验身份证号码是否正确 返回BOOL值

 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)cly_verifyIDCardString:(NSString *)idCardString {
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRe = [predicate evaluateWithObject:idCardString];
    if (!isRe) {
         //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSInteger sum = 0;//保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) {//将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [idCardString substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] * [weightingArray[i] integerValue];
    }
    
    NSInteger modNum = sum % 11;//总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [idCardString.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    
    if (modNum == 2) {//等于2时 idCardMod为10  身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    } else { //身份证号码验证失败
        return NO;
    }
}


+(void)editing:(NSInteger)num textfield:(UITextField *)sender{
    if (sender.text.length) {
        NSMutableString *muStr = [NSMutableString new];
        for (int i=0; i<sender.text.length; i++) {
            NSString * str = [sender.text substringWithRange:NSMakeRange(i, 1)];
            if ([UITools isNumber:str]) {
                [muStr appendString:str];
            }
        }
        sender.text = muStr;
    }
    if ([sender.text containsString:@"."]) {
        NSArray *arr = [sender.text componentsSeparatedByString:@"."];
        NSString *str0 = arr[0];
        if (str0.length == 0) {
            sender.text = [NSString stringWithFormat:@"0.%@",arr[1]];
        }
        if (arr.count == 2) {
            NSString *str1 = arr[1];
            if (str1.length>num) {
                sender.text = [NSString stringWithFormat:@"%@.%@",arr[0],[str1 substringToIndex:num]];
            }
        }
        if (arr.count >= 3) {
            sender.text = [NSString stringWithFormat:@"%@.%@",arr[0],arr[1]];
        }
    }
}

+(void)editing:(NSInteger)num textView:(UITextView *)sender{
    if (sender.text.length) {
        NSMutableString *muStr = [NSMutableString new];
        for (int i=0; i<sender.text.length; i++) {
            NSString * str = [sender.text substringWithRange:NSMakeRange(i, 1)];
            if ([UITools isNumber:str]) {
                [muStr appendString:str];
            }
        }
        sender.text = muStr;
    }
    if ([sender.text containsString:@"."]) {
        NSArray *arr = [sender.text componentsSeparatedByString:@"."];
        NSString *str0 = arr[0];
        if (str0.length == 0) {
            sender.text = [NSString stringWithFormat:@"0.%@",arr[1]];
        }
        if (arr.count == 2) {
            NSString *str1 = arr[1];
            if (str1.length>num) {
                sender.text = [NSString stringWithFormat:@"%@.%@",arr[0],[str1 substringToIndex:num]];
            }
        }
        if (arr.count >= 3) {
            sender.text = [NSString stringWithFormat:@"%@.%@",arr[0],arr[1]];
        }
    }
}

+ (BOOL)validateEmail:(NSString *)email

{

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:email];

}

//+(BOOL)isChinese{
//    NSString *language = CurrentLanguage;
//    if ([[NSBundle getCusLanguage] containsString:@"zh"]) {
//        return YES;
//    }else{
//        return NO;
//    }
//}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }

    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}


+(BOOL)isSupportFaceIdOrFingerPrint{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    
    // 判断设置是否支持指纹识别(iPhone5s+、iOS8+支持)
    BOOL support = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    
    return support;
}

+(NSString *)ECDSACode:(NSString *)code withPrivateKey:(NSString *)privateKey{
    return code;
}

+(void)showError:(NSError *)error{
    if (error.userInfo[@"NSLocalizedDescription"]) {
        NSLog(@"----->%@",error.userInfo[@"NSLocalizedDescription"]);
        NSDictionary *dic = [UITools readLocalFileWithName:@"ch_service_error(1)"];
        NSString *msg =dic[error.userInfo[@"NSLocalizedDescription"]];
        NSLog(@"----->%@",msg);
        if([[error localizedDescription] isEqualToString:@"The Internet connection appears to be offline."] || [[error localizedDescription] isEqualToString:@"似乎已断开与互联网的连接。"]){
//            if ([MPay currentLanguage] == 0) {
                [SVProgressHUD showInfoWithStatus:@"似乎已断开与互联网的连接。"];
//            }else{
//                [SVProgressHUD showInfoWithStatus:@"The Internet connection appears to be offline."];
//            }
        }else{
            [SVProgressHUD showInfoWithStatus:[error description]];
        }
        

    }
}
+ (void)showToast:(NSString *)toast {
    [SVProgressHUD showInfoWithStatus:toast];
}
+ (CGFloat)labelLayoutHeight:(NSString *)content withTextFontSize:(CGFloat)mFontSize withLineSpaceing:(CGFloat)lineSpace withWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.lineSpacing = lineSpace;  // 段落高度

    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:content];

    [attributes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:mFontSize] range:NSMakeRange(0, content.length)];
    [attributes addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];

    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;

    return attSize.height;
}

+(BOOL)regularVerify:(NSString *)regular withMatchString:(NSString *)str{
    NSString *regex = regular;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    // 对字符串进行判断
    if ([predicate evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}
+ (UIFont *)fontWeightMediumWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}

+ (UIFont *)fontWeightRegularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (UIFont *)fontWeightSemiboldWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}
//为tableView的section 绘制圆角
+(void)makeTableViewRadius:(UITableView *)tableView displayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 圆角角度
    CGFloat radius = 8.f;
    // 设置cell 背景色为透明
    cell.backgroundColor = UIColor.clearColor;
    // 创建两个layer
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    // 获取显示区域大小
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    // 获取每组行数
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    // 贝塞尔曲线
    UIBezierPath *bezierPath = nil;
    if (rowNum == 1) {
        // 一组只有一行（四个角全部为圆角）
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                           byRoundingCorners:UIRectCornerAllCorners
                                                 cornerRadii:CGSizeMake(radius, radius)];
    } else {
        if (indexPath.row == 0) {
            // 每组第一行（添加左上和右上的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                               byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                     cornerRadii:CGSizeMake(radius, radius)];
            
        } else if (indexPath.row == rowNum - 1) {
            // 每组最后一行（添加左下和右下的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                               byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                                     cornerRadii:CGSizeMake(radius, radius)];
        } else {
            // 每组不是首位的行不设置圆角
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
        }
    }
    // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
    normalLayer.path = bezierPath.CGPath;
    selectLayer.path = bezierPath.CGPath;
    
    
    UIView *nomarBgView = [[UIView alloc] initWithFrame:bounds];
    // 设置填充颜色
    normalLayer.fillColor = [UIColor whiteColor].CGColor;
    // 添加图层到nomarBgView中
    [nomarBgView.layer insertSublayer:normalLayer atIndex:0];
    nomarBgView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nomarBgView;
    
    UIView *selectBgView = [[UIView alloc] initWithFrame:bounds];
    selectLayer.fillColor = [UIColor whiteColor].CGColor;
    [selectBgView.layer insertSublayer:selectLayer atIndex:0];
    selectBgView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectBgView;
}

+(void)showToastHelperWithText:(NSString *)str{
    ToastHelper * th = [ToastHelper sharedToastHelper];
    [th toast:str];
}
+(void)pasteboardWithStr:(NSString *)str toast:(NSString *)toast{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:str];
    ToastHelper * th = [ToastHelper sharedToastHelper];
    [th toast:toast afterDelay:0.3];
}
+(void)QRCodeFromVC:(UIViewController *)vc scanVC:(UIViewController *)scanVC{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [vc.navigationController pushViewController:scanVC animated:YES];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [vc.navigationController pushViewController:scanVC animated:YES];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [vc presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [vc presentViewController:alertC animated:YES completion:nil];
}
@end
