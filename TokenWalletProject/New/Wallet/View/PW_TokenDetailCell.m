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
    self.iconIv.image = [UIImage imageNamed:model.isOut?@"icon_trade_out":@"icon_trade_in"];
    self.hashLb.text = [model.hashStr showShortAddressHead:9 tail:4];
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
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [self.bodyView addSubview:lineView];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.centerX.equalTo(self.bodyView.mas_left).offset(22);
    }];
    [self.hashLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(60);
        make.bottom.equalTo(self.bodyView.mas_centerY).offset(-2);
    }];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hashLb.mas_right).offset(6);
        make.centerY.equalTo(self.hashLb);
        make.right.lessThanOrEqualTo(self.amountLb.mas_left).offset(-10);
    }];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hashLb);
        make.top.equalTo(self.bodyView.mas_centerY).offset(2);
    }];
    [self.amountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.bottom.equalTo(self.bodyView.mas_centerY).offset(-2);
    }];
    [self.tokenNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.equalTo(self.bodyView.mas_centerY).offset(2);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1);
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
        _hashLb = [PW_ViewTool labelMediumText:@"" fontSize:14 textColor:[UIColor g_textColor]];
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
        _amountLb = [PW_ViewTool labelMediumText:@"" fontSize:18 textColor:[UIColor g_textColor]];
    }
    return _amountLb;
}
- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [PW_ViewTool labelMediumText:@"" fontSize:14 textColor:[UIColor g_grayTextColor]];
    }
    return _timeLb;
}
- (UILabel *)tokenNameLb {
    if (!_tokenNameLb) {
        _tokenNameLb = [PW_ViewTool labelText:@"" fontSize:12 textColor:[UIColor g_textColor]];
    }
    return _tokenNameLb;
}

@end
