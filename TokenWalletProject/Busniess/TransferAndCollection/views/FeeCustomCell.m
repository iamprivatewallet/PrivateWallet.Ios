//
//  FeeCustomCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/16.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "FeeCustomCell.h"
@interface FeeCustomCell()
<
UITextFieldDelegate
>
@property (nonatomic, strong) UITextField *gasTF;

@property (nonatomic, strong) UILabel *gasPriceTipsLbl;
@property (nonatomic, strong) UILabel *gasTipsLbl;

@property (nonatomic, strong) UIView *priceBg;
@property (nonatomic, strong) UIView *gasBg;

@property (nonatomic, strong) UILabel *gasTitleLbl;

@property(nonatomic, assign) CGFloat priceHighest;
@property(nonatomic, assign) CGFloat gasHighest;

@end
@implementation FeeCustomCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeViews];
    }
    return self;
}

- (void)fillDataWithPriceHighest:(NSString *)price gasHighest:(NSString *)gas{
    self.priceHighest = [price doubleValue];
    self.gasHighest = [gas doubleValue];
    self.gasTF.text = gas;
    if ([self.priceTF.text isEqualToString: @""]) {
        self.gasPriceTipsLbl.hidden = YES;
        [self.gasTitleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(22);
            make.top.equalTo(self.priceBg.mas_bottom).offset(20);
            make.height.mas_equalTo(20);
        }];
    }
}
- (void)makeViews {
    //Gas Price
    UILabel *priceTitle = [ZZCustomView labelInitWithView:self.contentView text:@"Gas Price" textColor:[UIColor im_textColor_six] font:GCSFontRegular(13)];
    [priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(22);
        make.top.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(20);

    }];
    self.priceBg = [ZZCustomView viewInitWithView:self.contentView bgColor:[UIColor navAndTabBackColor]];
    self.self.priceBg.layer.cornerRadius = 8;
    [self.priceBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(priceTitle.mas_bottom).offset(5);
        make.height.mas_equalTo(55);
    }];
    self.priceTF = [ZZCustomView textFieldInitFrame:CGRectZero view:self.priceBg placeholder:@"0" delegate:self font:GCSFontRegular(14) textColor:[UIColor im_textColor_three]];
    self.priceTF.tag = 10;
    [self.priceTF addTarget:self action:@selector(textFieldEditingAction:) forControlEvents:UIControlEventEditingChanged];
   
    [self.priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceBg).offset(20);
        make.right.equalTo(self.priceBg).offset(-55);
        make.top.bottom.equalTo(self.priceBg);
    }];
    
    UILabel *rightLbl = [ZZCustomView labelInitWithView:self.priceBg text:@"GWEI" textColor:[UIColor im_lightGrayColor] font:GCSFontRegular(14)];
    [rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceBg).offset(-20);
        make.centerY.equalTo(self.priceBg);
    }];
    
    //Gas
    self.gasTitleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"Gas" textColor:[UIColor im_textColor_six] font:GCSFontRegular(13)];
    [self.gasTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(22);
        make.top.equalTo(self.priceBg.mas_bottom).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    self.gasBg = [ZZCustomView viewInitWithView:self.contentView bgColor:[UIColor navAndTabBackColor]];
    self.gasBg.layer.cornerRadius = 8;
    [self.gasBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.gasTitleLbl.mas_bottom).offset(5);
        make.height.mas_equalTo(55);
    }];
    self.gasTF = [ZZCustomView textFieldInitFrame:CGRectZero view:self.gasBg placeholder:@"0" delegate:self font:GCSFontRegular(14) textColor:[UIColor im_textColor_three]];
    self.gasTF.tag = 11;
    [self.gasTF addTarget:self action:@selector(textFieldEditingAction:) forControlEvents:UIControlEventEditingChanged];
   
    [self.gasTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gasBg).offset(20);
        make.right.equalTo(self.gasBg).offset(-20);
        make.top.bottom.equalTo(self.gasBg);
    }];
    
    self.gasPriceTipsLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_blueColor] font:GCSFontRegular(13)];
    self.gasTipsLbl = [ZZCustomView labelInitWithView:self.contentView text:@"" textColor:[UIColor im_blueColor] font:GCSFontRegular(13)];
}

- (void)textFieldEditingAction:(UITextField *)sender{
    if (sender.tag == 10) {
        if (sender.text.length>0 ) {
            self.gasPriceTipsLbl.hidden = NO;
            if ([sender.text floatValue]< self.priceHighest) {
                self.gasPriceTipsLbl.text = @"Gas Price 过低，将会影响交易确认时间";
            }else if ([sender.text floatValue]> self.priceHighest){
                self.gasPriceTipsLbl.text = @"Gas Price 过高，将会造成矿工费浪费";
            }else{
                self.gasPriceTipsLbl.hidden = YES;
            }
        }else{
            self.gasPriceTipsLbl.text = @"请输入有效的Gas Price";
        }
        
        if (self.gasPriceTipsLbl.hidden) {
            [self.gasTitleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(22);
                make.top.equalTo(self.priceBg.mas_bottom).offset(20);
                make.height.mas_equalTo(20);
            }];
        }else{
            [self.gasPriceTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(20);
                make.right.equalTo(self.contentView).offset(-20);
                make.top.equalTo(self.priceBg.mas_bottom).offset(10);
                make.height.mas_equalTo(20);

            }];
            [self.gasTitleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(22);
                make.top.equalTo(self.gasPriceTipsLbl.mas_bottom).offset(20);
                make.height.mas_equalTo(20);
            }];
        }

    }else{
        if (sender.text.length>0) {
            self.gasTipsLbl.hidden = NO;
            if ([sender.text floatValue]< self.gasHighest) {
                self.gasTipsLbl.text = @"Gas 过低，请输入有效的Gas";
            }else if ([sender.text floatValue]> self.gasHighest){
                self.gasTipsLbl.text = @"Gas 过高，请输入有效的Gas";
            }else{
                self.gasTipsLbl.hidden = YES;
            }
        }else{
            self.gasTipsLbl.text = @"请输入有效的Gas";
        }
        
        if (!self.gasTipsLbl.hidden) {
            [self.gasBg mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(20);
                make.right.equalTo(self.contentView).offset(-20);
                make.top.equalTo(self.gasTitleLbl.mas_bottom).offset(5);
                make.height.mas_equalTo(55);
            }];
            [self.gasTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(20);
                make.right.equalTo(self.contentView).offset(-20);
                make.top.equalTo(self.gasBg.mas_bottom).offset(10);
                make.height.equalTo(@20);
            }];
        }
       
      
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCustomInfo:)]) {
        [self.delegate getCustomInfo:sender];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
