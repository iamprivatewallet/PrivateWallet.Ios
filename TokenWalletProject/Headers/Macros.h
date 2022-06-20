//
//  Macros.h
//  iPhone
//
//

//#define TESTCODE
//#define LiveCamera
//#define EchoTest
#define AudioEngineTest

#define APP_BUILDVER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APP_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//#define IOS_VERSION [NSString stringWithFormat:@"iOS %.2f",[[[UIDevice currentDevice] systemVersion] floatValue]]

//tabbar高度
#define TabBarHeight ((StatusHeight>20)?83:49)

//屏幕高度
//#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
//屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

//应用程序审核版本号
#define VER_KEY @"ver"
#define REVIEW_VER @"1608121800"
//项目标识号
#define PROJECT_KEY @"project"
#define PROJECT_ID  @"lizhime"
//ios系统版本号
#define OS_KEY  @"os"
#define OS_VERSION  @"2" // 2 = ios


//生产，测试环境切换
#define Request 0
#define SINA_WB
#define APP_GUIDE

#if Request
//#define SWLOG 4
//#define BaseURLString    @"https://app.bit-star.com/tx/"
//#define BaseOTCURLString    @"https://app.otc.bit-star.com/tx/"
//#define UploadURLString    @"http://10.0.0.201:8099/"
//#define PhotoEndPoint       @"oss-cn-shenzhen.aliyuncs.com"
//#define HuanXinAppKEY @"1178170906178834#shendunsijiban"
//#define BaseURLStringH5    @"https://bit-star.com/"

#else
//#define SWLOG 4
//#define BaseURLString    @"http://60.205.206.64:9008/tx/"
//#define BaseOTCURLString    @"http://60.205.206.64:9108/tx/"
//#define UploadURLString    @"http://bxadmin.ifbplus.com:9099/"
//#define PhotoEndPoint    @"oss-cn-shenzhen.aliyuncs.com"
//#define HuanXinAppKEY @"1178170906178834#shendundev"
//#define BaseURLStringH5    @"http://60.205.206.64:9009/"
#endif

//#ifdef RELEASE_VER
//#define SWLOG 4
//#define BaseURLString    @"https://bitstar.in/tx/"
//#define PhotoEndPoint       @"oss-cn-shenzhen.aliyuncs.com"
//#define HuanXinAppKEY @"1178170906178834#shendunsijiban"
//#define BaseURLStringH5    @"https://bitstar.in/"
//
//#else
//#define SWLOG 4
////#define BaseURLString    @"http://data.icwv.club:8008/tx/"
//#define BaseURLString    @"http://60.205.206.64:8008/tx/"
////#define BaseURLString    @"http://192.168.31.94:8000/tx/"
//#define PhotoEndPoint    @"oss-cn-shenzhen.aliyuncs.com"
//#define HuanXinAppKEY @"1178170906178834#shendundev"
//#define BaseURLStringH5    @"http://60.205.206.64:8009/"
//
//#endif

//request log AFHTTPResponseSerializer.m  255

//video
#define RECORD_MAX_TIME 8.0           //最长录制时间
#define TIMER_INTERVAL 1.0         //计时器刷新频率
#define VIDEO_FOLDER @"videoFolder" //视频录制存放文件夹

#define NumString(num)\
[NSString stringWithFormat:@"%ld", (long)num]

//第三方Key

#define BAIDU_VOICE_APP_ID @"10201747"
#define BAIDU_VOICE_API_KEY @"jCUTnCfjgrYN7GitTeOGV5PC"
#define BAIDU_VOICE_SECRET_KEY @"HH83MuPZbXIIjTG4lKsm06FAXKrpRrNZ"

#define UMENG_ALIAS_TYPE @"SDOWNER"
#define UMENG_APPKEY @"5a26a324f43e4804c00000b0"

#define AliYun_Key @"LTAIk8fqNePbEvLf"
#define AliYun_Secret @"PRZbjAOua61ky6EhB3EvgjJZuFGr5E"
#define AliYun_Token @"CAIS9AF1q6Ft5B2yfSjIrLmCANvjq7l2xqSxSB/JgjFhZMNBrobokTz2IHBIeXhhAu8fv/4/nmxT5/cclqB6T55OSAmcNZIoNgSlVILiMeT7oMWQweEuqv/MQBq+aXPS2MvVfJ+KLrf0ceusbFbpjzJ6xaCAGxypQ12iN+/i6/clFKN1ODO1dj1bHtxbCxJ/ocsBTxvrOO2qLwThjxi7biMqmHIl1z8vsfzjn5LNsUuF0AGj8IJP+dSteKrDRtJ3IZJyX+2y2OFLbafb2EZSkUMaqPon3fcboGad7ovBWAgAvQ/iKOrZ9NFyKg9kYaQ7C2fTbywLJmMSGoABhJvQFZ1y23V15eXaxbZGDALESfvtLrl0C0Pr3uCZtiMrEwHE/9JYa+ly3dDEe7l9nZ++NUGUZsvD3Xrfms0Wpy8aae1SD4itvkb4D5NBMRjfjCLafr4r2uoC/AcC/VXWutSOuQFT0eeIeuqh8YYCOgJI4GtgjBHaWJi+pZCdJEk="

