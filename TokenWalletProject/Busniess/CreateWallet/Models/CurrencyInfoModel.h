//
//  CurrencyInfoModel.h
//  TokenWalletProject
//
//  Created by FChain on 2021/9/16.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyInfoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *isDefault;

@property(nonatomic, assign) BOOL isChecked;
@end

NS_ASSUME_NONNULL_END
