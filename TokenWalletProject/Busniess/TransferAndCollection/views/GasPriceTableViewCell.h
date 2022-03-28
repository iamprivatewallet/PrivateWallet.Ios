//
//  GasPriceTableViewCell.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/16.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GasPriceTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *checkImg;

- (void)setViewWithData:(id)data;
@end

NS_ASSUME_NONNULL_END
