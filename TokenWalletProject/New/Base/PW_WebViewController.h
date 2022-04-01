//
//  PW_WebViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_WebViewController : PW_BaseViewController

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *urlStr;

@end

NS_ASSUME_NONNULL_END
