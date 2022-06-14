//
//  PW_WalletManageHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/14.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletManageHeaderView.h"

@interface PW_WalletManageHeaderView ()

@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_WalletManageHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(38);
            make.centerY.offset(0);
        }];
        UIButton *addBtn = [PW_ViewTool buttonImageName:@"icon_add_black" target:self action:@selector(addAction)];
        [self.contentView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-42);
            make.centerY.offset(0);
        }];
    }
    return self;
}
- (void)addAction {
    if (self.addBlock) {
        self.addBlock();
    }
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelMediumText:@"List of Wallets" fontSize:20 textColor:[UIColor g_textColor]];
    }
    return _titleLb;
}

@end
