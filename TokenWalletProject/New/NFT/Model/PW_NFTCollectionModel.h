//
//  PW_NFTCollectionModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTCollectionModel : PW_BaseModel

@property (nonatomic, copy) NSString *cId;
@property (nonatomic, assign) NSInteger limitStart;
@property (nonatomic, assign) NSInteger limitEnd;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *errors;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, copy) NSString *slug;
@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, assign) NSInteger totalSales;
@property (nonatomic, assign) NSInteger totalSupply;
@property (nonatomic, assign) NSInteger numOwners;
@property (nonatomic, assign) NSInteger numReports;
@property (nonatomic, copy) NSString *totalVolume;
@property (nonatomic, copy) NSString *averagePrice;
@property (nonatomic, copy) NSString *floorPrice;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *payoutAddress;
@property (nonatomic, copy) NSString *bannerImageUrl;
@property (nonatomic, copy) NSString *externalUrl;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *largeImageUrl;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *categorySlug;

//"limitStart": 0,
//"limitEnd": 10,
//"pageNumber": 0,
//"pageSize": 10,
//"errors": null,
//"status": 1,
//"slug": "boredapeyachtclub",
//"chainId": 1,
//"totalSales": 26890,
//"totalSupply": 10000,
//"numOwners": 6447,
//"numReports": 1,
//"totalVolume": 645657.84285781,
//"averagePrice": 24.01107634,
//"floorPrice": 0E-8,
//"name": "Bored Ape Yacht Club",
//"payoutAddress": "0xa858ddc0445d8131dac4d1de01f834ffcba52ef1",
//"bannerImageUrl": "https://lh3.googleusercontent.com/i5dYZRkVCUK97bfprQ3WXyrT9BnLSZtVKGJlKQ919uaUB0sxbngVCioaiyu9r6snqfi2aaTyIvv6DHm4m2R3y7hMajbsv14pSZK8mhs=s2500",
//"externalUrl": "http://www.boredapeyachtclub.com/",
//"imageUrl": "https://lh3.googleusercontent.com/Ju9CkWtV-1Okvf45wo8UctR-M9He2PjILP0oOvxE89AyiPPGtrR3gysu1Zgy0hjd2xKIgjJJtWIc0ybj4Vd7wv8t3pxDGHoJBzDB=s120",
//"largeImageUrl": "https://lh3.googleusercontent.com/RBX3jwgykdaQO3rjTcKNf5OVwdukKO46oOAV3zZeiaMb8VER6cKxPDTdGZQdfWcDou75A8KtVZWM_fEnHG4d4q6Um8MeZIlw79BpWPA=s300",
//"createTime": "2021-04-22T15:30:10.000+00:00",
//"updateTime": "2022-08-06T08:56:46.000+00:00",
//"description": "The Bored Ape Yacht Club is a collection of 10,000 unique Bored Ape NFTs— unique digital collectibles living on the Ethereum blockchain. Your Bored Ape doubles as your Yacht Club membership card, and grants access to members-only benefits, the first of which is access to THE BATHROOM, a collaborative graffiti board. Future areas and perks can be unlocked by the community through roadmap activation. Visit www.BoredApeYachtClub.com for more details.",
//"categorySlug": null

@end

NS_ASSUME_NONNULL_END
