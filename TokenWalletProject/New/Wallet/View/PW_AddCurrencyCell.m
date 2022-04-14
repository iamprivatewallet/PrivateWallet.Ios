//
//  PW_AddCurrencyCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddCurrencyCell.h"

@interface PW_AddCurrencyCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *detailLb;
@property (nonatomic, strong) UIButton *checkBtn;

@end

@implementation PW_AddCurrencyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_AddCurrencyModel *)model {
    _model = model;
    self.iconIv.image = [UIImage imageNamed:model.icon];
    self.titleLb.text = model.title;
    self.detailLb.text = model.desc;
    self.checkBtn.selected = model.isChecked;
    self.checkBtn.enabled = !model.isDefault;
}
- (void)makeViews {
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    self.titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:15 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:self.titleLb];
    self.detailLb = [PW_ViewTool labelText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:self.detailLb];
    self.checkBtn = [PW_ViewTool buttonImageName:@"icon_uncheck" selectedImage:@"icon_check" target:nil action:nil];
    self.checkBtn.userInteractionEnabled = NO;
    [self.checkBtn setImage:[UIImage imageNamed:@"currency_check"] forState:UIControlStateDisabled];
    [self.contentView addSubview:self.checkBtn];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.centerY.equalTo(self.contentView);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(15);
        make.bottom.equalTo(self.iconIv.mas_centerY).offset(0);
    }];
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.equalTo(self.titleLb.mas_bottom);
    }];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
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

@end
