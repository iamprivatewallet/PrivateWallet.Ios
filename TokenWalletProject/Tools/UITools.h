//
//  UITools.h
//  EZTV
//
//  Created by Phil Xhc on 16/1/18.
//  Copyright © 2016年 Joygo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
#import <GMEllipticCurveCrypto.h>

typedef NS_ENUM(NSUInteger,AnimationType){
    AnimationType_Appear = 1,
    AnimationType_Disappear = 2,
};


@interface UITools : NSObject

+(void)showToastHelperWithText:(NSString *)str;

+(void)pasteboardWithStr:(NSString *)str toast:(NSString *)toast;

+(void)QRCodeFromVC:(UIViewController *)vc scanVC:(UIViewController *)scanVC;

+(void)makeTableViewRadius:(UITableView *)tableView displayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

+ (CGFloat)bottomOffsetYofScrollView:(UIScrollView *)scrollView;

+ (CGSize)sizeWithString:(NSString *)string attributes:(NSDictionary *)attributes bounds:(CGSize)bounds;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(float)width;

+ (NSArray *)locationOfLabel:(UILabel *)firstLabel secondLabel:(UILabel *)secondLabel string:(NSString *)string;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font height:(CGFloat)height width:(CGFloat)width;

+ (NSMutableAttributedString *)injForecastfirString:(NSString *)firString
                                           firColor:(UIColor *)firColor
                                            firBold:(BOOL)firBold
                                          secString:(NSString *)secString
                                           secColor:(UIColor *)secColor
                                            secBold:(BOOL)secBold
                                               font:(CGFloat)font;

+ (UIBarButtonItem *)addSaveBtn:(UIViewController *)viewController selector:(SEL)btnClick;

+ (void)addMaskLayerToView:(UIView *)view radius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;
+ (void)setPartRoundWithView:(UIView *)view corners:(UIRectCorner)corners cornerRadius:(float)cornerRadius;
+ (void)addMaskLayerToView:(UIView *)view withRadius:(CGFloat)radius;

+ (void)addEffectToView:(UIView *)view withRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners borderWidth:(CGFloat)width borderColor:(UIColor *)color;

+ (void)addShadowToView:(UIView*)view;

+ (void)addAnimationView:(UIView *)view withType:(AnimationType)type time:(float)time;

+ (NSMutableAttributedString *)stringWithFirString:(NSString *)firString
                                          firColor:(UIColor *)firColor
                                         secString:(NSString *)secString
                                          secColor:(UIColor *)secColor
                                              bold:(BOOL)bold
                                              font:(CGFloat)font;

+ (NSMutableAttributedString *)stringWithFirStringThree:(NSString *)firString
                                               firColor:(UIColor *)firColor
                                              secString:(NSString *)secString
                                               secColor:(UIColor *)secColor
                                            thirdString:(NSString *)thirdString
                                             thirdColor:(UIColor *)thirdColor
                                                   bold:(BOOL)bold
                                                   font:(CGFloat)font;


+ (int)getAttributedStringHeightWithString:(NSMutableAttributedString *)string widthValue:(int)width;

+ (NSString *)gs_getCurrentTimeBySecond;

+ (NSString *)gs_getCurrentTimeStringToMilliSecond;

+ (NSString *)timeLabelWithDate:(NSDate *)date;

+(NSString *)timeLabelWithTimeInterval:(NSString * )timeInterval;

+ (NSString *)timeStringWithDate:(NSDate *)date;

+ (NSString *)dayStringWithDate:(NSDate *)date;

+ (CGFloat)chatFontSize;

+ (CGFloat)fullScreenChatFontSize;

+ (NSString *)dayTimeStringWithDate:(NSDate *)date;

+ (NSString *)YearMonthDayTimeStringWithDate:(NSDate *)date;

+ (CGFloat)fontSizeWithOriginFont:(CGFloat)fontSize;

+ (NSString *)subStringWith:(NSString *)string ToIndex:(NSInteger)index;

+ (NSString *)getCountDownStringWithEndTime:(NSString *)endTime;

+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

+ (NSAttributedString *)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

+ (void)setLableProperties:(UILabel*)lable withColor:(UIColor*)color andFont:(UIFont*)font;

+(NSAttributedString *)setParagraphHeithWithText:(NSString *)text withHeight:(CGFloat)height;

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;

+ (void)addShadowToView:(UIView *)view
             withRadios:(float)shadowRadios withOpacity:(float)shadowOpacity;

+ (void)addDashBackground:(UIView*)view;

+ (NSDictionary *)readLocalFileWithName:(NSString *)name;
+ (BOOL)containChinese:(NSString *)str;
+(id)jsonStringToDictionary:(NSString *)jsonString;
+ (void)saveImage:(UIImage *)image;
+(NSString *)base64FromImage:(UIImage *)image;
+(UIImage *)imagefromBase64:(NSString *)str;

+ (BOOL)isNumber:(NSString *)strValue;

+(NSString *)getCacheSize;

+ (void)ClearCache;

+(NSString *)md5:(NSString *)str;

//+(BOOL)isOpenCameraJurisdiction;

+(BOOL)isOpenCameraJurisdictionNoPop;

+(BOOL)isOpenPhotosJurisduiction;

+(BOOL)isOpenContractJurisdiction;

+(BOOL)checkPincode:(NSString*)pincode;

+ (BOOL)cly_verifyIDCardString:(NSString *)idCardString;

+(void)editing:(NSInteger)num textfield:(UITextField *)sender;

+(void)editing:(NSInteger)num textView:(UITextView *)sender;

+ (BOOL)validateEmail:(NSString *)email;

//+(BOOL)isChinese;

+ (UIViewController *)getCurrentVC;

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC;

+(BOOL)isSupportFaceIdOrFingerPrint;

+(NSString *)ECDSACode:(NSString *)code withPrivateKey:(NSString *)privateKey;

+(void)showError:(NSError *)error;
+ (void)showToast:(NSString *)toast;

+ (CGFloat)labelLayoutHeight:(NSString *)content withTextFontSize:(CGFloat)mFontSize withLineSpaceing:(CGFloat)lineSpace withWidth:(CGFloat)width;

+(BOOL)regularVerify:(NSString *)regular withMatchString:(NSString *)str;

+ (UIFont *)fontWeightMediumWithSize:(CGFloat)size;
+ (UIFont *)fontWeightRegularWithSize:(CGFloat)size;
+ (UIFont *)fontWeightSemiboldWithSize:(CGFloat)size;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *)bigStringWith16String:(NSString *)str;

+(NSMutableAttributedString *)appendImageWithLabelText:(NSString *)text image:(NSString *)image;
+ (NSString *)subRangeStr:(NSString *)string fromStart:(NSString *)startStr toEnd:(NSString *)endStr;
@end
