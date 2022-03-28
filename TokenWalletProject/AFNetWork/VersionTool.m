//
//  VersionTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/22.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "VersionTool.h"
#import "UpgradePopUpView.h"

@implementation VersionTool

+ (void)requestAppVersion {
    [self requestAppVersionUserTake:NO completeBlock:nil];
}
+ (void)requestAppVersionUserTake:(BOOL)userTake completeBlock:(void(^ _Nullable)(BOOL))completeBlock {
    [NetworkTool requestWallet:WalletVersionLastURL params:@{@"type":@"iOS",@"languageCode":@"zh_CN"} completeBlock:^(id _Nonnull data) {
        VersionModel *model = [VersionModel mj_objectWithKeyValues:data];
        UpgradePopUpView *view = [UpgradePopUpView showUpgradePopUpViewWithModel:model userTake:userTake];
        if(completeBlock){
            completeBlock(view!=nil);
        }
    } errBlock:nil];
}

@end
