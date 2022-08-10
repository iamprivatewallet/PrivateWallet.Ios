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

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation PW_AddCustomNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(self.model?@"text_editCustomNetwork":@"text_addCustomNetwork")];
    [self makeViews];
    if (self.model) {
        self.nameTf.text = self.model.title;
        self.rpcUrlTf.text = self.model.rpcUrl;
        self.chainIdTf.text = self.model.chainId;
        self.symbolTf.text = self.model.symbol;
        self.blockBrowserTf.text = self.model.browseUrl;
        self.chainIdTf.enabled = NO;
        self.chainIdTf.textColor = [UIColor g_grayTextColor];
        if (self.model.isDefault) {
            self.nameTf.enabled = self.rpcUrlTf.enabled = self.symbolTf.enabled = self.blockBrowserTf.enabled = NO;
            self.nameTf.textColor = self.rpcUrlTf.textColor = self.symbolTf.textColor = self.blockBrowserTf.textColor = [UIColor g_grayTextColor];
            self.cancelBtn.hidden = self.saveBtn.hidden = YES;
        }
    }
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
    if (self.model) {
        self.model.title = name;
        self.model.rpcUrl = rpcUrl;
        self.model.symbol = symbol;
        self.model.browseUrl = blockBrowser;
        [[PW_NetworkManager shared] updateModel:self.model];
        if (self.saveBlock) {
            self.saveBlock(self.model);
        }
    }else{
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
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeViews {
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [bodyView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [bodyView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
        make.height.greaterThanOrEqualTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    self.nameView = [[UIView alloc] init];
    self.nameView.backgroundColor = [UIColor g_bgCardColor];
    [self.nameView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [self.contentView addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(36);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(84);
    }];
    self.rpcUrlView = [[UIView alloc] init];
    self.rpcUrlView.backgroundColor = [UIColor g_bgCardColor];
    [self.rpcUrlView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [self.contentView addSubview:self.rpcUrlView];
    [self.rpcUrlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(84);
    }];
    self.chainIdView = [[UIView alloc] init];
    self.chainIdView.backgroundColor = [UIColor g_bgCardColor];
    [self.chainIdView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [self.contentView addSubview:self.chainIdView];
    [self.chainIdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rpcUrlView.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(84);
    }];
    self.symbolView = [[UIView alloc] init];
    self.symbolView.backgroundColor = [UIColor g_bgCardColor];
    [self.symbolView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [self.contentView addSubview:self.symbolView];
    [self.symbolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chainIdView.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(84);
    }];
    self.blockBrowserView = [[UIView alloc] init];
    self.blockBrowserView.backgroundColor = [UIColor g_bgCardColor];
    [self.blockBrowserView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [self.contentView addSubview:self.blockBrowserView];
    [self.blockBrowserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.symbolView.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(84);
    }];
    self.warnView = [[UIView alloc] init];
    self.warnView.backgroundColor = [UIColor g_warnBgColor];
    self.warnView.layer.cornerRadius = 8;
    self.warnView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.warnView];
    [self.warnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo(self.blockBrowserView.mas_bottom).offset(30);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    self.cancelBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_cancel") fontSize:18 titleColor:[UIColor g_whiteTextColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(cancelAction)];
    [self.contentView addSubview:self.cancelBtn];
    self.saveBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_save") fontSize:18 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(saveAction)];
    [self.contentView addSubview:self.saveBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.top.equalTo(self.warnView.mas_bottom).offset(18);
        make.height.offset(55);
        make.bottom.offset(-SafeBottomInset-20);
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelBtn.mas_right).offset(28);
        make.top.equalTo(self.cancelBtn);
        make.right.offset(-36);
        make.width.height.equalTo(self.cancelBtn);
    }];
    [self createNameItems];
    [self createRpcUrlItems];
    [self createChainIdItems];
    [self createSymbolItems];
    [self createBlockBrowserItems];
    [self createWarnItems];
}
- (void)createWarnItems {
    UILabel *tipLb = [PW_ViewTool labelText:LocalizedStr(@"text_addCustomNetworkTip") fontSize:14 textColor:[UIColor g_textColor]];
    tipLb.textAlignment = NSTextAlignmentCenter;
    [self.warnView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.offset(18);
        make.right.offset(-30);
        make.bottom.offset(-18);
    }];
}
- (void)createNameItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_networkName") fontSize:20 textColor:[UIColor g_boldTextColor]];
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
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:PW_StrFormat(@"%@PRC URL",LocalizedStr(@"text_added")) fontSize:20 textColor:[UIColor g_boldTextColor]];
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
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:tipStr fontSize:20 textColor:[UIColor g_boldTextColor]];
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
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:tipStr fontSize:20 textColor:[UIColor g_boldTextColor]];
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
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:tipStr fontSize:20 textColor:[UIColor g_boldTextColor]];
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
