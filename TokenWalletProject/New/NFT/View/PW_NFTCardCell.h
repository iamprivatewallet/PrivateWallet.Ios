//
//  PW_NFTCardCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_NFTTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTCardCell : UICollectionViewCell

@property (nonatomic, strong) PW_NFTTokenModel *model;
@property (nonatomic, copy) void(^collectBlock)(PW_NFTTokenModel *model);
@property (nonatomic, copy) void(^seriesBlock)(PW_NFTTokenModel *model);

@end

NS_ASSUME_NONNULL_END
