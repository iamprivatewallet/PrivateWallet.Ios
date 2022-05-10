//
//  NSString+PW_String.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (PW_String)

+ (NSString *)emptyStr:(NSString *)str;

+ (NSString *)timeStrTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)timeStrTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format;

+ (NSString *)deviceUUID;

- (NSString *)currency;

- (void)pasteboard;
- (void)pasteboardToast:(BOOL)toast;

- (BOOL)judgePassWordLegal;

- (NSString *)showShortAddress;
- (NSString *)showAddressHead:(NSInteger)head tail:(NSInteger)tail;

- (BOOL)isInt;
- (BOOL)isFloat;
- (BOOL)isAllChinese;
- (BOOL)isAllAlpha;
- (BOOL)isAlphaURL;
- (BOOL)isURL;
- (BOOL)isHttpsURL;
- (NSString *)pw_firstChar;
- (NSString *)pw_firstStr;
- (NSString *)pw_firstCharLower;
- (NSString *)pw_firstCharUpper;
- (NSString *)pw_firstStrLower;
- (NSString *)pw_firstStrUpper;

+ (BOOL)isChinese:(NSString *)str;
+ (BOOL)isAlpha:(NSString *)str;
+ (BOOL)isAlphaURL:(NSString *)str;

- (BOOL)hasPrefixOx;
- (NSString *)strTo10;
- (NSString *)strTo16;
- (NSString *)addOxPrefix;
- (NSString *)getStrTo16;
- (NSString *)get16ToStr;

@end

NS_ASSUME_NONNULL_END
