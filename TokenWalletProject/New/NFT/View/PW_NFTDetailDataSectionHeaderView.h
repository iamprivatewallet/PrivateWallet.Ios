//
//  PW_NFTDetailDataSectionHeaderView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/4.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_NFTDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTDetailDataSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) PW_NFTDetailModel *model;
@property (nonatomic, copy) void(^segmentIndexBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
