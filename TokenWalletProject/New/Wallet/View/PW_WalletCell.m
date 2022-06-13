//
//  PW_WalletCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletCell.h"

@interface PW_WalletCell()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *amountLb;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UILabel *costLb;

@end

@implementation PW_WalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}

- (void)setModel:(PW_TokenModel *)model {
    _model = model;
    NSString *icon_gray = @"icon_token_default";
    if([model.tokenLogo hasPrefix:@"http://"]||[model.tokenLogo hasPrefix:@"https://"]){
        [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.tokenLogo] placeholderImage:ImageNamed(icon_gray)];
    }else{
        self.iconIv.image = ![model.tokenLogo isNoEmpty]?ImageNamed(icon_gray):ImageNamed(model.tokenLogo);
    }
    self.nameLb.text = model.tokenName;
    self.priceLb.text = [model.price isNoEmpty]?NSStringWithFormat(@"$%@",model.price):@"--";
    BOOL isHidden = [GetUserDefaultsForKey(kHiddenWalletAmount) boolValue];
    if (isHidden) {
        self.amountLb.text = @"****";
        self.costLb.text = @"****";
    }else{
        self.amountLb.text = [model.tokenAmount isNoEmpty]?model.tokenAmount:@"--";
        self.costLb.text = [model.tokenAmount isNoEmpty]&&[model.price isNoEmpty]?NSStringWithFormat(@"$%@",[model.tokenAmount stringDownMultiplyingBy:model.price decimal:8]):@"--";
    }
}

- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.lineView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.amountLb];
    [self.bodyView addSubview:self.priceLb];
    [self.bodyView addSubview:self.costLb];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(38);
        make.right.offset(-38);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_offset(1);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(0);
        make.width.height.offset(46);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(18);
        make.bottom.equalTo(self.bodyView.mas_centerY).offset(-1);
    }];
    [self.amountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.bottom.equalTo(self.nameLb);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(18);
        make.top.equalTo(self.bodyView.mas_centerY).offset(1);
    }];
    [self.costLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.equalTo(self.priceLb);
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

- (UIView *)bodyView {
    if(!_bodyView) {
        _bodyView = [[UIView alloc] init];
    }
    return _bodyView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor g_lineColor];
    }
    return _lineView;
}
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
    }
    return _iconIv;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelMediumText:@"" fontSize:18 textColor:[UIColor g_boldTextColor]];
    }
    return _nameLb;
}
- (UILabel *)amountLb {
    if (!_amountLb) {
        _amountLb = [PW_ViewTool labelMediumText:@"" fontSize:20 textColor:[UIColor g_boldTextColor]];
    }
    return _amountLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [PW_ViewTool labelMediumText:@"" fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _priceLb;
}
- (UILabel *)costLb {
    if (!_costLb) {
        _costLb = [PW_ViewTool labelMediumText:@"" fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _costLb;
}

@end
