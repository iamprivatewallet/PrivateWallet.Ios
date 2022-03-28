//
//  ManageWalletCell.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/29.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManageWalletCell : UITableViewCell


- (void)setViewWithData:(id)data;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isChooseWallet:(BOOL)isChoose;
@end

NS_ASSUME_NONNULL_END
