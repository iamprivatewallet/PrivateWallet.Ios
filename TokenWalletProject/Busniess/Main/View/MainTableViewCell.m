//
//  MainTableViewCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/29.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MainTableViewCell.h"
@interface MainTableViewCell()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *amountLbl;
@property (nonatomic, strong) UILabel *rmbAmountLbl;
@property (nonatomic, strong) WalletCoinModel *model;

@end
@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)changeAmountStatus{
    BOOL isHidden = [GetUserDefaultsForKey(@"isHiddenWalletAmount") boolValue];
    if (isHidden) {
        self.amountLbl.text = @"****";
        self.rmbAmountLbl.text = @"****";
    }else{
        self.amountLbl.text = self.model.usableAmount;
        self.rmbAmountLbl.text = NSStringWithFormat(@"$%@",[self.model.usableAmount stringDownMultiplyingBy:self.model.usdtPrice decimal:8]);
    }
}
- (void)setViewWithData:(id)data{
    if (data && [data isKindOfClass:[WalletCoinModel class]]) {
        WalletCoinModel *model = data;
        self.model = model;
        NSString *icon_gray = @"icon_token_default";
        if([model.icon hasPrefix:@"http://"]||[model.icon hasPrefix:@"https://"]){
            [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:ImageNamed(icon_gray)];
        }else{
            self.iconImg.image = [model.icon isEmptyStr]?ImageNamed(icon_gray):ImageNamed(model.icon);
        }
        self.titleLbl.text = model.tokenName;
        self.amountLbl.text = model.usableAmount;
        self.rmbAmountLbl.text = NSStringWithFormat(@"$%@",[model.usableAmount stringDownMultiplyingBy:model.usdtPrice decimal:8]);
    }
}

- (void)makeViews{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.iconImg = [[UIImageView alloc] init];
    self.iconImg.image = ImageNamed(@"walletEthNormal");
    [self.contentView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(CGFloatScale(20));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(35), CGFloatScale(35)));
    }];
    self.titleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"ETH" textColor:[UIColor blackColor] font:GCSFontRegular(18)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).offset(CGFloatScale(10));
        make.centerY.equalTo(self.contentView);
    }];
    
    self.amountLbl = [ZZCustomView labelInitWithView:self.contentView text:@"0" textColor:[UIColor blackColor] font:GCSFontRegular(19)];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-CGFloatScale(20));
        make.top.equalTo(self.contentView).offset(CGFloatScale(15));
    }];
    
    self.rmbAmountLbl = [ZZCustomView labelInitWithView:self.contentView text:@"$0" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(13)];
    [self.rmbAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.amountLbl);
        make.top.equalTo(self.amountLbl.mas_bottom);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
