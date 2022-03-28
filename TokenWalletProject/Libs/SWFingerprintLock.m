//
//  SWFingerprintLock.m
//  TestSwiftProject
//
//  Created by Fchain on 2021/9/15.
//

#import "SWFingerprintLock.h"
#import <LocalAuthentication/LocalAuthentication.h>

static SWFingerprintLock* g_fingerprintLock = nil ;
@interface SWFingerprintLock()
@property (nonatomic , strong) LAContext* context;


@end

@implementation SWFingerprintLock

+ (SWFingerprintLock*)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_fingerprintLock = [[SWFingerprintLock alloc] init];
    });
    return g_fingerprintLock;
}

+ (UnlockSupportType)checkUnlockSupportType{
    UnlockSupportType supportType = JUnlockType_None;
    // 检测设备是否支持TouchID或者FaceID
    if (@available(iOS 8.0, *)) {
        LAContext* LAContent = [[LAContext alloc] init];
        NSError *authError = nil;
        BOOL isCanEvaluatePolicy = [LAContent canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
        if (authError) {
            NSLog(@"检测设备是否支持TouchID或者FaceID失败！\n error : == %@",authError.localizedDescription);
//            [self showAlertView:[NSString stringWithFormat:@"检测设备是否支持TouchID或者FaceID失败。\n errorCode : %ld\n errorMsg : %@",(long)authError.code, authError.localizedDescription]];
        } else {
            if (isCanEvaluatePolicy) {
                // 判断设备支持TouchID还是FaceID
                if (@available(iOS 11.0, *)) {
                    switch (LAContent.biometryType) {
                        case LABiometryTypeNone:
                        {
                        }
                            break;
                        case LABiometryTypeTouchID:
                        {
                            supportType = JUnlockType_TouchID;
                        }
                            break;
                        case LABiometryTypeFaceID:
                        {
                            supportType = JUnlockType_FaceID;
                        }
                            break;
                        default:
                            break;
                    }
                } else {
                    // Fallback on earlier versions
                    NSLog(@"iOS 11之前不需要判断 biometryType");
                    // 因为iPhoneX起始系统版本都已经是iOS11.0，所以iOS11.0系统版本下不需要再去判断是否支持faceID，直接走支持TouchID逻辑即可。
                    supportType = JUnlockType_TouchID;
                }
                
            } else {
            }
        }
    } else {
        // Fallback on earlier versions
    }
    
    [self shareInstance].supportType = supportType;
    return supportType;
}



+ (void)unlockWithResultBlock:(UnlockResultBlock)block{
    
    if([self shareInstance].supportType == JUnlockType_None){
//        [self errorTipWithMessage:@"此设备未设置ToucID或FaceID" WithIsReturn:NO];
        block(JUnlockFailed, @"无ToucID或FaceID");
        return;
    }
    LAContext* jcontext = [self shareInstance].context;
    jcontext.localizedFallbackTitle = @"输入密码";

    LAPolicy policyType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    if (@available(iOS 9.0, *)) {
        policyType = LAPolicyDeviceOwnerAuthentication;
    }
    
    NSError* error = nil;
    if ([jcontext canEvaluatePolicy:policyType error:&error]) {
        
        NSString* str ;
        if([self shareInstance].supportType == JUnlockType_TouchID){
            str = @"通过Home键验证已有手机指纹";
        }else if([self shareInstance].supportType == JUnlockType_FaceID){
            str = @"请正对屏幕启动脸部识别";
        }
        [jcontext evaluatePolicy:policyType localizedReason:str reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"TouchID 验证成功");
                    if(block){
                        block(JUnlockSuccess,@"");
                        [self shareInstance].context = nil;
                    }
                });
            }else if(error){
                block(JUnlockFailed, error.localizedDescription);
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 验证失败");
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被用户手动取消");
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"用户不使用TouchID,选择手动输入密码");
                            
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                        });
                    }
                        break;
                    case LAErrorBiometryNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                        });
                    }
                        break;
                    case LAErrorBiometryNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无效");
                        });
                    }
                        break;
                    case LAErrorBiometryLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        }];

        
        
    }else{
        block(JUnlockFailed,@"TouchID失效");
    }
}
-(LAContext *)context{
    if (!_context) {
        _context = [[LAContext alloc]init];
    }
    return _context;
}
@end
