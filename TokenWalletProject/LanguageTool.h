//
//  LanguageTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/10.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define LocalizedStr(key) \
        [LanguageTool localizedString:(key)]
#define LocalizedString(key, comment) \
        [LanguageTool localizedString:(key)]
#define LocalizedStrFromTable(key, tbl) \
        [LanguageTool localizedString:(key) table:(tbl)]
#define LocalizedStringFromTable(key, tbl, comment) \
        [LanguageTool localizedString:(key) table:(tbl)]

#define UIImageLang(name) \
        [LanguageTool imageName:name]

NS_ASSUME_NONNULL_BEGIN

@interface LanguageModel: NSObject

@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *type;
@property (nonatomic, copy, nullable) NSString *languageCode;
@property (nonatomic, assign) BOOL isDefault;

@end

@interface LanguageTool: NSObject

@property(nonatomic, strong, nullable) NSBundle *bundle;
@property(nonatomic, strong) NSArray<LanguageModel *> *languages;
@property (nonatomic, strong) LanguageModel *languageDefault;

+ (instancetype)shared;
+ (void)setLanguage:(NSString *)type;
+ (nullable LanguageModel *)currentLanguage;
+ (NSString *)localizedString:(NSString *)key;
+ (NSString *)localizedString:(NSString *)key table:(nullable NSString *)name;
+ (UIImage *)imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
