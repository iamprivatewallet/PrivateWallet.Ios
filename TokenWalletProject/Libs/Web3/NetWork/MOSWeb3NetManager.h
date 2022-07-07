//
//  MOSWeb3NetManager.h
//  MOS_Client_IOS
//
//  Created by mnz on 2020/11/26.
//  Copyright © 2020 WangQJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Web3WebView/MetaMaskRepModel.h>
#import "MOSETHGasModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOSWeb3NetManager : NSObject

+ (void)requestWithModel:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(NSString * _Nullable rawResponse, id _Nullable result, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
