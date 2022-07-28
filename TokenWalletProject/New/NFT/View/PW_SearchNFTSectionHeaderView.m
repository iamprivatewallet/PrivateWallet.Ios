//
//  PW_SearchNFTSectionHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchNFTSectionHeaderView.h"

@interface PW_SearchNFTSectionHeaderView ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation PW_SearchNFTSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)deleteAction {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLb.text = title;
}
- (void)setShowDelete:(BOOL)showDelete {
    _showDelete = showDelete;
    self.deleteBtn.hidden = !showDelete;
}
- (void)makeViews {
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.deleteBtn];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.centerY.offset(0);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-32);
        make.centerY.offset(0);
    }];
}
#pragma mark - lazy
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:15 textColor:[UIColor g_grayTextColor]];
    }
    return _titleLb;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [PW_ViewTool buttonImageName:@"icon_delete_gray" target:self action:@selector(deleteAction)];
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}

@end
