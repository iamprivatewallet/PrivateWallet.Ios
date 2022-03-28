//
//  DAppsCollectionViewCell.m
//  TokenWalletProject
//
//  Created by FChain on 2021/9/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "DAppsCollectionViewCell.h"

@interface DAppsCollectionViewCell()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation DAppsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置控件
        [self makeViews];
    }
    return self;
}
- (void)fillData:(id)data{
    if (data && [data isKindOfClass:[BrowseRecordsModel class]]) {
        BrowseRecordsModel *model = data;
        self.titleLbl.text = model.appName;
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    }
}

- (void)makeViews{
    self.iconImg = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@55);
    }];
    
    self.titleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"app" textColor:[UIColor im_textColor_three] font:GCSFontRegular(13)];
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.numberOfLines = 2;
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImg.mas_bottom).offset(5);
        make.centerX.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.contentView);
    }];
    
}
@end
