//
//  PW_NFTTokenDetailCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/3.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTTokenDetailCell.h"

@interface PW_NFTTokenDetailCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *tokenIdLb;
@property (nonatomic, strong) UIButton *copyBtn;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation PW_NFTTokenDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)copyAction {
    
}
- (void)makeViews {
    [self.contentView addSubview:self.iconIv];
    [self.contentView addSubview:self.tokenIdLb];
    [self.contentView addSubview:self.copyBtn];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.lineView];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.left.offset(26);
        make.centerY.offset(0);
    }];
    [self.tokenIdLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(14);
        make.top.equalTo(self.iconIv);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tokenIdLb.mas_right).offset(4);
        make.centerY.equalTo(self.tokenIdLb);
    }];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(14);
        make.bottom.equalTo(self.iconIv);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(26);
        make.right.offset(-26);
        make.bottom.offset(0);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark - lazy
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
    }
    return _iconIv;
}
- (UILabel *)tokenIdLb {
    if (!_tokenIdLb) {
        _tokenIdLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _tokenIdLb;
}
- (UIButton *)copyBtn {
    if (!_copyBtn) {
        _copyBtn = [PW_ViewTool buttonImageName:@"icon_copy_new_small" target:self action:@selector(copyAction)];
    }
    return _copyBtn;
}
- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [PW_ViewTool labelText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    }
    return _timeLb;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor g_lineColor];
    }
    return _lineView;
}

@end
