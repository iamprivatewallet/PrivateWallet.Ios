//
//  MessageTransferCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/16.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_TokenDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageTransferCell : UITableViewCell

@property (nonatomic, strong) PW_TokenDetailModel *model;

@end

NS_ASSUME_NONNULL_END
