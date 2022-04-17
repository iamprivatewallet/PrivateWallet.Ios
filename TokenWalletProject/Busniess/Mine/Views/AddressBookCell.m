//
//  AddressBookCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/11.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AddressBookCell.h"
@interface AddressBookCell()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, strong) UILabel *describeLbl;

@end
@implementation AddressBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeViews];
    }
    return self;
}
- (void)setViewWithData:(id)data{
    if (data && [data isKindOfClass:[ChooseCoinTypeModel class]]) {
        ChooseCoinTypeModel *model = data;
        self.iconImg.image = ImageNamed(model.icon);
        self.titleLbl.text = model.name;
        self.detailLbl.text = model.address;
        self.describeLbl.text = model.describe;
        if ([model.describe isNoEmpty]) {
            [self.detailLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLbl);
                make.top.equalTo(self.titleLbl.mas_bottom).offset(3);
                make.right.equalTo(self.contentView).offset(-30);
            }];
            [self.describeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconImg.mas_right).offset(15);
                make.top.equalTo(self.detailLbl.mas_bottom).offset(3);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
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
    
    self.titleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(12)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).offset(15);
        make.top.equalTo(self.contentView).offset(12);
    }];
    
    self.detailLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_textColor_three] font:GCSFontRegular(12)];
    self.detailLbl.numberOfLines = 2;
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(3);
        make.right.equalTo(self.contentView).offset(-30);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    self.describeLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(12)];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
