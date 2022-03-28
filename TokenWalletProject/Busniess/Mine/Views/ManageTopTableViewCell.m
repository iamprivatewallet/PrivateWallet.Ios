//
//  ManageTopTableViewCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/3.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ManageTopTableViewCell.h"
@interface ManageTopTableViewCell()
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, strong) UIButton *backBtn;

@end
@implementation ManageTopTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeViews];
    }
    return self;
}

- (void)makeViews{
    self.userIcon = [ZZCustomView imageViewInitView:self.contentView imageName:@"defaultAvatar"];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(CGFloatScale(20));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(CGFloatScale(45));
    }];
    
    self.titleLbl = [ZZCustomView labelInitWithView:self.contentView text:User_manager.currentUser.user_name textColor:[UIColor im_textColor_three] font:GCSFontRegular(14)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).offset(CGFloatScale(10));
        make.top.equalTo(self.userIcon);
    }];
    
    self.detailLbl = [ZZCustomView labelInitWithView:self.contentView text:@"管理身份钱包" textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(14)];
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(5);
    }];
    UIImageView *arrowImg = [ZZCustomView imageViewInitView:self.contentView imageName:@"arrow"];
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-CGFloatScale(20));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(15), CGFloatScale(15)));
        make.centerY.equalTo(self.contentView);
    }];
    if (![User_manager isBackup]) {
        self.backBtn = [ZZCustomView buttonInitWithView:self.contentView title:@" 未备份" titleColor:[UIColor im_textLightGrayColor] titleFont:GCSFontRegular(14)];
        [self.backBtn setImage:ImageNamed(@"backupWarnning") forState:UIControlStateNormal];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImg.mas_left);
            make.centerY.equalTo(self.contentView);
        }];
    }
    
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