#define GAOMAPKEY @"176581f4a54a7ade9746181ce3231bd5"

//#define SINA_AppID  @"2382830827"
//#define SINA_AppSecret @"c56de53601ea19945fc5b15e6cc0aa19"

//#define QQ_KEY @"1105359922"
//#define QQ_SECRET @"4xG8gj76eF3GyPBk"

#define WeiXin_KEY @"wx3d85153c78f16bce"
#define WeiXin_SECRET @"513e6a62475a71275393df4c1195c92c"

//#define TuSDK_KEY @"049794b8cee78802-02-pl9lp1"

#define kDeviceToken @"deviceTokenk"
#define kThirdLogin @"_kThirdLogin_"

//常量定义
#define NAVBTN_WIDTH 26.5f
#define NAVBTN_HEIGHT 44.f

#define NETPERC_MAX 90
#define NETPERC_MIN 70

#define baseTag 1000

#define pageLoadSize 10

#define CODE_SUCCESS @"0000"

#define Timer_Refresh_Delay 3.f

#define Timer_Refresh_Distance 8.f

//#define videoBitrate 500*1000

//typedef NS_ENUM(NSUInteger, RelationShip)
//{
//    RS_UnKnow = -1,
//    RS_Stranger = 0,//没关系
//    RS_Fans = 1,//关注我的
//    RS_Focus = 2,//我关注的
//    RS_Friend = 3,//互相关注
//};



#define LBLocalized(key) \
NSLocalizedStringFromTableInBundle(key, @"Localizable", [NSBundle mainBundle], nil)

#define jsFuncName(str) [NSString stringWithFormat:@"getCookies('%@');", str]

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

//
#define MinX(v) CGRectGetMinX([v frame])
#define MinY(v) CGRectGetMinY([v frame])
#define MaxX(v) CGRectGetMaxX([v frame])
#define MaxY(v) CGRectGetMaxY([v frame])
#define MidX(v) CGRectGetMidX([v frame])
#define MidY(v) CGRectGetMidY([v frame])
#define Width(v) CGRectGetWidth([v frame])
#define Height(v) CGRectGetHeight([v frame])
#define CImageView(v) [[UIImageView alloc] initWithImage:v]

#define _WEAK_SELF __weak __typeof(self) wself = self;
#define _STRONG_SELF __strong __typeof(wself) strongSelf = wself;

//判断系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IS_OS_11_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
//语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断设备
#define IS_SCREEN_X_INCH    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_55_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_47_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_4_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_35_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//#define screen_weight  \
//(1)

//iphone x 高度
#define WIDTH_812 812.0

//转换成浮点数
#define OBJ2FLOAT(v, s)  (s = (v == nil || v == [NSNull null]) ? 0.0 : [v doubleValue])
//转换成整型
#define OBJ2INT(v, s)  (s = (v == nil || v == [NSNull null]) ? 0 : [v integerValue])
//转换成字符串
#define OBJ2STR(v, s)  (s = (v == nil || v == [NSNull null]) ? @"" :v)
//消除nil字符串
#define NONNILSTR(v)    (v = (v == nil || v == [NSNull null]) ? @"" : v)
//消除nil的Nsnumber
#define NONNILNSNUMBER(v)   (v = (v == nil || v == [NSNull null]) ? [NSNumber numberWithInt:0] : v)

//测试数组
#define OBJArray(v,s) (s = (v == nil || v == [NSNull null]) ? @[] :v)
//测试字典
#define OBJDictionary(v,s) (s = (v == nil || v == [NSNull null]) ? @{} :v)

//判断是否为空字符串
#define ISEMPTYSTR(str)   (str == nil || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])

//界面宽高
#define STATUSBAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define STATUSBAR_WIDTH ([[UIApplication sharedApplication] statusBarFrame].size.width)
#define NAVBAR_HEIGHT  44.0f
#define TABBAR_HEIGHT  49.0f

#define kIsBangsScreen ({\
    BOOL isBangsScreen = NO; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    isBangsScreen = window.safeAreaInsets.bottom > 0; \
    } \
    isBangsScreen; \
})

//#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define ScaleLength(x)  \
    floorf((x) / 1334.f * ([UIScreen mainScreen].bounds.size.width))
