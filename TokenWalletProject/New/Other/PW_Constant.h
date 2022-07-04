//
//  PW_Constant.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/3.
//  Copyright © 2022 . All rights reserved.
//

static NSString * _Nonnull const kHiddenWalletAmount = @"isHiddenWalletAmount";
static NSString * _Nonnull const kHiddenWalletSmallAmount = @"hiddenWalletSmallAmount";
static float const g_smallAmount = 0.01;

static NSString * _Nonnull const AuthorizationPrefix = @"0x095ea7b3";
static NSString * _Nonnull const MaxAuthorizationCount = @"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";

static NSString * _Nonnull const kDefaultUserName = @"identity_name";

static NSString * _Nonnull const kWalletTypeETH = @"ETH";
static NSString * _Nonnull const kWalletTypeCVN = @"CVN";
static NSString * _Nonnull const kWalletTypeSolana = @"Solana";

static NSString * _Nonnull const kETHChainId = @"1";
static NSString * _Nonnull const kBSCChainId = @"56";
static NSString * _Nonnull const kHECOChainId = @"128";
static NSString * _Nonnull const kCVNChainId = @"168";

static NSString * _Nonnull const kETHRPCUrl = @"https://mainnet.infura.io/v3/02979c20665f4db5a07f7f0e4fc14fb7";
static NSString * _Nonnull const kBSCRPCUrl = @"https://bsc-dataseed2.ninicoin.io";
static NSString * _Nonnull const kHECORPCUrl = @"https://http-mainnet.hecochain.com";
static NSString * _Nonnull const kCVNRPCUrl = @"http://52.220.97.222:1235";
