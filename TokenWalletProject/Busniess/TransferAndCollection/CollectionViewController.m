//
//  CollectionViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/12.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionShareView.h"
#import "SGQRCode.h"
#import "CustomActivity.h"

@interface CollectionViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *codeTitleLbl;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UIButton *addressBtn;

@property (nonatomic, copy) NSString *amountInputStr;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle_whiteStype:@"收款" rightImg:nil rightAction:nil bgColor:[UIColor im_bgBlueColor]];
    if(self.coinModel==nil) {
        Wallet *wallet = [[WalletManager shareWalletManager] getWalletWithAddress: User_manager.currentUser.chooseWallet_address type:User_manager.currentUser.chooseWallet_type];
        WalletCoinModel *coinModel = [[WalletCoinModel alloc] init];
        coinModel.tokenName = [[SettingManager sharedInstance] getChainCoinName];
        coinModel.tokenAddress = User_manager.currentUser.chooseWallet_address;
        coinModel.icon = NSStringWithFormat(@"icon_%@",User_manager.currentUser.chooseWallet_type);
        coinModel.decimals = 18;
        coinModel.currentWallet = wallet;
        self.coinModel = coinModel;
    }
    [self makeViews];
    // Do any additional setup after loading the view.
}

- (void)makeViews{
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    self.bgView = [ZZCustomView viewInitWithView:self.scrollView bgColor:[UIColor im_bgBlueColor]];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.right.equalTo(self.view);
    }];
    
//    UIView *topView = [ZZCustomView viewInitWithView:self.bgView bgColor:COLORFORRGB(0x2995b7)];
//    topView.layer.borderColor = COLORFORRGB(0x529da3).CGColor;
//    topView.layer.borderWidth = 1;
//    topView.layer.cornerRadius = 13;
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bgView).offset(CGFloatScale(25));
//        make.left.equalTo(self.bgView).offset(CGFloatScale(20));
//        make.right.equalTo(self.bgView).offset(-CGFloatScale(20));
//        make.height.mas_equalTo(40);
//    }];
//    UIImageView *iconImg = [[UIImageView alloc] initWithImage:ImageNamed(@"backupWarnning")];
//    [topView addSubview:iconImg];
//    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(topView).offset(12);
//        make.width.height.mas_equalTo(12);
//        make.centerY.equalTo(topView);
//    }];
//    UILabel *titleLbl = [ZZCustomView labelInitWithView:topView text:NSStringWithFormat(@"该地址仅支持%@资产，请勿转入其他公链资产",self.coinModel.currentWallet.type) textColor:[UIColor im_yellowColorAlpha:1] font:GCSFontSemibold(12)];
//    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(iconImg.mas_right).offset(CGFloatScale(4));
//        make.centerY.equalTo(topView);
//    }];
    
    [self makeGrayBgView];

}

- (void)makeGrayBgView{
    
    UIView *grayBgView = [ZZCustomView viewInitWithView:self.bgView bgColor:COLORFORRGB(0xf3f6f9)];
    grayBgView.layer.cornerRadius = 15;
    [grayBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(CGFloatScale(25));
        make.left.equalTo(self.bgView).offset(CGFloatScale(20));
        make.right.equalTo(self.bgView).offset(-CGFloatScale(20));
        make.bottom.equalTo(self.bgView).offset(-CGFloatScale(80));
    }];
    //白色内容布局
    [self makeWhiteViewsWithBgView:grayBgView];

    UIButton *moreBtn = [ZZCustomView buttonInitWithView:grayBgView imageName:@"detailDark"];
    moreBtn.tag = 3;
    [moreBtn addTarget:self action:@selector(grayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(grayBgView);
        make.height.mas_equalTo(CGFloatScale(60));
        make.width.mas_equalTo(CGFloatScale(60));
    }];

    UIView *line1 = [ZZCustomView viewInitWithView:grayBgView bgColor:[UIColor mp_lineGrayColor]];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moreBtn.mas_left);
        make.height.mas_equalTo(CGFloatScale(17));
        make.width.mas_equalTo(CGFloatScale(1));
        make.centerY.equalTo(moreBtn);
    }];
    
    UIButton *copyBtn = [ZZCustomView buttonInitWithView:grayBgView title:@"  复制" titleColor:[UIColor im_textLightGrayColor] titleFont:GCSFontRegular(14)];
    copyBtn.tag = 2;
    [copyBtn addTarget:self action:@selector(grayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn setImage:ImageNamed(@"copy-gray") forState:UIControlStateNormal];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(grayBgView);
        make.right.equalTo(moreBtn.mas_left);
        make.height.equalTo(moreBtn);
        make.width.mas_equalTo((ScreenWidth-CGFloatScale(100))/2);
    }];
    
    UIView *line2 = [ZZCustomView viewInitWithView:grayBgView bgColor:[UIColor mp_lineGrayColor]];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(copyBtn.mas_left);
        make.height.mas_equalTo(CGFloatScale(17));
        make.width.mas_equalTo(CGFloatScale(0.7));
        make.centerY.equalTo(moreBtn);
    }];
    
    UIButton *shareBtn = [ZZCustomView buttonInitWithView:grayBgView title:@"  分享" titleColor:[UIColor im_textLightGrayColor] titleFont:GCSFontRegular(14)];
    shareBtn.tag = 1;
    [shareBtn setImage:ImageNamed(@"share-gray") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(grayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(grayBgView);
        make.width.equalTo(copyBtn);
        make.height.equalTo(moreBtn);
        make.right.equalTo(copyBtn.mas_left);
    }];
}

