//
//  Macro.h
//  DemoApp
//
//  Created by Zinkham on 15/10/21.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#ifndef Macro_h
#define Macro_h
#import "AppDelegate.h"
#import "LanguageTool.h"

//重新定义系统的NSLog，__OPTIMIZE__ 是release 默认会加的宏,release版本不打日志
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...){}
#endif


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define COLORA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define COLOR_HEX(s) [CATCommon colorWithHexString:s]

#define ScreenSize [[UIScreen mainScreen]bounds].size

#define IconFont(fontsize) [UIFont fontWithName:@"IconFont" size:fontsize]

#define FONT(fontsize)   [UIFont systemFontOfSize:fontsize]

#define Set_Font(fontname,fontsize) [UIFont fontWithName:[NSString stringWithFormat:@"PingFangSC-%@",fontname] size:fontsize]

#define TheAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define isIPhoneX ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

#define NavAndStatusHeight  (44+[[UIApplication sharedApplication] statusBarFrame].size.height)

#define StatusHeight  [[UIApplication sharedApplication] statusBarFrame].size.height

#define NavHeight  44

#define TAB_HEIGHT (isIPhoneX ? 70 : 50)

#define CFLScaleValue ([UIScreen mainScreen].bounds.size.width/375.0f)

#define ReleaseClass NSLog(@"release class:%@",NSStringFromClass([self class]))

#define BG_BlACK [UIColor blackColor]
#define BG_WHITE [UIColor whiteColor]
#define COLOR_BROWN COLOR(188,152,115)
#define COLOR_GRAY COLOR(153, 153, 153)
#define NAV_COLOR COLOR(22, 22, 22)
#define COLOR_BLACK42 COLOR(42, 42, 42)

#define coin_rate 150
#define app_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define kRealValue(with) ((with)*[UIScreen mainScreen].bounds.size.width/375.0f)

#define USERDEFAULT_CURRENT_POINT  @"USERDEFAULT_CURRENT_POINT"
#define USERDEFAULT_NODES_LIST     @"USERDEFAULT_NODES_LIST"
#define USERDEFAULT_IS_HIDE         @"USERDEFAULT_IS_HIDE"

#define User_Info_Key @"User_Info_Key"

#endif /* Macro_h */
