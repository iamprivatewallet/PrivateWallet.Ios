//
//  AssetTableCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/24.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AssetTableCell.h"
@interface AssetTableCell()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *amountLbl;
@property (nonatomic, strong) UILabel *statusLbl;

@end
@implementation AssetTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeViews];
    }
    return self;
}

- (void)fillData:(id)data{
    if ([data isKindOfClass:[WalletRecord class]]) {
        WalletRecord *model = data;
        self.timeLbl.text = model.create_time;
        self.amountLbl.text = NSStringWithFormat(@"%@%@",model.is_out?@"-":@"+",model.amount);
        self.addressLbl.text = model.to_addr;
        self.icon.image = model.status==0?ImageNamed(@"txPending"):(model.status==1?ImageNamed(@"txSend"):ImageNamed(@"txFail"));
        self.statusLbl.hidden = model.status!=0;
    }else if ([data isKindOfClass:[RecordModel class]]) {
        RecordModel *model = data;
        NSString *timeStr = [UITools timeLabelWithTimeInterval:model.timeStamp];
        self.timeLbl.text = timeStr;
        self.amountLbl.text = NSStringWithFormat(@"%@%@",model.is_out?@"-":@"+",model.value);
        self.addressLbl.text = model.to;
        self.icon.image = ImageNamed(@"txSend");
        self.statusLbl.hidden = YES;
    }
}

- (void)makeViews{
    self.icon = [ZZCustomView imageViewInitView:self.contentView imageName:@"txPending"];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(25);
        make.width.height.equalTo(@25);
    }];
    
    self.addressLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_textColor_three] font:GCSFontRegular(13)];
    self.addressLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.top.equalTo(self.icon);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
    }];
    
    self.timeLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_lightGrayColor] font:GCSFontRegular(12)];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLbl);
        make.top.equalTo(self.addressLbl.mas_bottom).offset(5);
    }];
    
    self.amountLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_btnSelectColor] font:GCSFontRegular(13)];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.addressLbl);
    }];
    
    self.statusLbl = [ZZCustomView labelInitWithView:self.contentView text:@"确认中" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(12)];
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.amountLbl);
        make.top.equalTo(self.amountLbl.mas_bottom).offset(5);
    }];
    self.statusLbl.hidden = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
