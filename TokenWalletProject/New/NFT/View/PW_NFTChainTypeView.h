//
//  PW_NFTChainTypeView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTChainTypeView : UIView

@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, copy) void(^clickBlock)(void);
- (void)showInView:(UIView *)view;
- (void)dismiss;

@end

@interface PW_NFTChainTypeCell : PW_BaseTableCell

@end

NS_ASSUME_NONNULL_END
