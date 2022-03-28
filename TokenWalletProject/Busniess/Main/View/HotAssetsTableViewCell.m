//
//  HotAssetsTableViewCell.m
//  TokenWalletProject
//
//  Created by FChain on 2021/9/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "HotAssetsTableViewCell.h"
@interface HotAssetsTableViewCell()
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *nameLbl;
@end
@implementation HotAssetsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}
- (void)setViewWithData:(id)data{
    if (data && [data isKindOfClass:[AssetCoinModel class]]) {
        AssetCoinModel *model = data;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:model.tokenLogo]];
        self.nameLbl.text = model.tokenName;
        self.addressLbl.text = model.tokenContract;
        [self.addBtn setImage:ImageNamed(model.isExit?@"currency_check":@"addContact") forState:UIControlStateNormal];
    }
}

- (void)makeViews{
    self.addBtn = [ZZCustomView buttonInitWithView:self.contentView imageName:@"addContact"];
    [self.addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-25);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@21);
    }];
    
    self.icon = [ZZCustomView imageViewInitView:self.contentView imageName:@"icon_ETH"];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@40);
    }];
    
    self.nameLbl = [ZZCustomView labelInitWithView:self.contentView text:@"ETH" textColor:[UIColor im_textColor_three] font:GCSFontRegular(14)];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(13);
    }];
    self.addressLbl = [ZZCustomView labelInitWithView:self.contentView text:@"0x0000000" textColor:[UIColor im_grayColor] font:GCSFontRegular(14)];
    self.addressLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl);
        make.top.equalTo(self.nameLbl.mas_bottom);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
    }];
    
}
- (void)addBtnAction{
    if(self.addBlock) {
        self.addBlock();
    }
}

@end
