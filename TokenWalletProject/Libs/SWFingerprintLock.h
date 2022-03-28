//
//  SWFingerprintLock.h
//  TestSwiftProject
//
//  Created by Fchain on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//支持的登录方式
typedef NS_ENUM(NSInteger ,UnlockSupportType) {
    JUnlockType_None = 0,//既不支持指纹，也不支持脸部识别
    JUnlockType_TouchID,//指纹解锁
    JUnlockType_FaceID//脸部识别
};


//登录回调类型
typedef NS_ENUM(NSInteger ,UnlockResult) {
    JUnlockFailed = 0,//失败
    JUnlockSuccess//成功
};

typedef void(^UnlockResultBlock)(UnlockResult result , NSString* errMsg);

@interface SWFingerprintLock : NSObject
@property (nonatomic , assign) UnlockSupportType supportType;//支持的登录方式

+ (SWFingerprintLock*)shareInstance;//单例


+ (UnlockSupportType)checkUnlockSupportType;//检测支持的登录方式

+ (void)unlockWithResultBlock:(UnlockResultBlock)block;//登录回调结果(在调用此方法前，需要调用上面的方式获取登录的支持方式)

@end

NS_ASSUME_NONNULL_END
