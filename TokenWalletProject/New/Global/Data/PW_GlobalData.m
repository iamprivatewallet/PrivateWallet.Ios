//
//  PW_GlobalData.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/15.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_GlobalData.h"

@implementation PW_GlobalData

+ (instancetype)shared {
    static PW_GlobalData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)updateCoinList:(NSArray<PW_TokenModel *> *)coinList {
    [self.coinList removeAllObjects];
    [self.coinList addObjectsFromArray:coinList];
}
- (NSMutableArray<PW_TokenModel *> *)coinList {
    if (!_coinList) {
        _coinList = [[NSMutableArray alloc] init];
    }
    return _coinList;
}

@end
