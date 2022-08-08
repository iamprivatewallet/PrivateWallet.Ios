//
//  Urls.h
//  JianDan
//
//  Created by 刘献亭 on 15/8/29.
//  Copyright © 2015年 刘献亭. All rights reserved.
//

#ifndef Urls_h
#define Urls_h

#define AppWalletTokenIconURL(chain,address) [NSString stringWithFormat:@"https://privatewallet.s3.ap-southeast-1.amazonaws.com/icon/%@/%@.png",[chain lowercaseString],[address uppercaseString]]
#define AppWalletChainBgURL(chain) [NSString stringWithFormat:@"https://privatewallet.s3.ap-southeast-1.amazonaws.com/pic/chain/%@.png",[chain lowercaseString]]

#define CVNHashDetailUrl(hashStr) [NSString stringWithFormat:@"https://scan.cvn.io/#/transactiondetail/%@",hashStr]

static NSString * const AppTestflightUrl = @"https://testflight.apple.com/join/K7QgQNj3";
static NSString * const AppDownloadUrl = @"https://privatewallet.tech/download";

static NSString * const WalletWebSiteUrl = @"https://chain.kimchiii.com";
static NSString * const WalletUseDirectionsUrl = @"https://privatewallet.gitbook.io/home/v/cn/instructions";
static NSString * const WalletFeedbackUrl = @"https://privatewallet.gitbook.io/home/v/cn/advice";
static NSString * const WalletUserAgreementUrl = @"https://privatewallet.gitbook.io/home/v/cn/agreement";
static NSString * const WalletReportUrl = @"https://www.privatewallet.tech/#/report";

//网络请求url
static NSString * const APPWalletBaseURL = @"https://chain.kimchiii.com";

//币种交易详情
static NSString * const WalletTokenDetailURL = @"wallet/getTransactionInfo";
//币种icon
static NSString * const WalletTokenIconURL = @"api/wallet/token/icon";
//币种详情
static NSString * const WalletTokenItemURL = @"api/wallet/token/item";
//币种汇率
static NSString * const WalletTokenPriceURL = @"api/wallet/token/price";
//币种行情
static NSString * const WalletTickerMainURL = @"api/wallet/ticker/main";
static NSString * const WalletMarketTickerWS = @"wss://chain.kimchiii.com/ws/api/wallet/ticker";
//网络管理
static NSString * const WalletTokenChainURL = @"api/wallet/token/chain";
//Dapp
static NSString * const WalletHomeMain = @"api/wallet/home/main";
//DAPP推荐
static NSString * const WalletDappListURL = @"api/wallet/dapp/list";
//APP更新
static NSString * const WalletVersionLastURL = @"api/wallet/version/last";
//转账通知分页列表
static NSString * const WalletMessageHashPageURL = @"api/wallet/message/hash/page";
//系统消息分页列表
static NSString * const WalletMessageSysPageURL = @"api/wallet/message/sys/page";
//系统消息详情
static NSString * const WalletMessageSysItemURL = @"api/wallet/message/sys/item";
//Banner
static NSString * const WalletBannerListURL = @"api/wallet/banner/list";

//NFT
static NSString * const APPNFTBaseURL = @"https://nft.privatex.ai";

//NFT资产
static NSString * const NFTWalletMainURL = @"api/nft/wallet/main";
//持有NFT
static NSString * const NFTAssetOwnerPageURL = @"api/nft/asset/owner/page";
//NFT详情
static NSString * const NFTAssetItemURL = @"api/nft/asset/item";
//NFT市场
static NSString * const NFTSearchMarketURL = @"api/nft/search/market";
//NFT搜索
static NSString * const NFTSearchMainURL = @"api/nft/search/main";
//NFT分页列表
static NSString * const NFTAssetPageURL = @"api/nft/asset/page";
//NFT合集分页列表
static NSString * const NFTCollectionPageURL = @"api/nft/collection/page";
//NFT合集详情
static NSString * const NFTCollectionItemURL = @"api/nft/collection/item";
//NFT关注/取消关注
static NSString * const NFTAssetFollowURL = @"api/nft/asset/follow";
//个人资料
static NSString * const NFTWalletInfoURL = @"api/nft/wallet/info";
//设置个人资料
static NSString * const NFTWalletInfoEditURL = @"api/nft/wallet/info/edit";
//NFT栏目列表
static NSString * const NFTSearchCategoryURL = @"api/nft/search/category";

#endif /* Urls_h */
