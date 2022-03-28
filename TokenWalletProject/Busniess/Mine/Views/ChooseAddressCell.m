//
//  ChooseAddressCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/10.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ChooseAddressCell.h"
@interface ChooseAddressCell()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;

@end
@implementation ChooseAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeViews];
    }
    return self;
}
- (void)setViewWithData:(id)data{
    if (data) {
        ChooseCoinTypeModel *model = data;
        self.iconImg.image = ImageNamed(model.icon);
        self.titleLbl.text = model.type;
        self.detailLbl.text = model.detailTitle;
    }
}
- (void)makeViews {
    self.iconImg = [ZZCustomView imageViewInitView:self.contentView imageName:@""];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.centerY.equalTo(self.contentView);
    }];
    
    self.titleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_textColor_three] font:GCSFontRegular(15)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).offset(15);
        make.top.equalTo(self.iconImg).offset(-5);
    }];
    
    self.detailLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_textColor_six] font:GCSFontRegular(13)];
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.top.equalTo(self.titleLbl.mas_bottom);
    }];
    
    self.checkIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkIconBtn setBackgroundImage:ImageNamed(@"checkedBlueGhost") forState:UIControlStateNormal];
    [self.contentView addSubview:self.checkIconBtn];
    [self.checkIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    self.checkIconBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
}

@end
