//
//  PW_DappBanner2Cell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappBanner2Cell.h"

@interface PW_DappBanner2Cell ()

@property (nonatomic, strong) UIImageView *icon1Iv;
@property (nonatomic, strong) UIImageView *icon2Iv;

@end

@implementation PW_DappBanner2Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icon1Iv = [[UIImageView alloc] init];
        [self.icon1Iv setCornerRadius:8];
        self.icon1Iv.contentMode = UIViewContentModeScaleAspectFill;
        [self.icon1Iv addTapTarget:self action:@selector(btn1Action)];
        [self.contentView addSubview:self.icon1Iv];
        self.icon2Iv = [[UIImageView alloc] init];
        [self.icon2Iv setCornerRadius:8];
        self.icon2Iv.contentMode = UIViewContentModeScaleAspectFill;
        [self.icon2Iv addTapTarget:self action:@selector(btn2Action)];
        [self.contentView addSubview:self.icon2Iv];
        [self.icon1Iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(30);
            make.bottom.offset(-10);
        }];
        [self.icon2Iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.bottom.equalTo(self.icon1Iv);
            make.left.equalTo(self.icon1Iv.mas_right).offset(15);
            make.right.offset(-30);
        }];
    }
    return self;
}
- (void)setDataArr:(NSArray<PW_BannerModel *> *)dataArr {
    _dataArr = dataArr;
    if (dataArr.count>0) {
        [self.icon1Iv sd_setImageWithURL:[NSURL URLWithString:dataArr.firstObject.imgH5]];
    }
    if (dataArr.count>1) {
        [self.icon2Iv sd_setImageWithURL:[NSURL URLWithString:dataArr[1].imgH5]];
    }
}
- (void)btn1Action {
    if (self.clickBlock&&self.dataArr.count>0) {
        self.clickBlock(self.dataArr[0]);
    }
}
- (void)btn2Action {
    if (self.clickBlock&&self.dataArr.count>1) {
        self.clickBlock(self.dataArr[1]);
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
