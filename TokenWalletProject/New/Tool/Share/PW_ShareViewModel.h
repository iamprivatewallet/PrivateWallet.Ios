//
//  PW_ShareViewModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_ShareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_ShareViewModel : NSObject

@property(nonatomic, strong) PW_ShareModel *model;
+ (instancetype)viewModelWithModel:(PW_ShareModel *)model;

@end

NS_ASSUME_NONNULL_END