#define ScaleHeigth(x) \
    floorf((x) / 750.f * ([UIScreen mainScreen].bounds.size.height))


#define ScaleFactor 1

#define AdHeight 90.f

//将size放大/缩小n倍
#define SIZE_SCALE(size,n) (CGSizeMake(size.width*n, size.height*n))

#define SAFE_RELEASE(x) [x release];x=nil  //release

//notifycations
#define kNotificationUserLoginSuccess @"kNotificationUserLoginSuccess"
#define kNotificationUserNeedLogout @"kNotificationUserNeedLogout"
#define kNotificationUserCollecitonCoinChanged @"kNotificationUserCollecitonCoinChanged"
#define kNotificationUserSetTransPasswordSuccess @"kNotificationUserSetTransPasswordSuccess"
#define kNotificationUserCancelTransEntrust @"kNotificationUserCancelTransEntrust"
#define kNotificationUserShouldBuySell @"kNotificationUserShouldBuySell"
#define kNotificationLeaderCoinModel @"kNotificationLeaderCoinModel"


#define kLInfo @"L_UserInfo"
#define kLoginType @"k_LoginType"
#define kId @"k_Id"
#define kPassword @"k_Password"

//数组越界判定
#define ISINDEXINRANGE(idx,arr)\
(idx >=0 && idx < arr.count)

//手机号码校验

//检测是否是手机号码
/**
 * 手机号码
 * 移动：134,135,136,137,138,139,147,150,151,152,157,158,159,178,182,183,187,188,//移动
 * 联通：130,131,132,155,156,185,186,145,176,//联通
 * 电信：133,153,170,177,180,181,189,//电信
 */

