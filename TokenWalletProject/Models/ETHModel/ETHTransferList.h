//
//  ETHTransferList.h
//  FunnyProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "JSONModel.h"
#import "ETHTransfer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ETHTransfer;

@interface ETHTransferList : JSONModel

@property (strong, nonatomic) NSArray<ETHTransfer> *tx_array;
@property (strong, nonatomic) NSString<Optional> *err_code;
@property (strong, nonatomic) NSString<Optional> *msg;

@end

NS_ASSUME_NONNULL_END
