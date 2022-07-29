//
//  PW_AllNftFiltrateItemCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_AllNftFiltrateGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_AllNftFiltrateItemCell : UICollectionViewCell

@property (nonatomic, strong) PW_AllNftFiltrateItemModel *model;
@property (nonatomic, assign) CGFloat itemWidth;

@end

NS_ASSUME_NONNULL_END
