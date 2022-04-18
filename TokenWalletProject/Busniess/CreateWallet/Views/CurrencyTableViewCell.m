//
//  CurrencyTableViewCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/22.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "CurrencyTableViewCell.h"
@interface CurrencyTableViewCell()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, strong) UIButton *checkIconBtn;
@property(nonatomic, assign) BOOL isCheck;
@end
@implementation CurrencyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isCheck:(BOOL)isCheck {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.isCheck = isCheck;
        [self makeViews];
    }
    return self;
}
- (void)setViewWithData:(id)data{
    if ([data isKindOfClass:[CurrencyInfoModel class]]) {
        CurrencyInfoModel *mdl = data;
        self.iconImg.image = ImageNamed(NSStringWithFormat(@"%@",mdl.icon));
        self.titleLbl.text = mdl.title;
        self.detailLbl.text = mdl.detailText;
        if (![mdl.isDefault boolValue]) {
            //不是默认币种，可以选择点击
            if (mdl.isChecked) {
                [self.checkIconBtn setBackgroundImage:ImageNamed(@"checkedBlueGhost") forState:UIControlStateNormal];
            }else{
                [self.checkIconBtn setBackgroundImage:ImageNamed(@"uncheck") forState:UIControlStateNormal];
            }
        }
    }
    
}

- (void)makeViews {
    self.iconImg = [ZZCustomView imageViewInitView:self.contentView imageName:@"walletEthNormal"];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.centerY.equalTo(self.contentView);
    }];
    
    self.titleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"ETH" textColor:[UIColor im_textColor_three] font:GCSFontSemibold(15)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).offset(15);
        make.top.equalTo(self.iconImg).offset(-5);
    }];
    
    self.detailLbl = [ZZCustomView labelInitWithView:self.contentView text:@"Ethereum" textColor:[UIColor im_textColor_six] font:GCSFontRegular(13)];
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.top.equalTo(self.titleLbl.mas_bottom);
    }];
    if (self.isCheck) {//选择对号
        self.checkIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkIconBtn setBackgroundImage:ImageNamed(@"currency_check") forState:UIControlStateNormal];
        [self.contentView addSubview:self.checkIconBtn];
        [self.checkIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(21, 21));
        }];
    }else{//箭头
        UIImageView *arrow = [ZZCustomView imageViewInitView:self.contentView imageName:@"arrow"];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
    }
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [UIColor navAndTabBackColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];

    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (self.isCheck) {
//        if (selected) {
//            [self.checkIconBtn setBackgroundImage:ImageNamed(@"checkedBlueGhost") forState:UIControlStateNormal];
//        }else{
//            [self.checkIconBtn setBackgroundImage:ImageNamed(@"uncheck") forState:UIControlStateNormal];
//        }
//    }
    // Configure the view for the selected state
}

@end
