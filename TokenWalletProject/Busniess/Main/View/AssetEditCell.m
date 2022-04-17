//
//  AssetEditCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/30.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AssetEditCell.h"
@interface AssetEditCell()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *amountLbl;

@end
@implementation AssetEditCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeViews];
    }
    return self;
}
- (void)setViewWithData:(id)data{
    if (data && [data isKindOfClass:[WalletCoinModel class]]) {
        WalletCoinModel *model = data;
        NSString *icon_gray = @"icon_token_default";
        if([model.icon hasPrefix:@"http://"]||[model.icon hasPrefix:@"https://"]){
            [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:ImageNamed(icon_gray)];
        }else{
            self.iconImg.image = ![model.icon isNoEmpty]?ImageNamed(icon_gray):ImageNamed(model.icon);
        }
        self.nameLbl.text = model.tokenName;
        self.amountLbl.text = NSStringWithFormat(@"余额：%@",model.usableAmount);
        self.addressLbl.text = model.tokenAddress;
    }
}
- (void)hiddenEditView{
    self.addressLbl.hidden = YES;
    [self.nameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).offset(10);
        make.top.equalTo(self.iconImg);
    }];
    [self.amountLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl);
        make.top.equalTo(self.nameLbl.mas_bottom);
    }];
}

- (void)makeViews{
    self.iconImg = [ZZCustomView imageViewInitView:self.contentView imageName:@""];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@40);
    }];
    
    self.nameLbl = [ZZCustomView labelInitWithView:self.contentView text:@"ETH" textColor:[UIColor im_textColor_three] font:GCSFontRegular(14)];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(13);
    }];
    self.addressLbl = [ZZCustomView labelInitWithView:self.contentView text:@"0x0000000" textColor:[UIColor im_lightGrayColor] font:GCSFontRegular(14)];
    self.addressLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl);
        make.top.equalTo(self.nameLbl.mas_bottom);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
    }];
    self.amountLbl = [ZZCustomView labelInitWithView:self.contentView text:@"余额：0" textColor:[UIColor im_lightGrayColor] font:GCSFontRegular(14)];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl);
        make.top.equalTo(self.addressLbl.mas_bottom);
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
