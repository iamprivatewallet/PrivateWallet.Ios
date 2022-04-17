//
//  PW_GasModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_GasModel.h"

@implementation PW_GasToolModel

- (void)setGas_price:(NSString *)gas_price {
    _gas_price = gas_price;
    self.slowModel.gas_price = [gas_price stringDownMultiplyingBy:@"0.5"];
    self.recommendModel.gas_price = gas_price;
    self.fastModel.gas_price = [gas_price stringDownMultiplyingBy:@"1.5"];
    self.soonModel.gas_price = [gas_price stringDownMultiplyingBy:@"2"];
}
- (void)setGas:(NSString *)gas {
    _gas = gas;
    self.slowModel.gas = gas;
    self.recommendModel.gas = gas;
    self.fastModel.gas = gas;
    self.soonModel.gas = gas;
}
- (void)setPrice:(NSString *)price {
    _price = price;
    self.slowModel.price = price;
    self.recommendModel.price = price;
    self.fastModel.price = price;
    self.soonModel.price = price;
}

- (PW_GasModel *)slowModel {
    if (!_slowModel) {
        _slowModel = [[PW_GasModel alloc] init];
    }
    return _slowModel;
}
- (PW_GasModel *)recommendModel {
    if (!_recommendModel) {
        _recommendModel = [[PW_GasModel alloc] init];
    }
    return _recommendModel;
}
- (PW_GasModel *)fastModel {
    if (!_fastModel) {
        _fastModel = [[PW_GasModel alloc] init];
    }
    return _fastModel;
}
- (PW_GasModel *)soonModel {
    if (!_soonModel) {
        _soonModel = [[PW_GasModel alloc] init];
    }
    return _soonModel;
}

@end

@implementation PW_GasModel

- (void)setGas_price:(NSString *)gas_price {
    _gas_price = gas_price;
    _gas_gwei = [[gas_price stringDownDividingBy10Power:9] stringDownDecimal:9];
}
- (NSString *)gas_amount {
    return [[[self.gas_gwei stringDownMultiplyingBy:self.gas] stringDownDividingBy10Power:9] stringDownDecimal:9];
}
- (NSString *)gas_ut_amout {
    return [self.gas_amount stringDownMultiplyingBy:self.price decimal:9];
}

@end
