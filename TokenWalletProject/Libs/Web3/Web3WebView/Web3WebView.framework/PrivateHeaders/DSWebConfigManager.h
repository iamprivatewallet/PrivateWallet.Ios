//
//  DSWebConfigManager.h
//  DSWebViewDemo
//
//  Created by 张强 on 2020/10/10.
//

#import <Foundation/Foundation.h>
@class MetaMaskPushConfigModel;
@class DSControlManager;
NS_ASSUME_NONNULL_BEGIN

@interface DSWebConfigManager : NSObject

@property (nonatomic, strong) NSMutableArray <DSControlManager *>*controlArr;
@property (nonatomic, strong) MetaMaskPushConfigModel *pushConfig;
+ (instancetype)sharedSingleton;
- (void)changeState;
- (void)addOnChangeListener:(DSControlManager *)control;
- (void)removeOnchangeListener:(DSControlManager *)control;
@end

NS_ASSUME_NONNULL_END
