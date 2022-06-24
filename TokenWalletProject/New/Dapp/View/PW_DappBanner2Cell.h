//
//  PW_DappBanner2Cell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_BannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappBanner2Cell : PW_BaseTableCell

@property (nonatomic, copy) NSArray<PW_BannerModel *> *dataArr;
@property (nonatomic, copy) void(^clickBlock)(PW_BannerModel *model);
+ (CGSize)getItemSize;

@end

NS_ASSUME_NONNULL_END
