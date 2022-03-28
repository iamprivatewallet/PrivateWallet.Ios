//
//  DAppsTableViewCell.m
//  TokenWalletProject
//
//  Created by FChain on 2021/9/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "DAppsTableViewCell.h"
@interface DAppsTableViewCell()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;

@end
@implementation DAppsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeViews];
    }
    return self;
}

- (void)fillData:(id)data{
    if (data && [data isKindOfClass:[BrowseRecordsModel class]]) {
        BrowseRecordsModel *model = data;
        self.titleLbl.text = model.appName;
        self.contentLbl.text = model.descriptionStr;
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:ImageNamed(@"defaultDappIcon")];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGFloat margin = (self.height-self.titleLbl.height-self.contentLbl.height)/2;
            
            [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(margin);
                make.left.equalTo(self.contentLbl);
                make.right.equalTo(self.contentView).offset(-25);
            }];
            [self.contentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconImg.mas_right).offset(10);
                make.right.equalTo(self.contentView).offset(-25);
                make.top.equalTo(self.titleLbl.mas_bottom);
            }];
            
        });
    }
}

- (void)makeViews{
    self.iconImg = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.width.height.equalTo(@55);
    }];
    
    self.contentLbl = [ZZCustomView labelInitWithView:self.contentView text:@"去中心化" textColor:[UIColor im_grayColor] font:GCSFontRegular(14)];
    self.contentLbl.numberOfLines = 2;
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-25);
        make.top.equalTo(self.contentView.mas_centerY);
    }];
    
    self.titleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"app" textColor:[UIColor im_textColor_three] font:GCSFontRegular(14)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentLbl.mas_top);
        make.left.equalTo(self.contentLbl);
        make.right.equalTo(self.contentView).offset(-25);
    }];
}

@end
