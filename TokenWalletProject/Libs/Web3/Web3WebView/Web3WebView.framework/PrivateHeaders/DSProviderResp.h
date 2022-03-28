//
// Created by 汪文豪 on 2020/10/11.
//

#import <Foundation/Foundation.h>
#import "MetaMaskEvent.h"

@class MetaMaskRespModel;

NS_ASSUME_NONNULL_BEGIN

@interface DSProviderResp : MetaMaskEvent
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) MetaMaskRespModel *data;

@end
NS_ASSUME_NONNULL_END
