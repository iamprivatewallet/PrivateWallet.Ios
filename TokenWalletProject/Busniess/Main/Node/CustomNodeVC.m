//
//  CustomNodeVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/9/1.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "CustomNodeVC.h"

@interface CustomNodeVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *netNameTF;
@property (nonatomic, strong) UITextField *RPCTF;
@property (nonatomic, strong) UITextField *chainIDTF;
@property (nonatomic, strong) UITextField *symbolTF;
@property (nonatomic, strong) UITextField *browserTF;

@end

@implementation CustomNodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"自定义节点" rightTitle:@"保存" rightAction:@selector(rightNavItemAction) isNoLine:YES];
    self.rightBtn.userInteractionEnabled = NO;
    [self.rightBtn setTitleColor:[UIColor im_lightGrayColor] forState:UIControlStateNormal];
    
    [self makeViews];
    
    // Do any additional setup after loading the view.
}

- (void)rightNavItemAction{
    NSString *rpcUrl = self.RPCTF.text;
    if(![rpcUrl hasPrefix:@"https://"]){
        [UITools showToastHelperWithText:@"只支持https链接!"];
        return;
    }
    //保存
    NSDictionary *dic = @{
        @"node_name":self.netNameTF.text,
        @"node_url":rpcUrl,
        @"node_chainID":self.chainIDTF.text,
        @"node_symbol":self.symbolTF.text,
        @"node_browser":self.browserTF.text,
    };
    [[SettingManager sharedInstance] addNode:dic];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, SCREEN_HEIGHT);
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.mas_equalTo(ScreenWidth);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.bottom.equalTo(self.view);
    }];
    
    UIView *contentView = [ZZCustomView viewInitWithView:self.scrollView bgColor:[UIColor navAndTabBackColor]];
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.top.equalTo(self.scrollView);
        make.left.right.equalTo(self.view);
    }];

    NSArray *titleList = @[@"网络名称",@"RPC地址",@"Chain ID",@"Symbol",@"区块浏览器"];
    UIView *lastView = nil;
    for (int i = 0; i<titleList.count; i++) {
        UIView *bgView = [ZZCustomView viewInitWithView:contentView bgColor:[UIColor whiteColor]];
        bgView.layer.cornerRadius = 9;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(20);
            make.right.equalTo(contentView).offset(-20);
            make.top.equalTo(lastView?lastView.mas_bottom:contentView).offset(40);
            make.height.equalTo(@50);
        }];
        
        UITextField *tf = [[UITextField alloc] init];
        [tf addTarget:self action:@selector(nodeEditingAction:) forControlEvents:UIControlEventEditingChanged];
        tf.textColor = [UIColor im_textColor_three];
        tf.font = GCSFontRegular(12);
        if (i == titleList.count -1 || i == titleList.count -2) {
            tf.placeholder = @"选填";
        }
        if (i == 0) {
            self.netNameTF = tf;
        }else if (i == 1) {
            self.RPCTF = tf;
        }else if (i == 2) {
            self.chainIDTF = tf;
        }else if (i == 3) {
            self.symbolTF = tf;
        }else if (i == 4) {
            self.browserTF = tf;
        }
        [bgView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(15);
            make.right.equalTo(bgView).offset(-15);
            make.top.bottom.equalTo(bgView);
        }];
        
        UILabel *titleLbl = [ZZCustomView labelInitWithView:contentView text:titleList[i] textColor:[UIColor im_textColor_three] font:GCSFontRegular(13)];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(25);
            make.bottom.equalTo(bgView.mas_top).offset(-5);
        }];
        
        if (i == titleList.count-1) {
            UILabel *titleLbl = [ZZCustomView labelInitWithView:contentView text:titleList[i] textColor:[UIColor im_textColor_nine] font:GCSFontRegular(13)];
            [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentView).offset(25);
                make.top.equalTo(bgView.mas_bottom).offset(10);
                make.bottom.equalTo(contentView).offset(-50);
            }];
            titleLbl.text = @"部分服务可能由于自定义节点服务导致不可用";
        }
        
        lastView = bgView;
    }
}

- (void)nodeEditingAction:(UITextField *)sender{
    if (self.netNameTF.text.length>0 && self.RPCTF.text.length>0 && self.chainIDTF.text.length>0) {
        self.rightBtn.userInteractionEnabled = YES;
        [self.rightBtn setTitleColor:[UIColor im_btnSelectColor] forState:UIControlStateNormal];
    }else{
        self.rightBtn.userInteractionEnabled = NO;
        [self.rightBtn setTitleColor:[UIColor im_lightGrayColor] forState:UIControlStateNormal];
    }
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