//    130,131,132,133,134,135,136,137,138,139
//    145,147,
//    150,151,152,153,155,156,157,158,159,
//    170,176,177,178,
//    180,181,182,183,185,186,187,188,189,
#define ISPHONENUM(str)\
[[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1(3[0-9]|4[57]|5[0-35-9]|7[06-8]|8[0-35-9])\\d{8}$"] evaluateWithObject:str]
#define ISPASSWORD(str)\
[[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"] evaluateWithObject:str]
#define ISNUMBERS(str)\
[[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"] evaluateWithObject:str]

#define ISIDCARD(str)\
[[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(\\d{14}|\\d{17})(\\d|[xX])$"] evaluateWithObject:str]

//

//微软雅黑字体定义
#define FONT_MSYH(F) [UIFont fontWithName:@"MicrosoftYaHei" size:F]
//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define USER_DEFAULT [NSUserDefaults standardUserDefaults] //user Default



#define UserDefault_IsHideData @"UserDefault_IsHideData"
#define UserDefault_SMID       @"UserDefault_SMID"
#define UserDefault_UserInfo   @"UserDefault_UsetInfo"
#define UserDefault_UserSetting @"UserDefault_UserSetting"
#define UserDefault_DownloadAddress @"UserDefault_DownloadAddress"
#define UserDefault_NoNotice   @"UserDefault_NoNotice"
#define UserDefault_Version    @"UserDefault_Version"
#define UserDefault_Token       @"UserDefault_TOKEN"
#define UserDefault_UUID       @"UserDefault_UUID"

#define kNotificationYunlibaoWithdrawSuccess        @"kNotificationYunlibaoWithdrawSuccess"
#define kNotificationWithdrawSuccess_OTC        @"kNotificationWithdrawSuccess_OTC"
#define kNotificationWithdrawSuccess_USTD        @"kNotificationWithdrawSuccess_USTD"
#define kNotificationWithdrawAccountTypeChoosen  @"kNotificationWithdrawAccountTypeChoosen"

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
//例如 imageView.image =  LOADIMAGE(@"文件名",@"png");

//锁屏

#define NotificationLock                CFSTR("com.apple.springboard.lockcomplete")

#define NotificationChange              CFSTR("com.apple.springboard.lockstate")

#define NotificationPwdUI               CFSTR("com.apple.springboard.hasBlankedScreen")

#define NotificationLockScreen          @"NotificationLockScreen"

#define NotificationUnLockScreen        @"NotificationUnLockScreen"

#define NotificationAppClickHome        @"NotificationAppClickHome"

#define NotificationRecoverAfterHome    @"NotificationRecoverAfterHome"

#define NotificationCallDisconnect      @"NotificationCallDisconnect"

#define NotificationCallIncoming        @"NotificationCallIncoming"

#define NotificationRtmpServerDestroy   @"NotificationRtmpServerDestroy"

#define NotificationRtmpRestart         @"NotificationRtmpRestart"

#define NotificationWillEnterForeground @"NotificationWillEnterForeground"

#define NotificationWillResignActive    @"NotificationWillResignActive"

#define NotificationDidBecomeActive     @"NotificationDidBecomeActive"

#define NotificationNeedLianmai         @"NotificationNeedLianmai"

#define NotificationNetworkNotReachable @"NotificationNetworkNotReachable"

#define NotificationNetworkAvailable    @"NotificationNetworkAvailable"
//定义UIImage对象
#define IMAGE(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

#define IMAGEX(imageName,idx) [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld", imageName, (long)idx]]

// degrees/radian functions
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG) [_OBJECT viewWithTag:_TAG]

//
#define ITTAssert(condition, ...)   \
do {    \
    if (!(condition)) { \
        [[NSAssertionHandler currentHandler]    \
        handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
        file:[NSString stringWithUTF8String:__FILE__]   \
        lineNumber:__LINE__ \
        description:__VA_ARGS__];   \
    }   \
} while(0)

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...){}
#endif




#ifdef SWLOG
#define SWLog(l, s) NSLog(@"SWlogInfo %@(%d%s) \n%@", l, __LINE__, __func__, (s))

#if SWLOG == 4
#define SWLogV(f, s...) SWLog(@"LOGV:", ([NSString stringWithFormat:f, ##s]))
#define SWLogD(f, s...) SWLog(@"LOGD:", ([NSString stringWithFormat:f, ##s]))
#define SWLogE(f, s...) SWLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define SWLogW(f, s...) SWLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if SWLOG == 3
#define SWLogV(f, s...)
#define SWLogD(f, s...) SWLog(@"LOGD:", ([NSString stringWithFormat:f, ##s]))
#define SWLogE(f, s...) SWLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define SWLogW(f, s...) SWLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if SWLOG == 2
#define SWLogV(f, s...)
#define SWLogD(f, s...)
#define SWLogE(f, s...) SWLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define SWLogW(f, s...) SWLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if SWLOG == 1
#define SWLogV(f, s...)
#define SWLogD(f, s...)
#define SWLogE(f, s...)
#define SWLogW(f, s...) SWLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if SWLOG == 0
#define SWLogV(f, s...)
#define SWLogD(f, s...)
#define SWLogE(f, s...)
#define SWLogW(f, s...)
#endif

#endif


#define Scale(x)  \
floorf((x) / 1334.f * ([UIScreen mainScreen].bounds.size.width))

#define NETWORK_ERROR_STRING @"网络或服务器异常，请稍后再试"
#define NO_MORE_DATA @"没有更多数据"
#define N_SERVICE_PHONE @"4006988868"
#define N_SERVICE_PHONE2 @"400-698-8868"

#define USE_FROM @"2"

//根据ip6的屏幕来拉伸
//#define kRealValue(with)((with)*(SCREEN_WIDTH/375.0f))
#define kRealValue(with) CGFloatScale((with))


//View圆角和加边框
#define ViewBorderRadius(View,Radius,Width,Color) \
[View.layer setCornerRadius:(Radius)]; \
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


// View圆角
#define ViewRadius(View,Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//noticecenter
#define NotificationCenter_HomeAdUrlLSkip @"NotificationCenter_HomeAdUrlLSkip"
#define NotificationCenter_LoginSuccess @"NotificationCenter_LoginSuccess"

#define UMengShareKey @"5d413afe3fc195b651000516"
#define WXSharekey @"wx47b564359b292971"
#define WXShareSecret @"2ec606fff1b90b31e83ddce1977266c2"

#define lastVersionName @"lastVersionName"
#define isSetGesturePS @"isSetGesturePS"



#define  API_1  @"/api/geetest/startcaptcha"
#define  API_2  @"/api/geetest/verifylogin"

#define RESPONSE_CODE @"code"
#define RESPONSE_SUCCESS 10000
#define RESPONSE_MESSAGE @"msg"
#define REPONSE_TOKEN_UNUSABLE 40010
#define REPONSE_TOKEN_UNKNOW 40011


#define DOWNLOAD_ADDRESS [USER_DEFAULT objectForKey:UserDefault_DownloadAddress]
#define SERVICE_EMAIL @"service1128@mpay.com"



#define HTML_BILL @"/#/bill"
//#define HTML_BILL @"/#/cookie" //测试，请勿打开
#define HTML_RECHARGE @"/#/charge"
#define HTML_TRANSFER @"/#/transfer"
#define HTML_CHARGECOIN @"/#/chargecoin"
#define HTML_WITHDRAW @"/#/withdraw"
#define HTML_WITHDRAWCOIN @"/#/withdrawcoin"
#define HTML_RECEIPT @"/#/receipt"
#define HTML_TRANSFERIN @"/#/transferin" //转入
#define HTML_TRANSFEROUT @"/#/transferout"

