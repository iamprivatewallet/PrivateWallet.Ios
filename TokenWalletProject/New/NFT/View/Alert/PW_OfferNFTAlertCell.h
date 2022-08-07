//
//  PW_OfferNFTAlertCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_OfferNFTAlertCell : PW_BaseTableCell

@property (nonatomic, copy) void(^sellBlock)(void);

@end

NS_ASSUME_NONNULL_END
