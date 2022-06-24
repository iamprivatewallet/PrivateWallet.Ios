//
//  PW_DappChainBrowserCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_DappChainBrowserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappChainBrowserCell : PW_BaseTableCell

@property (nonatomic, copy) NSArray<PW_DappChainBrowserModel *> *dataArr;
@property (nonatomic, copy) void(^clickBlock)(PW_DappChainBrowserModel *model);
+ (CGSize)getItemSize;
+ (CGFloat)getHeightWithItemCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
