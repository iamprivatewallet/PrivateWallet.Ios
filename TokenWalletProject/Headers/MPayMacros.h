//
//  MPayMacros.h
//  MPay
//
//  Created by Hyper on 8/5/20.
//

#ifndef MPayMacros_h
#define MPayMacros_h

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#define MPay_APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#pragma mark - empty conditions
#define isNotNull(obj) ((![obj isKindOfClass:[NSNull class]]) && obj)

#define isNotEmptyArray(array) \
(isNotNull(array) && \
[array isKindOfClass:[NSArray class]] && \
[array count])

#define isNotEmptyDictionary(dict) \
(isNotNull(dict) && \
[dict isKindOfClass:[NSDictionary class]] && \
[[dict allKeys] count])

#define isNotEmptyString(string) \
(isNotNull(string) && \
[string isKindOfClass:[NSString class]] && \
((NSString *)string).length)

#define ValidString(string) (isNotEmptyString(string) ? string : @"")

#pragma mark - shortcut
#define GCSAppDelegate (AppDelegate *)[UIApplication sharedApplication].delegate
#define _String(key) [MPay localizedString:key tbl:@"Localizable-General"]
#define _StringWithValue(key, value) [NSString localizedStringWithFormat:_String(key), value]
#define _ErrorString(string) [MPay errorLocalizedString:string]
#define GCSFontMedium(size) [UITools fontWeightMediumWithSize:size]
#define GCSFontRegular(size) [UITools fontWeightRegularWithSize:size]
#define GCSFontSemibold(size) [UITools fontWeightSemiboldWithSize:size]

#define ImageNamed(name) [UIImage imageNamed:name]
#define NSStringWithFormat(...) [NSString stringWithFormat:__VA_ARGS__]


#pragma mark - UIKit
#define isNotchScreen \
(ABS((double)kScreenHeight - 812.f) < DBL_EPSILON ||\
ABS((double)kScreenWidth - 812.f) < DBL_EPSILON ||\
ABS((double)kScreenHeight - 896.f) < DBL_EPSILON ||\
ABS((double)kScreenWidth - 896.f) < DBL_EPSILON)
#define kBottomSafe (isNotchScreen ? 34.f : 0.f)
/**垂直|水平方向上的伸缩比例，原始设计稿采用iPhone X逻辑分辨率 375 x 812 */
//#define kScaleVertical(vertical) (vertical * kScreenHeight / 812.f)
//#define kScaleHorizontal(horizontal) (horizontal * kScreenWidth / 375.f)

#pragma mark - Color
#define HexColor(value) [UIColor colorWithRed:(((value &0xFF0000) >>16))/255.0 green:(((value &0xFF00) >>8))/255.0 blue:((value &0xFF))/255.0 alpha:1.0]

/// 主题色
#define MainColor   HexColor(0x6776FF)
#define Color3_Text  HexColor(0x333333)
#define Color9_Text  HexColor(0x999999)
#define Color34_Text  HexColor(0x343434)
#define Color6_Text  HexColor(0x666666)

/// 提示颜色
#define MPayPromptColor HexColor(#FDDF01)
/// 错误颜色
#define MPayErrorColor HexColor(#DA4242)
#define MPayTextColor1 HexColor(#FFFFFF)
#define MPayTextColor2 HexColor(#CED5E5)
#define MPayTextColor3 HexColor(#B2BACE)
#define MPayTextColor4 HexColor(#717684)
#define MPayTextColor5 HexColor(#5B616F)
#define MPayTextColor6 HexColor(#424857)
/// 背景色-暗
#define MPayDarkBackColor HexColor(#34373B)
/// 背景色-亮
#define MPayLightBackColor HexColor(#373A3E)
/// 分割线
#define MPayLineColor HexColor(#424857)


#pragma mark - UserDefaultsKey
#define kUserDefaultsKey_APPLanguage @"MPayAPP_Language"

#define kWalletCookieKey @"Cookie_wallet"

#define kUserFrozenStatus @"YHXGPH_003"

#pragma mark - notification
#define GCSNotification_ADD(_tagrt, _sel, _name, _obj) \
[[NSNotificationCenter defaultCenter] addObserver:_tagrt selector:_sel name:_name object:_obj]

#define GCSNotification_POST(_name, _object, _userInfo) \
[[NSNotificationCenter defaultCenter] postNotificationName:_name object:_object userInfo:_userInfo]

#define GCSNotification_REMOVE(_target) \
[[NSNotificationCenter defaultCenter] removeObserver:_target]

static NSString * const kNotiNameUserAuthSuccess = @"kNotiNameUserAuthSuccess";
#endif /* MPayMacros_h */
