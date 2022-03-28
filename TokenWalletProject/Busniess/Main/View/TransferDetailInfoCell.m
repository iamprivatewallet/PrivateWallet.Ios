//
//  TransferDetailInfoCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/30.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "TransferDetailInfoCell.h"
@interface TransferDetailInfoCell()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIImageView *arrowImg;

@end
@implementation TransferDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeViews];
    }
    return self;
}
- (void)setViewWithTitle:(NSString *)title content:(NSString *)content{
    self.titleLbl.text = title;
    self.contentLbl.text = content;
    if ([title isEqualToString:@"金额"]) {
        self.contentLbl.font = GCSFontMedium(15);
        self.contentLbl.textColor = [UIColor blackColor];
    }
    if ([title isEqualToString:@"收款地址"]||[title isEqualToString:@"付款地址"]||[title isEqualToString:@"交易号"]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self.contentLbl addGestureRecognizer:tap];
        self.contentLbl.userInteractionEnabled = YES;
        [tap addTarget:self action:@selector(copyContentAction)];
    }
}
- (void)setArrowImgWithTitle:(NSString *)title{
    self.titleLbl.text = title;
    self.arrowImg = [ZZCustomView imageViewInitView:self.contentView imageName:@"arrow"];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.width.height.equalTo(@17);
    }];
}
- (void)makeViews{
    self.titleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_grayColor] font:GCSFontRegular(13)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(20);
        make.width.equalTo(@100);
    }];
    
    self.contentLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_textColor_three] font:GCSFontRegular(13) textAlignment:NSTextAlignmentRight];
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.left.equalTo(self.titleLbl.mas_right).offset(CGFloatScale(30));
    }];
}

- (void)copyContentAction{
    [UITools pasteboardWithStr:self.contentLbl.text toast:@"复制成功"];
}

@end
