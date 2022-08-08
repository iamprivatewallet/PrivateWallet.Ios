//
//  PW_NFTHeaderView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_NFTBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTHeaderView : UICollectionReusableView

@property (nonatomic, copy) NSArray<PW_NFTBannerModel *> *dataArr;
@property (nonatomic, copy) void(^clickBlock)(PW_NFTBannerModel *model);

@end

NS_ASSUME_NONNULL_END
