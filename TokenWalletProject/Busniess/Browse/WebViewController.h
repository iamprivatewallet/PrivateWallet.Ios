//
//  WebViewController.h
//  TokenWalletProject
//
//  Created by fchain on 2021/9/13.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : BaseViewController

+(instancetype)loadWebViewWithData:(BrowseRecordsModel *)data;
@end

NS_ASSUME_NONNULL_END
