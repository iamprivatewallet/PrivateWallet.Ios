//
//  VisitDAppsRecordManager.h
//  TokenWalletProject
//
//  Created by FChain on 2021/10/15.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VisitDAppsRecordManager : NSObject
+(instancetype)sharedInstance;

-(NSArray *)getDAppsVisitArray;
-(void)addDAppsRecord:(NSDictionary *)dic;
-(void)deleteDAppsRecord:(NSString *)url;
- (NSDictionary *)getDAppsWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
