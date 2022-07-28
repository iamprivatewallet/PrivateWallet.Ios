//
//  PW_SearchRecordNFTCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_SearchRecordNFTCell : PW_BaseTableCell

@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, copy) void(^heightBlock)(CGFloat height);

@end

@interface PW_SearchRecordNFTFlowLayout : UICollectionViewFlowLayout

@end

NS_ASSUME_NONNULL_END
