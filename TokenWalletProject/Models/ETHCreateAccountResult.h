//
//  ETHCreateAccountResult.h
//  FunnyProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETHCreateAccountResult : JSONModel

@property (strong, nonatomic) NSString<Optional> *address;
@property (strong, nonatomic) NSString<Optional> *err_code;
@property (strong, nonatomic) NSString<Optional> *msg;

@end

NS_ASSUME_NONNULL_END
