//
//  TransferDetailInfoCell.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/30.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferDetailInfoCell : UITableViewCell
- (void)setViewWithTitle:(NSString *)title content:(NSString *)content;

- (void)setArrowImgWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
