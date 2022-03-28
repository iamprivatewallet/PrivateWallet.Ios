//
//  BrowseWebViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/16.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BrowseWebViewController : BaseViewController

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *urlStr;

@end

NS_ASSUME_NONNULL_END
