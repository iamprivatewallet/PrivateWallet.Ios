//
//  PW_DappItemCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/23.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_DappModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappItemCell : UICollectionViewCell

@property (nonatomic, strong) PW_DappModel *model;

@end

NS_ASSUME_NONNULL_END