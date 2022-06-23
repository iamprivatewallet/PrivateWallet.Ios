//
//  PW_VibrateTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/23.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_VibrateTool.h"

@implementation PW_VibrateTool

/// 短Peek震动
+ (void)peekVibrate {
    AudioServicesPlaySystemSound(1519);
}
/// 短Pop震动
+ (void)popVibrate {
    AudioServicesPlaySystemSound(1520);
}
+ (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
