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
        self.iconIv.image = [model.tokenLogo isEmptyStr]?ImageNamed(icon_gray):ImageNamed(model.tokenLogo);
    }
    self.nameLb.text = model.tokenName;
    self.priceLb.text = [model.price isNoEmpty]?NSStringWithFormat(@"$%@",model.price):@"--";
    BOOL isHidden = [GetUserDefaultsForKey(kHiddenWalletAmount) boolValue];
    BOOL isHiddenSmall = [GetUserDefaultsForKey(kHiddenWalletSmallAmount) boolValue];
    if (isHidden||(isHiddenSmall&&model.tokenAmount.doubleValue<g_smallAmount)) {
        self.amountLb.text = @"****";
        self.costLb.text = @"****";
    }else{
        self.amountLb.text = [model.tokenAmount isNoEmpty]?model.tokenAmount:@"--";
        self.costLb.text = [model.tokenAmount isNoEmpty]?NSStringWithFormat(@"$%@",[model.tokenAmount stringDownMultiplyingBy:model.price decimal:8]):@"--";
    }
}

- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.amountLb];
    [self.bodyView addSubview:self.priceLb];
    [self.bodyView addSubview:self.costLb];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-8);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(12);
        make.width.height.offset(40);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(15);
        make.top.offset(12);
    }];
    [self.amountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.top.offset(9);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(15);
        make.bottom.offset(-10);
    }];
    [self.costLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.bottom.offset(-8);
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
        _bodyView.backgroundColor = [UIColor g_bgColor];
        [_bodyView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
        _bodyView.layer.cornerRadius = 8;
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
