//
//  PW_DBGlobalTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/4.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DBGlobalTool.h"

@implementation PW_DBGlobalTool

+ (void)clear {
    [[PW_WalletManager shared] deleteAll];
    [[PW_TokenTradeRecordManager shared] deleteAll];
    [[PW_TokenManager shared] deleteAll];
    [[PW_NetworkManager shared] deleteAll];
    [[PW_NodeManager shared] deleteAll];
    [[PW_AddressBookManager shared] deleteAll];
    [[PW_DappManager shared] deleteAll];
    [[PW_DappSearchManager shared] deleteAll];
    [[PW_DappFavoritesManager shared] deleteAll];
    [[PW_MarketManager shared] deleteAll];
    [[PW_NFTSearchManager shared] deleteAll];
}

@end
