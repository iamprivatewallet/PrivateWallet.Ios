//
//  MinerFeeCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/16.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MinerFeeCell.h"
@interface MinerFeeCell()
@property (nonatomic, strong) UILabel *feeLbl;
@property (nonatomic, strong) UILabel *feeRMBLbl;
@property (nonatomic, strong) UIButton *helpBtn;

@property (nonatomic, strong) UILabel *gasLbl;
@property (nonatomic, strong) UIImageView *helpIcon;


@end
@implementation MinerFeeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeViews];
    }
    return self;
}
- (void)fillData:(id)data{
    if ([data isKindOfClass:[GasPriceModel class]]) {
        GasPriceModel *model = data;
        NSString *gas = model.gas?model.gas:@"21000";
        CGFloat gweiETH = [model.gas_gwei doubleValue]*[gas doubleValue]/1000000000;
        NSString *gasStr = NSStringWithFormat(@"Gas Price（%.2f GWEI）* Gas（%@）",[model.gas_gwei doubleValue],gas);
        self.feeLbl.text = NSStringWithFormat(@"%f %@",gweiETH,[[SettingManager sharedInstance] getChainCoinName]);
        self.feeRMBLbl.text = @"￥0.0";
        self.gasLbl.text = gasStr;
    }
   if ([data isKindOfClass:[CurrentGasPriceModel class]]) {
        CurrentGasPriceModel *model = data;
        NSString *gas = model.gas?model.gas:@"21000";
        CGFloat gweiETH = [model.gas_price doubleValue]*[gas doubleValue]/1000000000;
        NSString *gasStr = NSStringWithFormat(@"Gas Price（%.2f GWEI）* Gas（%@）",[model.gas_price doubleValue],gas);
        self.feeLbl.text = NSStringWithFormat(@"%f %@",gweiETH,[[SettingManager sharedInstance] getChainCoinName]);
        self.feeRMBLbl.text = @"￥0.0";
        self.gasLbl.text = gasStr;
    }
}
- (void)makeViews {
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"矿工费" textColor:[UIColor im_textColor_three] font:GCSFontRegular(15)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(20);
    }];
    
    self.feeLbl = [ZZCustomView labelInitWithView:self.contentView text:@"0.0ETH" textColor:[UIColor blackColor] font:GCSFontRegular(15)];
    [self.feeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(20);

    }];
    self.feeRMBLbl = [ZZCustomView labelInitWithView:self.contentView text:@"￥0.0" textColor:[UIColor im_lightGrayColor] font:GCSFontRegular(13)];
    [self.feeRMBLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.feeLbl.mas_bottom);
        make.height.mas_equalTo(20);

    }];
    
    UIView *line = [ZZCustomView viewInitWithView:self.contentView bgColor:[UIColor im_borderLineColor]];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.feeRMBLbl.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    NSString *helpStr = @"Gas Price（0.00 GWEI）* Gas（21000）";
    self.helpBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.helpBtn];
    [self.helpBtn addTarget:self action:@selector(helpBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(50);
        make.height.mas_equalTo(30);
    }];
    
    self.helpIcon = [ZZCustomView imageViewInitView:self.helpBtn imageName:@"suggested"];
    [self.helpIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.helpBtn).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.height.mas_equalTo(13);
    }];
    self.gasLbl = [ZZCustomView labelInitWithView:self.helpBtn text:helpStr textColor:[UIColor im_grayColor] font:GCSFontRegular(11)];
    [self.gasLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.helpIcon);
        make.right.equalTo(self.helpIcon.mas_left).offset(-3);
    }];
}

- (void)helpBtnAction{
    
}


@end
