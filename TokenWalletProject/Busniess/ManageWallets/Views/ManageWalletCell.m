//
//  ManageWalletCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/29.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ManageWalletCell.h"
@interface ManageWalletCell()
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UIImageView *spotImg;
@property (nonatomic, strong) UIView *circleCheck;

@property(nonatomic, assign) BOOL isChoose;

@end
@implementation ManageWalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isChooseWallet:(BOOL)isChoose
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isChoose = isChoose;
        [self makeViews:isChoose];
    }
    return self;
}
- (void)setViewWithData:(id)data{
    if (data && [data isKindOfClass:[Wallet class]]) {
        Wallet *wallet = (Wallet *)data;
        if ([wallet.type isEqualToString:@"ETH"]) {
            self.iconImg.image = ImageNamed(@"icon_e_logo");
            self.bgView.backgroundColor = COLORFORRGB(0x377AAE);
        }else if([wallet.type isEqualToString:@"BSC"]){
            self.iconImg.image = ImageNamed(@"icon_b_logo");
            self.bgView.backgroundColor = COLORFORRGB(0xFBCD2A);
        }else if([wallet.type isEqualToString:@"HECO"]) {
            self.iconImg.image = ImageNamed(@"icon_h_logo");
            self.backgroundColor = COLORFORRGB(0x2CB171);
        }else{
            self.iconImg.image = ImageNamed(@"icon_h_logo");
            self.bgView.backgroundColor = COLORFORRGB(0x1CAA50);
        }
        self.titleLbl.text = wallet.walletName;
        self.addressLbl.text = wallet.address;
        
        if (self.isChoose) {
            NSString *addr = User_manager.currentUser.chooseWallet_address;
            NSString *type = User_manager.currentUser.chooseWallet_type;

            if ([wallet.address isEqualToString:addr] && [wallet.type isEqualToString:type]) {
                self.circleCheck.hidden = NO;
            }else{
                self.circleCheck.hidden = YES;
            }
        }
    }
    
}
- (void)makeViews:(BOOL)isChoose{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.bgView = [[UIView alloc] init];
    self.bgView.layer.cornerRadius = 10;
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(CGFloatScale(15));
        make.right.equalTo(self.contentView).offset(-CGFloatScale(15));
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-CGFloatScale(10));
    }];
    
    self.titleLbl = [ZZCustomView labelInitWithView:self.bgView text:@"" textColor:[UIColor whiteColor] font:GCSFontSemibold(16)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(CGFloatScale(20));
        make.top.equalTo(self.bgView).offset(CGFloatScale(12));
    }];
    
    self.addressLbl = [ZZCustomView labelInitWithView:self.bgView text:@"" textColor:[UIColor colorWithWhite:1 alpha:0.6] font:GCSFontRegular(13)];
    self.addressLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.top.equalTo(self.titleLbl.mas_bottom);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(18);
    }];
    
    if (isChoose) {
        //选择钱包view
        self.circleCheck = [[UIView alloc] init];
        self.circleCheck.layer.borderColor = [UIColor whiteColor].CGColor;
        self.circleCheck.layer.borderWidth = 2.5;
        self.circleCheck.layer.cornerRadius = 5;
        [self.bgView addSubview:self.circleCheck];
        [self.circleCheck mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView).offset(-8);
            make.top.equalTo(self.bgView).offset(8);
            make.width.height.mas_equalTo(10);
        }];
        self.circleCheck.hidden = YES;

    }else{
        //管理钱包view
        self.spotImg = [[UIImageView alloc] initWithImage:ImageNamed(@"detail")];
        [self.bgView addSubview:self.spotImg];
        [self.spotImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView).offset(-20);
            make.top.equalTo(self.bgView).offset(12);
            make.width.height.mas_equalTo(19);
        }];
    }
    UIImage *icon = ImageNamed(@"icon_e_logo");
    self.iconImg = [[UIImageView alloc] init];
    [self.bgView addSubview:self.iconImg];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat icon_w = icon.size.width*(self.height-10)/icon.size.height;
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self.bgView);
            make.width.mas_equalTo(icon_w);
            make.bottom.equalTo(self.bgView);
        }];
    });
    
    
}
- (void)spotBtnAction{
    
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
