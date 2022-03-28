//
//  DAppsManager.h
//  TokenWalletProject
//
//  Created by FChain on 2021/10/13.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DAppsManager : NSObject

+(instancetype)sharedInstance;

-(NSArray *)getDAppsCollectionArray;

-(void)addDAppsCollection:(NSDictionary *)dic;
-(void)deleteDApps:(NSString *)url;
- (NSDictionary *)getDAppsWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
