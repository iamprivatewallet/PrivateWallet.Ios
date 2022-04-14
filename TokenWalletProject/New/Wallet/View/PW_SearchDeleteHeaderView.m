//
//  PW_SearchDeleteHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchDeleteHeaderView.h"

@interface PW_SearchDeleteHeaderView ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation PW_SearchDeleteHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setHideDelete:(BOOL)hideDelete {
    _hideDelete = hideDelete;
    self.deleteBtn.hidden = hideDelete;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLb.text = title;
}
- (void)deleteAction {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}
- (void)makeViews {
    self.titleLb = [PW_ViewTool labelText:@"--" fontSize:15 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(26);
        make.centerY.offset(0);
    }];
    self.deleteBtn = [PW_ViewTool buttonImageName:@"icon_delete" target:self action:@selector(deleteAction)];
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-26);
        make.centerY.offset(0);
    }];
}

@end
