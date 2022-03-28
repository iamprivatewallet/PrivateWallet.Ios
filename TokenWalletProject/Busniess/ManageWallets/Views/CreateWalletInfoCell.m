//
//  CreateWalletInfoCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/3.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "CreateWalletInfoCell.h"
@interface CreateWalletInfoCell()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, strong) UIImageView *icon;


@end
@implementation CreateWalletInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setViewWithData:(id)data{
    if (data) {
        NSDictionary *dic = (NSDictionary *)data;
        self.titleLbl.text = dic[@"title"];
        self.detailLbl.text = dic[@"detailText"];
        self.icon.image = ImageNamed(dic[@"icon"]);
    }
    
}
- (void)makeViews{
//    self.backgroundColor = [UIColor im_tableBgColor];
    UIView *bgView = [[UIView alloc] init];
//    bgView.layer.cornerRadius = 10;
    bgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(CGFloatScale(10));
//        make.right.equalTo(self.contentView).offset(-CGFloatScale(10));
        make.edges.equalTo(self.contentView);
    }];
    self.icon = [[UIImageView alloc] init];
    [bgView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(20);
        make.width.height.mas_equalTo(22);
        make.centerY.equalTo(bgView);
    }];
    self.titleLbl = [ZZCustomView labelInitWithView:bgView text:@"" textColor:[UIColor blackColor] font:GCSFontRegular(16)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(CGFloatScale(15));
        make.top.equalTo(bgView).offset(CGFloatScale(15));
    }];
    
    self.detailLbl = [ZZCustomView labelInitWithView:bgView text:@"" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(12)];
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(6);
    }];
    
    
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:ImageNamed(@"arrow")];
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
