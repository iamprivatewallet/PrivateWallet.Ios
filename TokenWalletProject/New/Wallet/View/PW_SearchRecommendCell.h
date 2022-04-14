//
//  PW_SearchRecommendCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_DappModel.h"
#import "PW_TokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_SearchRecommendCell : PW_BaseTableCell

@property (nonatomic, copy) NSArray<PW_DappModel *> *dappArr;
@property (nonatomic, copy) NSArray<PW_TokenModel *> *tokenArr;
@property (nonatomic, copy) void(^dappBlock)(PW_DappModel *model);
@property (nonatomic, copy) void(^tokenBlock)(PW_TokenModel *model);

@end

@interface PW_SearchRecommendItemCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;

@end

NS_ASSUME_NONNULL_END
