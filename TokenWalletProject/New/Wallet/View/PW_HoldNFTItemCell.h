//
//  PW_HoldNFTItemCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/2.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_NFTTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_HoldNFTItemCell : UICollectionViewCell

@property (nonatomic, strong) PW_NFTTokenModel *model;

@end

NS_ASSUME_NONNULL_END
