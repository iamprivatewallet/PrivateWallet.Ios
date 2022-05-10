//
//  PW_Header.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#ifndef PW_Header_h
#define PW_Header_h

#define PW_APPName    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define PW_APPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define PW_APPBuild   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define PW_APPIconPath   [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject]
#define PW_APPIcon    [UIImage imageNamed:APPIconPath]
#define PW_APPBundleIdentifier [[NSBundle mainBundle] bundleIdentifier]
#define PW_APPBundleName   [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]

#define PW_IPhoneX ([[UIApplication sharedApplication] statusBarFrame].size.height>20)
#define PW_NavStatusHeight  (44+[[UIApplication sharedApplication] statusBarFrame].size.height)
#define PW_StatusHeight  [[UIApplication sharedApplication] statusBarFrame].size.height
#define PW_SafeBottomInset [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom

#define PW_StrFormat(...) [NSString stringWithFormat:__VA_ARGS__]

#endif /* PW_Header_h */
