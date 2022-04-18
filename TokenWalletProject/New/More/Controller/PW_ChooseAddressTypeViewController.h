//
//  PW_ChooseAddressTypeViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_ChooseAddressTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_ChooseAddressTypeViewController : PW_BaseViewController

@property (nonatomic, copy) NSString *selectedChainId;
@property (nonatomic, copy) void(^chooseBlock)(PW_ChooseAddressTypeModel *model);

@end

NS_ASSUME_NONNULL_END
