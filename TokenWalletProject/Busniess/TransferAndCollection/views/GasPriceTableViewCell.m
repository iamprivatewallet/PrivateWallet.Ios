//
//  GasPriceTableViewCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/16.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "GasPriceTableViewCell.h"
@interface GasPriceTableViewCell()
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *gweiLbl;
@property (nonatomic, strong) UILabel *timeLbl;

@end
@implementation GasPriceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeViews];
    }
    return self;
}
- (void)setViewWithData:(id)data{
    if ([data isKindOfClass:[GasPriceModel class]]) {
        GasPriceModel *model = data;
        self.titleLbl.text = model.gas_speed;
        self.gweiLbl.text = NSStringWithFormat(@"%@ GWEI",model.gas_gwei);
        self.timeLbl.text = model.gas_time;
    }
}
- (void)makeViews {
    self.checkImg = [ZZCustomView imageViewInitView:self.contentView imageName:@"checkBlue"];
    self.checkImg.hidden = YES;
    [self.checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(17);
    }];
    self.titleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"最快" textColor:[UIColor blackColor] font:GCSFontRegular(15)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkImg.mas_right).offset(12);
        make.top.equalTo(self.contentView).offset(12);
    }];
    self.gweiLbl = [ZZCustomView labelInitWithView:self.contentView text:@"55.00 GWEI" textColor:[UIColor im_grayColor] font:GCSFontRegular(13)];
    [self.gweiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkImg.mas_right).offset(12);
        make.top.equalTo(self.titleLbl.mas_bottom);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
    self.timeLbl = [ZZCustomView labelInitWithView:self.contentView text:@"< 0.5 分钟" textColor:[UIColor im_grayColor] font:GCSFontRegular(11)];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(20);
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
