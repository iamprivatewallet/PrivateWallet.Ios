//
//  TransferView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/13.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "TransferView.h"
@interface TransferView()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *advancedModeBtn;
@property (nonatomic, strong) UIButton *nextStepBtn;
@property (nonatomic, strong) WalletCoinModel *coinModel;
@property (nonatomic, strong) GasPriceModel *gasModel;
@property (nonatomic, strong) ScanCodeInfoModel *codeInfoModel;

@property (nonatomic, strong) UITextField *tipsTF;

@end
@implementation TransferView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeViews];
        [self makeBottomViews];
    }
    return self;
}

- (void)setGasPriceWithData:(id)data{
    if (data && [data isKindOfClass:[GasPriceModel class]]) {
        self.gasModel = data;
        self.gasPriceLbl.text = NSStringWithFormat(@"%f %@",self.gasModel.all_gasAmount,[[SettingManager sharedInstance] getChainCoinName]);
        [self.tableView reloadData];
    }
}
- (void)setViewWithModel:(id)model{
    if (model && [model isKindOfClass:[WalletCoinModel class]]) {
        self.coinModel = model;
        [self.tableView reloadData];
    }
}
- (void)setCodeInfoWithModel:(id)model{
    if (model && [model isKindOfClass:[ScanCodeInfoModel class]]) {
        self.codeInfoModel = model;
        [self.tableView reloadData];
    }
}
- (void)advancedModeBtnAction{
    //高级模式
    if (self.delegate && [self.delegate respondsToSelector:@selector(advancedModeAction)]) {
        [self.delegate advancedModeAction];
    }
}
- (void)nextStepBtnAction{
    //下一步
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextStepActionWithData:)]) {
        if (self.addrTF.text.length <= 0) {
            return [UITools showToast:@"请输入正确的地址"];
        }
        if (self.amountTF.text.length <= 0 || ![UITools isNumber:self.amountTF.text]) {
            return [UITools showToast:@"请输入正确的金额"];
        }
        if ([self.amountTF.text doubleValue] > [self.coinModel.usableAmount doubleValue]) {
            return [UITools showToast:@"余额不足"];
        }
        TransferInputModel *inputModel = [[TransferInputModel alloc] init];
        inputModel.address = self.addrTF.text;
        inputModel.amount = self.amountTF.text;
        inputModel.tips = self.tipsTF.text;
        inputModel.gas_price = self.gasModel.gas_gwei;
        inputModel.gas = self.gasModel.gas;
        inputModel.all_gasPrice = NSStringWithFormat(@"%f",self.gasModel.all_gasAmount);
        [self.delegate nextStepActionWithData:inputModel];
    }
}
- (void)addrBtnAction{
    //地址
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressAction)]) {
        [self.delegate addressAction];
    }
}
- (void)feeViewAction{
    //兑换
    if (self.delegate && [self.delegate respondsToSelector:@selector(exchangeAction)]) {
        [self.delegate exchangeAction];
    }
}

- (void)makeViews{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-120);
        make.top.equalTo(self);
    }];
}

- (void)makeBottomViews{
    UIView *bottomBgView = [[UIView alloc] init];
    bottomBgView.backgroundColor = [UIColor navAndTabBackColor];
    [self addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(120+kBottomSafeHeight);
    }];

    self.nextStepBtn = [ZZCustomView im_ButtonDefaultWithView:bottomBgView title:@"下一步" titleFont:GCSFontRegular(16) enable:YES];
    [self.nextStepBtn addTarget:self action:@selector(nextStepBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBgView).offset(15);
        make.right.equalTo(bottomBgView).offset(-15);
        make.bottom.equalTo(bottomBgView).offset(-kBottomSafeHeight-(iPhoneX?0:20));
        make.height.mas_equalTo(45);
    }];
    
    self.advancedModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.advancedModeBtn addTarget:self action:@selector(advancedModeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBgView addSubview:self.advancedModeBtn];
    [self.advancedModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nextStepBtn.mas_top).offset(-10);
        make.centerX.equalTo(bottomBgView);
        make.width.mas_equalTo(120);
    }];
    
    UILabel *amountLbl = [ZZCustomView labelInitWithView:self.advancedModeBtn text:@"高级模式" textColor:COLORFORRGB(0x787a8b) font:GCSFontRegular(13)];
    [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.advancedModeBtn).offset(-10);
        make.bottom.equalTo(self.advancedModeBtn).offset(-10);
    }];
    UIImageView *addrImg = [ZZCustomView imageViewInitView:self.advancedModeBtn imageName:@"arrowRightGray"];
    [addrImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(amountLbl);
        make.left.equalTo(amountLbl.mas_right).offset(5);
        make.width.height.mas_equalTo(17);
    }];
 
}

