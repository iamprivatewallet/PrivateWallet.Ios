//
//  PW_ChooseCurrencyCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/15.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ChooseCurrencyCell.h"

@interface PW_ChooseCurrencyCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *addressLb;
@property (nonatomic, strong) UIButton *copyBtn;
@property (nonatomic, strong) UIButton *chooseBtn;

@end

@implementation PW_ChooseCurrencyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self makeViews];
    }
    return self;
}
- (void)copyAction {
    [self.model.tokenContract pasteboardToast:YES];
}
- (void)setModel:(PW_TokenModel *)model {
    _model = model;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.tokenLogo] placeholderImage:[UIImage imageNamed:@"icon_token_default"]];
    self.nameLb.text = model.tokenName;
    self.addressLb.text = [model.tokenContract showShortAddress];
    self.chooseBtn.selected = model.isChoose;
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.addressLb];
    [self.bodyView addSubview:self.copyBtn];
    [self.bodyView addSubview:self.chooseBtn];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-5);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(12);
        make.width.height.offset(40);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(15);
        make.top.equalTo(self.iconIv);
    }];
    [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(15);
        make.bottom.equalTo(self.iconIv);
    }];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLb.mas_right).offset(8);
        make.centerY.equalTo(self.addressLb);
        make.right.lessThanOrEqualTo(self.chooseBtn.mas_left).offset(-10);
    }];
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if(!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.backgroundColor = [UIColor g_bgColor];
        [_bodyView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    }
    return _bodyView;
}
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
    }
    return _iconIv;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    }
    return _nameLb;
}
- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [PW_ViewTool labelMediumText:@"" fontSize:12 textColor:[UIColor g_grayTextColor]];
        _addressLb.numberOfLines = 1;
    }
    return _addressLb;
}
- (UIButton *)copyBtn {
    if (!_copyBtn) {
        _copyBtn = [PW_ViewTool buttonImageName:@"icon_copy" target:self action:@selector(copyAction)];
        [_copyBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _copyBtn;
}
- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [PW_ViewTool buttonImageName:@"icon_uncheck" selectedImage:@"icon_check" target:nil action:nil];
        _chooseBtn.userInteractionEnabled = NO;
        [_chooseBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _chooseBtn;
}

@end
