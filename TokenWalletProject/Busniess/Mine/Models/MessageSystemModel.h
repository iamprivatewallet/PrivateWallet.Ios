//
//  MessageSystemModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/16.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageSystemModel : NSObject

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *context;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;

@end

NS_ASSUME_NONNULL_END
