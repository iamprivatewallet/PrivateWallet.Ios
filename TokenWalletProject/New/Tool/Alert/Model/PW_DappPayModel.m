//
//  PW_DappPayModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/27.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappPayModel.h"

@implementation PW_DappPayModel

- (PW_GasToolModel *)gasToolModel {
    if (!_gasToolModel) {
        _gasToolModel = [[PW_GasToolModel alloc] init];
        _gasModel = _gasToolModel.recommendModel;
    }
    return _gasToolModel;
}

@end
