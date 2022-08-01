//
//  PW_SeriesNFTItemCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_SeriesNFTItemCell : UICollectionViewCell

@property (nonatomic, copy) void(^collectBlock)(BOOL isCollect);
@property (nonatomic, copy) void(^seriesBlock)(void);

@end

NS_ASSUME_NONNULL_END
