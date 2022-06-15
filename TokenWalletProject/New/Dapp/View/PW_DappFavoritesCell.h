//
//  PW_DappFavoritesCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/15.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappFavoritesCell : PW_BaseTableCell

@property (nonatomic, strong) PW_DappModel *model;
@property (nonatomic, copy) void(^favoriteBlock)(PW_DappModel *model);

@end

NS_ASSUME_NONNULL_END
