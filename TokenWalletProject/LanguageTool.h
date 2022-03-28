//
//  LanguageTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/10.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LocalizedStr(key) \
        [LanguageTool localizedString:(key)]
#define LocalizedString(key, comment) \
        [LanguageTool localizedString:(key)]
#define LocalizedStrFromTable(key, tbl) \
        [LanguageTool localizedString:(key) table:(tbl)]
#define LocalizedStringFromTable(key, tbl, comment) \
        [LanguageTool localizedString:(key) table:(tbl)]

NS_ASSUME_NONNULL_BEGIN

@interface LanguageModel: NSObject

@property(nonatomic, copy, nullable) NSString *name;
@property(nonatomic, copy, nullable) NSString *type;

@end

@interface LanguageTool: NSObject

@property(nonatomic, strong, nullable) NSBundle *bundle;
@property(nonatomic, strong) NSArray<LanguageModel *> *languages;

+ (instancetype)shared;
+ (void)setLanguage:(NSString *)type;
+ (nullable LanguageModel *)currentLanguage;
+ (NSString *)localizedString:(NSString *)key;
+ (NSString *)localizedString:(NSString *)key table:(nullable NSString *)name;

@end

NS_ASSUME_NONNULL_END
