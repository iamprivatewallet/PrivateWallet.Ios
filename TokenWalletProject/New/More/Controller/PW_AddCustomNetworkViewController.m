//
//  PW_AddCustomNetworkViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddCustomNetworkViewController.h"

@interface PW_AddCustomNetworkViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *warnView;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UITextField *nameTf;
@property (nonatomic, strong) UIView *rpcUrlView;
@property (nonatomic, strong) UITextField *rpcUrlTf;
@property (nonatomic, strong) UIView *chainIdView;
@property (nonatomic, strong) UITextField *chainIdTf;
@property (nonatomic, strong) UIView *symbolView;
@property (nonatomic, strong) UITextField *symbolTf;
@property (nonatomic, strong) UIView *blockBrowserView;
@property (nonatomic, strong) UITextField *blockBrowserTf;

@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation PW_AddCustomNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_addCustomNetwork")];
    [self makeViews];
    RAC(self.saveBtn,enabled) = [RACSignal combineLatest:@[self.nameTf.rac_textSignal,self.rpcUrlTf.rac_textSignal,self.chainIdTf.rac_textSignal] reduce:^id(NSString *name,NSString *rpcUrl,NSString *chainId){
        return @([name trim].length>0&&[rpcUrl trim].length>0&&[chainId trim].length>0);
    }];
}
- (void)cancelAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveAction {
    NSString *name = self.nameTf.text;
    NSString *rpcUrl = self.rpcUrlTf.text;
    NSString *chainId = self.chainIdTf.text;
    NSString *symbol = self.symbolTf.text;
    NSString *blockBrowser = self.blockBrowserTf.text;
    if (![name isNoEmpty]) {
        [self showError:PW_StrFormat(@"%@ %@",LocalizedStr(@"text_networkName"),LocalizedStr(@"text_error"))];
        return;
    }
    if (![rpcUrl isHttpsURL]) {
        [self showError:PW_StrFormat(@"RPC URL %@",LocalizedStr(@"text_error"))];
        return;
    }
    if (![chainId isInt]) {
        [self showError:PW_StrFormat(@"%@ID %@",LocalizedStr(@"text_chain"),LocalizedStr(@"text_error"))];
        return;
    }
    if ([[PW_NetworkManager shared] isExistWithChainId:chainId]) {
        [self showError:PW_StrFormat(@"%@ID %@",LocalizedStr(@"text_chain"),LocalizedStr(@"text_alreadyExist"))];
        return;
    }
    PW_NetworkModel *model = [[PW_NetworkModel alloc] init];
    model.sortIndex = [[PW_NetworkManager shared] getMaxIndex]+1;
    model.title = name;
    model.rpcUrl = rpcUrl;
    model.chainId = chainId;
    model.symbol = symbol;
    model.browseUrl = blockBrowser;
    [[PW_NetworkManager shared] saveModel:model];
    if (self.saveBlock) {
        self.saveBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(-SafeBottomInset);
    }];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.width.equalTo(scrollView);
    }];
    self.warnView = [[UIView alloc] init];
    self.warnView.backgroundColor = [UIColor g_warnBgColor];
    self.warnView.layer.cornerRadius = 12;
    self.warnView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.warnView];
    [self.warnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(20);
        make.right.offset(-20);
    }];
    self.nameView = [[UIView alloc] init];
    self.nameView.backgroundColor = [UIColor g_bgColor];
    [self.nameView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [self.nameView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.warnView.mas_bottom).offset(15);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(84);
    }];
    self.rpcUrlView = [[UIView alloc] init];
    self.rpcUrlView.backgroundColor = [UIColor g_bgColor];
    [self.rpcUrlView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [self.rpcUrlView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.rpcUrlView];
    [self.rpcUrlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom).offset(15);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(84);
    }];
    self.chainIdView = [[UIView alloc] init];
    self.chainIdView.backgroundColor = [UIColor g_bgColor];
    [self.chainIdView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [self.chainIdView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.chainIdView];
    [self.chainIdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rpcUrlView.mas_bottom).offset(15);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(84);
    }];
    self.symbolView = [[UIView alloc] init];
    self.symbolView.backgroundColor = [UIColor g_bgColor];
    [self.symbolView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [self.symbolView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.symbolView];
    [self.symbolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chainIdView.mas_bottom).offset(15);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(84);
    }];
    self.blockBrowserView = [[UIView alloc] init];
    self.blockBrowserView.backgroundColor = [UIColor g_bgColor];
    [self.blockBrowserView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [self.blockBrowserView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.blockBrowserView];
    [self.blockBrowserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.symbolView.mas_bottom).offset(15);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(84);
    }];
    UIButton *cancelBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_cancel") fontSize:16 titleColor:[UIColor g_boldTextColor] cornerRadius:16 backgroundColor:nil target:self action:@selector(cancelAction)];
    [cancelBtn setBorderColor:[UIColor g_boldTextColor] width:1 radius:16];
    [self.contentView addSubview:cancelBtn];
    self.saveBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_save") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(saveAction)];
    [self.contentView addSubview:self.saveBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.top.equalTo(self.blockBrowserView.mas_bottom).offset(30);
        make.height.offset(55);
        make.bottom.offset(-20);
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelBtn.mas_right).offset(15);
        make.top.equalTo(cancelBtn);
        make.right.offset(-25);
        make.width.equalTo(cancelBtn);
        make.height.offset(55);
    }];
    [self createWarnItems];
    [self createNameItems];
    [self createRpcUrlItems];
    [self createChainIdItems];
    [self createSymbolItems];
    [self createBlockBrowserItems];
}
- (void)createWarnItems {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_warning"]];
    [self.warnView addSubview:iconIv];
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_addCustomNetworkTip") fontSize:12 textColor:[UIColor g_warnColor]];
    [self.warnView addSubview:tipLb];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(14);
    }];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIv.mas_right).offset(12);
        make.top.offset(12);
        make.right.offset(-10);
        make.bottom.offset(-12);
    }];
}
- (void)createNameItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_networkName") fontSize:13 textColor:[UIColor g_boldTextColor]];
    [self.nameView addSubview:tipLb];
    self.nameTf = [PW_ViewTool textFieldFont:[UIFont pw_mediumFontOfSize:16] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_networkName")];
    [self.nameView addSubview:self.nameTf];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(10);
    }];
    [self.nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.height.offset(45);
        make.bottom.offset(-10);
    }];
}
- (void)createRpcUrlItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:PW_StrFormat(@"%@PRC URL",LocalizedStr(@"text_added")) fontSize:13 textColor:[UIColor g_boldTextColor]];
    [self.rpcUrlView addSubview:tipLb];
    self.rpcUrlTf = [PW_ViewTool textFieldFont:[UIFont pw_mediumFontOfSize:16] color:[UIColor g_textColor] placeholder:@"PRC URL"];
    self.rpcUrlTf.keyboardType = UIKeyboardTypeURL;
    [self.rpcUrlView addSubview:self.rpcUrlTf];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(10);
    }];
    [self.rpcUrlTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.height.offset(45);
        make.bottom.offset(-10);
    }];
}
- (void)createChainIdItems {
    NSString *tipStr = PW_StrFormat(@"%@ID",LocalizedStr(@"text_chain"));
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:tipStr fontSize:13 textColor:[UIColor g_boldTextColor]];
    [self.chainIdView addSubview:tipLb];
    self.chainIdTf = [PW_ViewTool textFieldFont:[UIFont pw_mediumFontOfSize:16] color:[UIColor g_textColor] placeholder:tipStr];
    self.chainIdTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.chainIdView addSubview:self.chainIdTf];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(10);
    }];
    [self.chainIdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.height.offset(45);
        make.bottom.offset(-10);
    }];
}
- (void)createSymbolItems {
    NSString *tipStr = LocalizedStr(@"text_tokenSymbol");
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:tipStr fontSize:13 textColor:[UIColor g_boldTextColor]];
    [self.symbolView addSubview:tipLb];
    UILabel *descLb = [PW_ViewTool labelSemiboldText:PW_StrFormat(@"（%@）",LocalizedStr(@"text_optional")) fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.symbolView addSubview:descLb];
    self.symbolTf = [PW_ViewTool textFieldFont:[UIFont pw_mediumFontOfSize:16] color:[UIColor g_textColor] placeholder:tipStr];
    self.symbolTf.keyboardType = UIKeyboardTypeAlphabet;
    [self.symbolView addSubview:self.symbolTf];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(10);
    }];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLb.mas_right);
        make.centerY.equalTo(tipLb);
    }];
    [self.symbolTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.height.offset(45);
        make.bottom.offset(-10);
    }];
}
- (void)createBlockBrowserItems {
    NSString *tipStr = LocalizedStr(@"text_blockBrowser");
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:tipStr fontSize:13 textColor:[UIColor g_boldTextColor]];
    [self.blockBrowserView addSubview:tipLb];
    UILabel *descLb = [PW_ViewTool labelSemiboldText:PW_StrFormat(@"（%@）",LocalizedStr(@"text_optional")) fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.blockBrowserView addSubview:descLb];
    self.blockBrowserTf = [PW_ViewTool textFieldFont:[UIFont pw_mediumFontOfSize:16] color:[UIColor g_textColor] placeholder:tipStr];
    self.blockBrowserTf.keyboardType = UIKeyboardTypeURL;
    [self.blockBrowserView addSubview:self.blockBrowserTf];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(10);
    }];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLb.mas_right);
        make.centerY.equalTo(tipLb);
    }];
    [self.blockBrowserTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.height.offset(45);
        make.bottom.offset(-10);
    }];
}

@end
