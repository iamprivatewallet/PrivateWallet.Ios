//
//  CommonHeader.h
//  Created by 孙林林 on 2019/4/23.
//  Copyright © 2019 tigerobo. All rights reserved.
//

#ifndef CommonHeader_h
#define CommonHeader_h

typedef enum {
    Image_Effect_Brightness = 0,
    Image_Effect_TiltShift = 1
}Image_Effects_Type;

#define APPName    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define APPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APPBuild   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APPIconPath   [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject]
#define APPIcon    [UIImage imageNamed:APPIconPath]
#define APPBundleIdentifier [[NSBundle mainBundle] bundleIdentifier]
#define APPBundleName   [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
//判断是否为iPhoneX及以上机型 ios11
//#define IS_GREATER_IPHONEX ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] //系统版本-float

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define
#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
//#define kStatusBarHeight           (CGFloat)(iPhoneX?(44.0):(20.0))/*状态栏高度*/
#define kStatusBarHeight            ([UIApplication sharedApplication].statusBarFrame.size.height)
#define kNavBarHeight (44)/*导航栏高度*/
#define kNavBarAndStatusBarHeight  (CGFloat)(kStatusBarHeight+kNavBarHeight)/*状态栏和导航栏总高度*/
#define kTabBarHeight              (CGFloat)(iPhoneX?(49.0 + 34.0):(49.0))/*TabBar高度*/
#define kTopBarSafeHeight          (CGFloat)(iPhoneX?(44.0):(0))/*顶部安全区域远离高度*/
#define kBottomSafeHeight          (CGFloat)(iPhoneX?(34.0):(0))/*底部安全区域远离高度*/
#define kTopBarDifHeight           (CGFloat)(iPhoneX?(24.0):(0))/*iPhoneX的状态栏高度差值*/
#define kNavAndTabHeight           (kNavBarAndStatusBarHeight + kTabBarHeight)/*导航条和Tabbar总高度*/
#define kContentHeight             (SCREEN_HEIGHT - kNavBarAndStatusBarHeight-kTabBarHeight)
#define kTabBarNormalHeight (49)

#pragma mark - 图片资源获取
#define kIMGFROMBUNDLE( X )     [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:X ofType:@""]]
#define kImageNamed( X )         [UIImage imageNamed:X]


#define kLocString( X )         NSLocalizedString(X, nil)

#define kScale (SCREEN_WIDTH/375.0)
#define kIPadScale (IS_IPAD?1:kScale)


#define kMinScale (SCREEN_MIN_LENGTH/375.0)
#define kIPadMinScale (IS_IPAD?1:kMinScale)


#define kFloor(c) floorf(c)
#define kRound(c) roundf(c)
#define kCeil(c) ceilf(c)
#define kMod(c1,c2) fmodf(c1,c2)

#define kHeightScale    (SCREEN_HEIGHT/812.0)

#define kHalfRound(c) (kRound(c*2)*0.5)
#define kHalfFloor(c) (kFloor(c*2)*0.5)
#define kHalfCeil(c) (kCeil(c*2)*0.5)

//用户数据存储
#define UserDefaults                 [NSUserDefaults standardUserDefaults]
#define SetUserDefaultsForKey(value,key)               [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define GetUserDefaultsForKey(key)   [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define RemoveUserDefaultsForKey(key)   [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]

#pragma mark - 单例
#define DECLARE_SINGLETON(cls_name, method_name)\
+ (cls_name*)method_name;


#define IMPLEMENT_SINGLETON(cls_name, method_name)\
+ (cls_name *)method_name {\
static cls_name *method_name;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
method_name = [[cls_name alloc] init];\
});\
return method_name;\
}

#define UIAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif


#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#pragma mark - 静态方法
static inline CGFloat SizeScale(CGFloat size, BOOL adjustIpad){
    size = size * (adjustIpad?kIPadMinScale:kMinScale);
    size = kHalfFloor(size);
    return size;
}

static inline CGFloat CGFloatScale(CGFloat value){
    return SizeScale(value, YES);
}

static inline UIFont* SystemFontScale(CGFloat size){
    UIFont *font = [UIFont systemFontOfSize:CGFloatScale(size)];
    return font;
}


static inline BOOL EmptyString(NSString *str){
    if (!str) {
        return YES;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (str.length == 0) {
        return YES;
    }
    
    return NO;
}

static inline NSString * GetString(id str){
    if (!str || [str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if (![str isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", str];
    }
    return str;
}


#endif /* CommonHeader_h */
