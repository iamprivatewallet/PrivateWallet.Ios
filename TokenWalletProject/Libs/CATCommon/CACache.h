//
//  CACache.h
//  TokenWalletProject
//
//  Created by wang qiang on 2019/1/14.
//  Copyright © 2019 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NSString_Hashing)

- (NSString *)MD5Hash;

@end
@interface CACache : NSObject

@property (nonatomic,assign) NSTimeInterval validTime;//有效的时间

+ (instancetype)defaultManager;
- (void)saveData:(NSDictionary *)data urlString:(NSString *)urlString;

- (id)getDataWithUrlString:(NSString *)urlString;

- (id)getCacheDataWithParams:(NSDictionary*)params url:(NSString*)url;

@end

NS_ASSUME_NONNULL_END
