//
//  AllDAppsViewController.h
//  TokenWalletProject
//
//  Created by FChain on 2021/9/29.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,kAllDAppsType){
    kAllDAppsTypeCollection,
    kAllDAppsTypeLately
};
@interface AllDAppsViewController : BaseViewController
@property(nonatomic, assign) kAllDAppsType allType;
@end

NS_ASSUME_NONNULL_END