#pragma mark delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        return CGFloatScale(134);
    }else {
        return CGFloatScale(55);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 10;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 60;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor navAndTabBackColor];
    if (section != 2) {
        UILabel *textLbl = [ZZCustomView labelInitWithView:view text:@"收款地址" textColor:[UIColor im_textColor_three] font:GCSFontRegular(13)];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(5);
            make.bottom.equalTo(view).offset(-5);
        }];
        if (section == 1) {
            textLbl.text = @"金额";
            UILabel *amountLbl = [ZZCustomView labelInitWithView:view text:NSStringWithFormat(@"%.4f %@",[self.coinModel.usableAmount doubleValue],self.coinModel.tokenName) textColor:[UIColor im_grayColor] font:GCSFontRegular(11)];
            [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view).offset(-5);
                make.bottom.equalTo(view).offset(-5);
            }];
        }
    }
    return view;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *view = [[UIView alloc] init];
        
        UIView *bgView = [ZZCustomView viewInitWithView:view bgColor:COLORFORRGB(0xfefbf4)];
        bgView.layer.cornerRadius = 8;
        bgView.layer.borderColor = [UIColor im_borderLineColor].CGColor;
        bgView.layer.borderWidth = 1;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(10);
            make.left.right.equalTo(view);
            make.height.mas_equalTo(45);
        }];
        UILabel *textLbl = [ZZCustomView labelInitWithView:bgView text:NSStringWithFormat(@"矿工费加油站，快速充值 %@",[[SettingManager sharedInstance] getChainCoinName]) textColor:COLORFORRGB(0x787a8b) font:GCSFontRegular(13)];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(15);
            make.centerY.equalTo(bgView);
            make.right.equalTo(bgView).offset(-30);
        }];
        
        UIImageView *rightArrow = [ZZCustomView imageViewInitView:bgView imageName:@"goSnapshot"];
        [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.right.equalTo(bgView).offset(-12);
            make.width.height.mas_equalTo(17);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feeViewAction)];
        [bgView addGestureRecognizer:tap];
        
        return view;
    }
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = NSStringWithFormat(@"cell%ld",(long)indexPath.section);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [self getAddressCellWithIdentifer:identifier];
        }else if (indexPath.section == 1) {
            cell = [self getAmountCellWithIdentifer:identifier];
        }else{
            cell = [self getMinersfeeCellWithIdentifer:identifier];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section == 2) {
        //矿工费
        if (self.delegate && [self.delegate respondsToSelector:@selector(minersfeeAction)]) {
            [self.delegate minersfeeAction];
        }
    }
}
//收款地址cell
- (UITableViewCell *)getAddressCellWithIdentifer:(NSString *)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    self.addrTF = [ZZCustomView textFieldInitFrame:CGRectZero view:cell.contentView placeholder:NSStringWithFormat(@"%@ 地址",self.coinModel.currentWallet.type) delegate:self font:GCSFontRegular(14) textColor:[UIColor im_textColor_three]];
    [self.addrTF addTarget:self action:@selector(inputTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.addrTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(20);
        make.right.equalTo(cell.contentView).offset(-40);
    }];
    UIButton *addrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addrBtn addTarget:self action:@selector(addrBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:addrBtn];
    [addrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(cell.contentView);
        make.width.mas_equalTo(40);
    }];
    UIImageView *addrImg = [ZZCustomView imageViewInitView:cell.contentView imageName:@"selectAddress"];
    [addrImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-15);
        make.width.height.mas_equalTo(17);
    }];
    return cell;

}
//金额cell
- (UITableViewCell *)getAmountCellWithIdentifer:(NSString *)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    self.tipsTF = [ZZCustomView textFieldInitFrame:CGRectZero view:cell.contentView placeholder:@"备注" delegate:self font:GCSFontRegular(14) textColor:[UIColor im_textColor_three]];
    
    [self.tipsTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(20);
        make.right.equalTo(cell.contentView).offset(-15);
        make.height.mas_equalTo(50);
    }];
    
    UIView *line = [ZZCustomView viewInitWithView:cell.contentView bgColor:[UIColor im_borderLineColor]];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(20);
        make.top.equalTo(self.tipsTF);
        make.height.mas_equalTo(1);
    }];
    
    self.amountTF = [ZZCustomView textFieldInitFrame:CGRectZero view:cell.contentView placeholder:@"" delegate:self font:GCSFontRegular(27) textColor:[UIColor im_textColor_three] bgColor:nil keyboardType:UIKeyboardTypeDecimalPad];
    [self.amountTF addTarget:self action:@selector(inputTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
    NSString *placeholderStr = @"0";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:placeholderStr];
    [att addAttributes:@{NSForegroundColorAttributeName:COLORFORRGB(0xeaebf6)} range:NSMakeRange(0, placeholderStr.length)];
    self.amountTF.attributedPlaceholder = att;
    [self.amountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(15);
        make.left.equalTo(cell.contentView).offset(20);
        make.right.equalTo(cell.contentView).offset(-20);
        make.bottom.equalTo(line.mas_top).offset(-10);
    }];
    
    if (self.codeInfoModel) {
        self.addrTF.text = self.codeInfoModel.addr;
        self.amountTF.text = self.codeInfoModel.amount;
    }
    return cell;

}
//矿工费cell
- (UITableViewCell *)getMinersfeeCellWithIdentifer:(NSString *)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.text = @"矿工费";
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = GCSFontRegular(15);
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(20);
        make.centerY.equalTo(cell.contentView);
    }];
    
    UIImageView *addrImg = [ZZCustomView imageViewInitView:cell.contentView imageName:@"arrowRightGray"];
    [addrImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-20);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    self.gasPriceLbl = [ZZCustomView labelInitWithView:cell.contentView text:@"0.0000ETH" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(11)];
    self.gasPriceLbl.text = NSStringWithFormat(@"%f %@",self.gasModel.all_gasAmount,[[SettingManager sharedInstance] getChainCoinName]);

    [self.gasPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addrImg.mas_left).offset(-5);
        make.top.equalTo(cell.contentView).offset(13);
    }];
    UILabel *rmbLbl = [ZZCustomView labelInitWithView:cell.contentView text:@"￥0.0" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(11)];
    [rmbLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.gasPriceLbl);
        make.top.equalTo(self.gasPriceLbl.mas_bottom);
    }];

    return cell;

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            
            [UITools makeTableViewRadius:tableView displayCell:cell forRowAtIndexPath:indexPath];
        }
    }
    
}
- (void)inputTextFieldAction:(UITextField *)sender{
//    [self makeStatusWithAddrTF:self.addrTF amountTF:self.amountTF];

}

- (void)makeStatusWithAddrTF:(UITextField *)addr amountTF:(UITextField *)amount{
    if (addr.text.length>0 && amount.text.length>0) {
        self.nextStepBtn.userInteractionEnabled = YES;
        self.nextStepBtn.backgroundColor = [UIColor im_btnSelectColor];
    }else{
        self.nextStepBtn.userInteractionEnabled = NO;
        self.nextStepBtn.backgroundColor = [UIColor im_btnUnSelectColor];
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor navAndTabBackColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
   }
    return _tableView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
