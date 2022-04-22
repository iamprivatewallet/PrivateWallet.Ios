//
//  PW_TableView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TableView.h"

@implementation PW_TableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor g_bgColor];
        self.separatorColor = [UIColor g_lineColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

@end
