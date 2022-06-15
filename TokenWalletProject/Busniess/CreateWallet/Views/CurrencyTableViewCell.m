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
                [self.checkIconBtn setBackgroundImage:ImageNamed(@"icon_check") forState:UIControlStateNormal];
            }else{
                [self.checkIconBtn setBackgroundImage:ImageNamed(@"icon_uncheck") forState:UIControlStateNormal];
            }
        }
    }
    
}

- (void)makeViews {
    self.iconImg = [ZZCustomView imageViewInitView:self.contentView imageName:@"walletEthNormal"];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(58);
        make.centerY.offset(0);
    }];
    
    self.titleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"ETH" textColor:[UIColor im_textColor_three] font:GCSFontSemibold(15)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(94);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
    }];
    
    self.detailLbl = [ZZCustomView labelInitWithView:self.contentView text:@"Ethereum" textColor:[UIColor im_textColor_six] font:GCSFontRegular(13)];
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(4);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.bottom.offset(0);
        make.height.offset(1);
    }];
    if (self.isCheck) {//选择对号
        self.checkIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkIconBtn setBackgroundImage:ImageNamed(@"icon_check") forState:UIControlStateNormal];
        [self.contentView addSubview:self.checkIconBtn];
        [self.checkIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-36);
            make.centerY.equalTo(self.contentView);
        }];
    }else{//箭头
        UIImageView *arrow = [ZZCustomView imageViewInitView:self.contentView imageName:@"icon_arrow"];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-36);
            make.centerY.offset(0);
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
