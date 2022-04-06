//
//  PW_TokenDetailCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/6.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TokenDetailCell.h"

@interface PW_TokenDetailCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *hashLb;
@property (nonatomic, strong) UIButton *copyBtn;
@property (nonatomic, strong) UILabel *amountLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *tokenNameLb;

@end

@implementation PW_TokenDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_TokenDetailModel *)model {
    _model = model;
    self.iconIv.image = [UIImage imageNamed:model.isOut?@"icon_roll_out":@"icon_roll_in"];
    self.hashLb.text = [model.hashStr showShortAddress];
    self.amountLb.text = NSStringWithFormat(@"%@%@",model.isOut?@"-":@"+",model.value);
    self.timeLb.text = [NSString timeStrTimeInterval:model.timeStamp];
    self.tokenNameLb.text = model.tokenName;
}
- (void)copyAction {
    [self.model.hashStr pasteboardToast:YES];
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.hashLb];
    [self.bodyView addSubview:self.copyBtn];
    [self.bodyView addSubview:self.amountLb];
    [self.bodyView addSubview:self.timeLb];
    [self.bodyView addSubview:self.tokenNameLb];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-8);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(12);
        make.width.height.offset(35);
    }];
    [self.hashLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(10);
        make.top.equalTo(self.iconIv);
    }];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hashLb.mas_right).offset(6);
        make.centerY.equalTo(self.hashLb);
        make.right.lessThanOrEqualTo(self.amountLb.mas_left).offset(-10);
    }];
    [self.amountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(12);
    }];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(10);
        make.bottom.equalTo(self.iconIv.mas_bottom).offset(-2);
    }];
    [self.tokenNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-18);
        make.bottom.offset(-13);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - lazy
- (UIView *)bodyView {
    if(!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.backgroundColor = [UIColor g_bgColor];
        [_bodyView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
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
- (UILabel *)hashLb {
    if (!_hashLb) {
        _hashLb = [PW_ViewTool labelMediumText:@"" fontSize:12 textColor:[UIColor g_boldTextColor]];
        [_hashLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _hashLb;
}
- (UIButton *)copyBtn {
    if (!_copyBtn) {
        _copyBtn = [PW_ViewTool buttonImageName:@"icon_copy" target:self action:@selector(copyAction)];
        [_copyBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _copyBtn;
}
- (UILabel *)amountLb {
    if (!_amountLb) {
        _amountLb = [PW_ViewTool labelMediumText:@"" fontSize:18 textColor:[UIColor g_boldTextColor]];
    }
    return _amountLb;
}
- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [PW_ViewTool labelText:@"" fontSize:12 textColor:[UIColor g_grayTextColor]];
    }
    return _timeLb;
}
- (UILabel *)tokenNameLb {
    if (!_tokenNameLb) {
        _tokenNameLb = [PW_ViewTool labelMediumText:@"" fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _tokenNameLb;
}

@end
