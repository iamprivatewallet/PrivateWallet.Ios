//
//  VersionModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/18.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionModel : NSObject

@property (nonatomic, copy) NSString *vId;
@property (nonatomic, assign) BOOL isForce;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *languageCode;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
