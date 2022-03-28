//
//  ScanCodeInfoModel.h
//  TokenWalletProject
//
//  Created by fchain on 2021/9/8.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanCodeInfoModel : NSObject
@property (nonatomic, copy) NSString *contractAddr;
@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *amount;

@end

NS_ASSUME_NONNULL_END
