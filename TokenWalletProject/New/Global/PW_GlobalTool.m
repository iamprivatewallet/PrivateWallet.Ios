//
//  PW_GlobalTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/22.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_GlobalTool.h"

@implementation PW_GlobalTool

+ (void)clear {
    [PW_LockTool clear];
    [PW_DenominatedCurrencyTool clear];
    [PW_RedRoseGreenFellTool clear];
}

@end