- (void)makeWhiteViewsWithBgView:(UIView *)bgView{
    UIView *whiteBg = [ZZCustomView viewInitWithView:bgView bgColor:[UIColor whiteColor]];
    whiteBg.layer.cornerRadius = 15;
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(-CGFloatScale(62));
    }];
    NSString *titleStr = NSStringWithFormat(@"扫二维码，转入 %@",self.coinModel.tokenName);
    self.codeTitleLbl = [ZZCustomView labelInitWithView:whiteBg text:titleStr textColor:[UIColor im_lightGrayColor] font:GCSFontRegular(14) textAlignment:NSTextAlignmentCenter];
    [self.codeTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteBg).offset(CGFloatScale(40));
        make.centerX.equalTo(whiteBg);
    }];
    self.codeImageView = [[UIImageView alloc] init];
    NSString *str;
    if (![self.coinModel.currentWallet.address isEqualToString:self.coinModel.tokenAddress]) {
        str = NSStringWithFormat(@"ethereum:%@?contractAddress=%@&value=0",self.coinModel.currentWallet.address,self.coinModel.tokenAddress);
    }else{
        str = NSStringWithFormat(@"ethereum:%@?value=0",self.coinModel.currentWallet.address);
    }
    NSString *json = [CATCommon JSONString:str];
    UIImage *image = [SGQRCodeObtain generateQRCodeWithData:json size:180];
    self.codeImageView.image = image;
    [whiteBg addSubview:self.codeImageView];
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTitleLbl.mas_bottom).offset(CGFloatScale(40));
        make.width.height.mas_equalTo(180);
        make.centerX.equalTo(whiteBg);
    }];
    UIImageView *topLeftImg = [ZZCustomView imageViewInitView:whiteBg imageName:@"cornerLeftTop"];
    [topLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(26);
        make.centerX.equalTo(self.codeImageView.mas_left);
        make.centerY.equalTo(self.codeImageView.mas_top);
    }];
    
    UIImageView *topRightImg = [ZZCustomView imageViewInitView:whiteBg imageName:@"cornerRightTop"];
    [topRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(topLeftImg);
        make.centerX.equalTo(self.codeImageView.mas_right);
        make.centerY.equalTo(self.codeImageView.mas_top);
    }];
    
    UIImageView *bottomLeftImg = [ZZCustomView imageViewInitView:whiteBg imageName:@"cornerLeftBottom"];
    [bottomLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(topLeftImg);
        make.centerX.equalTo(self.codeImageView.mas_left);
        make.centerY.equalTo(self.codeImageView.mas_bottom);
    }];
    UIImageView *bottomRightImg = [ZZCustomView imageViewInitView:whiteBg imageName:@"cornerRightBottom"];
    [bottomRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(topLeftImg);
        make.centerX.equalTo(self.codeImageView.mas_right);
        make.centerY.equalTo(self.codeImageView.mas_bottom);
    }];
    
    UILabel *addrLbl = [ZZCustomView labelInitWithView:whiteBg text:@"钱包地址" textColor:[UIColor im_lightGrayColor] font:GCSFontRegular(13)];
    [addrLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeImageView.mas_bottom).offset(CGFloatScale(50));
        make.centerX.equalTo(whiteBg);
    }];
    
    self.addressBtn = [ZZCustomView im_buttonInitWithView:whiteBg title:self.coinModel.currentWallet.address titleFont:GCSFontRegular(15) titleColor:[UIColor im_textColor_three] isHighlighted:YES];
    self.addressBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.addressBtn addTarget:self action:@selector(addressBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addrLbl.mas_bottom).offset(10);
        make.left.equalTo(whiteBg).offset(CGFloatScale(30));
        make.right.equalTo(whiteBg).offset(-CGFloatScale(30));
        make.bottom.equalTo(whiteBg).offset(-CGFloatScale(40));
    }];
    
}
- (void)addressBtnAction{
    //地址复制
    [UITools pasteboardWithStr:self.coinModel.currentWallet.address toast:@"钱包地址已复制"];
}
- (void)grayButtonAction:(UIButton *)sender{
    if (sender.tag == 1) {
        //分享
        [CollectionShareView showShareViewWithInfo:self.coinModel.currentWallet amount:self.amountInputStr shareAction:^{
            [self activityShare];
        }];
    }else if (sender.tag == 2) {
        //复制
        //地址复制
        [UITools pasteboardWithStr:self.coinModel.currentWallet.address toast:@"钱包地址已复制"];
    }else{
        //收款金额
        [WarningAlertSheetView showClickViewWithItems:@[@"收款金额"] action:^(NSInteger index) {
            [TokenAlertView showViewWithTitle:@"设置收款金额" textField_p:@"请输入收款金额" keyboardType:UIKeyboardTypeDecimalPad action:^(NSInteger index, NSString * _Nonnull inputText) {
                if (![UITools isNumber:inputText] || !inputText) {
                    return [self showAlertViewWithTitle:@"验证错误" text:@"转账金额不正确" actionText:@"好"];
                }
                self.amountInputStr = inputText;
                if (index == 1) {
                    [self updateCodeInfo];
                }
            }];
        }];
    }
}
- (void)updateCodeInfo {
    NSString *str;
    if (![self.coinModel.currentWallet.address isEqualToString:self.coinModel.tokenAddress]) {
        str = NSStringWithFormat(@"ethereum:%@?contractAddress=%@&value=%@",self.coinModel.currentWallet.address,self.coinModel.tokenAddress,self.amountInputStr);
    }else{
        str = NSStringWithFormat(@"ethereum:%@?value=%@",self.coinModel.currentWallet.address,self.amountInputStr);
    }
    NSString *json = [CATCommon JSONString:str];
    UIImage *image = [SGQRCodeObtain generateQRCodeWithData:json size:180];
    self.codeImageView.image = image;
    self.codeTitleLbl.text = NSStringWithFormat(@"扫二维码，转入 %@ %@",self.amountInputStr,self.coinModel.tokenName);
}
- (void)activityShare{
    // 1、设置分享的内容，并将内容添加到数组中
    NSString *shareText = self.coinModel.currentWallet.address;
    UIImage *shareImage = [UIImage imageNamed:@"logo"];
    NSURL *shareUrl = [NSURL URLWithString:WalletWebSiteUrl];
    NSArray *activityItemsArray = @[shareText,shareImage,shareUrl];
    
    // 自定义的CustomActivity，继承自UIActivity
    CustomActivity *customActivity = [[CustomActivity alloc]initWithTitle:shareText ActivityImage:[UIImage imageNamed:@"logo"] URL:shareUrl ActivityType:@"Custom"];
    NSArray *activityArray = @[customActivity];
    
    // 2、初始化控制器，添加分享内容至控制器
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:activityArray];
    activityVC.modalInPopover = YES;
    // 3、设置回调
    UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        NSLog(@"activityType == %@",activityType);
        if (completed == YES) {
            NSLog(@"completed");
        }else{
            NSLog(@"cancel");
        }
    };
    activityVC.completionWithItemsHandler = itemsBlock;
    
    // 4、调用控制器
    [self presentViewController:activityVC animated:YES completion:nil];
    
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor im_bgBlueColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
    }
    return _scrollView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
