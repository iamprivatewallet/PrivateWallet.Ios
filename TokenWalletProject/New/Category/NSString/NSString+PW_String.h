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
- (BOOL)isURL;
- (BOOL)isHttpsURL;
- (NSString *)pw_firstChar;
- (NSString *)pw_firstCharLower;
- (NSString *)pw_firstCharUpper;

@end

NS_ASSUME_NONNULL_END
