//
//  ChooseCoinTypeModel.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/26.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseCoinTypeModel : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *describe;

@property (nonatomic, copy) NSString *detailTitle;

@end

NS_ASSUME_NONNULL_END
