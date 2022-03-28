//
//  AssetEditCell.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/30.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetEditCell : UITableViewCell
- (void)setViewWithData:(id)data;

- (void)hiddenEditView;
@end

NS_ASSUME_NONNULL_END
