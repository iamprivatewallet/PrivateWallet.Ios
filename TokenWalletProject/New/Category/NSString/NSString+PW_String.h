//
//  NSString+PW_String.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (PW_String)

- (void)pasteboard;

- (BOOL)judgePassWordLegal;

- (NSString *)showShortAddress;
- (NSString *)showAddressHead:(NSInteger)head tail:(NSInteger)tail;

@end

NS_ASSUME_NONNULL_END
