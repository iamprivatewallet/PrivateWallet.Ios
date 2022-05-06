//
//  LanguageTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/10.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "LanguageTool.h"

static NSString * _Nonnull LanguageTypeKey = @"appLanguage";

@implementation LanguageModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation LanguageTool

+ (instancetype)shared {
    static LanguageTool *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}
- (NSArray<LanguageModel *> *)languages {
    if(!_languages){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Language" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *lanArr = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            if([dict isKindOfClass:[NSDictionary class]]){
                LanguageModel *model = [[LanguageModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [lanArr addObject:model];
            }
        }
        _languages = [lanArr copy];
    }
    return _languages;
}
- (LanguageModel *)languageDefault {
    if(!_languageDefault){
        NSArray *array = [LanguageTool shared].languages;
        __block LanguageModel *model = array.firstObject;
        [array enumerateObjectsUsingBlock:^(LanguageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.isDefault){
                model = obj;
                *stop = YES;
            }
        }];
        _languageDefault = model;
    }
    return _languageDefault;
}
- (NSBundle *)bundle {
    if(!_bundle){
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        if(_bundle){
            return _bundle;
        }
        NSString *lan = [[NSUserDefaults standardUserDefaults] stringForKey:LanguageTypeKey];
        if(lan==nil||(lan&&[lan isEqualToString:@""])){
//            //系统语言
//            NSArray *languages = [NSLocale preferredLanguages];
//            NSString *currentLanguage = languages.firstObject;
//            __block BOOL isFind = NO;
//            [[LanguageTool shared].languages enumerateObjectsUsingBlock:^(LanguageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if([currentLanguage hasPrefix:obj.type]) {
//                    [LanguageTool setLanguageType:obj.type];
//                    isFind = YES;
//                    *stop = YES;
//                }
//            }];
//            if(!isFind){
//                [LanguageTool setLanguageType:self.languageDefault.type];
//            }
            [LanguageTool setLanguageType:self.languageDefault.type];
        }
        lan = [[NSUserDefaults standardUserDefaults] stringForKey:LanguageTypeKey];
        NSString *path = [[NSBundle mainBundle] pathForResource:lan ofType:@"lproj"];
        if(path==nil){
            path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            [LanguageTool setLanguageType:self.languageDefault.type];
        }
        if(path){
            _bundle = [[NSBundle alloc] initWithPath:path];
        }
        dispatch_semaphore_signal(semaphore);
    }
    return _bundle;
}
+ (void)setLanguageType:(NSString *)type {
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:LanguageTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [LanguageTool shared].bundle = nil;
}
+ (nullable LanguageModel *)currentLanguage {
    NSString *lan = [[NSUserDefaults standardUserDefaults] stringForKey:LanguageTypeKey];
    __block LanguageModel *model = nil;
    [[LanguageTool shared].languages enumerateObjectsUsingBlock:^(LanguageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([lan hasPrefix:obj.type]) {
            model = obj;
            *stop = YES;
        }
    }];
    return model;
}
+ (NSString *)localizedString:(NSString *)key {
    return [self localizedString:key table:nil];
}
+ (NSString *)localizedString:(NSString *)key table:(nullable NSString *)name {
    NSString *str = [[LanguageTool shared].bundle localizedStringForKey:key value:@"" table:name];
    return str ? : @"";
}
+ (UIImage *)imageName:(NSString *)imageName {
    LanguageModel *model = [LanguageTool currentLanguage];
    if(model.isDefault){
        return [UIImage imageNamed:imageName];
    }else{
        NSString *langType = [model.type componentsSeparatedByString:@"-"].firstObject;
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",imageName,langType]];
    }
}

@end
