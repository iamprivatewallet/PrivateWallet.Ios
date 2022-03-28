//
//  AddCurrencyCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/30.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AddCurrencyCell.h"

@implementation AddCurrencyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews{
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 10;
    bgView.backgroundColor = COLORFORRGB(0xf3f5f6);
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(CGFloatScale(15));
        make.right.equalTo(self.contentView).offset(-CGFloatScale(15));
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-CGFloatScale(10));
    }];
    
    UILabel *titleLbl = [ZZCustomView labelInitWithView:bgView text:@"添加币种" textColor:[UIColor darkGrayColor] font:GCSFontRegular(16)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(CGFloatScale(20));
        make.top.equalTo(bgView).offset(CGFloatScale(10));
    }];
    
    UILabel *addressLbl = [ZZCustomView labelInitWithView:bgView text:@"支持ETH、BSC、HECO..." textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(13)];
    [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLbl);
        make.top.equalTo(titleLbl.mas_bottom);
    }];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:ImageNamed(@"addGray")];
    [bgView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-22);
        make.width.height.mas_equalTo(22);
        make.centerY.equalTo(bgView);
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
