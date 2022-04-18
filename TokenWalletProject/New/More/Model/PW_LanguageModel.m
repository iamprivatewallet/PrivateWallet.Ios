//
//  PW_LanguageModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_LanguageModel.h"

@implementation PW_LanguageModel

- (NSString *)iconName {
    return NSStringWithFormat(@"icon_lang_%@",self.languageCode);
}

@end
