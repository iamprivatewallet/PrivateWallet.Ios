//
//  PW_AddContactViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddContactViewController.h"
#import "PW_ScanTool.h"
#import "PW_ChooseAddressTypeViewController.h"

@interface PW_AddContactViewController ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *tokenView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *subNameLb;

@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UITextField *nameTf;
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UITextField *addressTf;
@property (nonatomic, strong) UIView *noteView;
@property (nonatomic, strong) UITextField *noteTf;

@property (nonatomic, strong) PW_ChooseAddressTypeModel *typeModel;

@end

@implementation PW_AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_addContact")];
    self.typeModel = [PW_ChooseAddressTypeModel IconName:@"icon_type_CVN" title:@"ETH" subTitle:@"Ethereum" chainId:kETHChainId selected:YES];
    [self makeViews];
    [self refreshUI];
}
- (void)changeTypeAction {
    PW_ChooseAddressTypeViewController *vc = [[PW_ChooseAddressTypeViewController alloc] init];
    vc.selectedChainId = self.typeModel.chainId;
    vc.chooseBlock = ^(PW_ChooseAddressTypeModel * _Nonnull model) {
        self.typeModel = model;
        [self refreshUI];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scanAction {
    [[PW_ScanTool shared] showScanWithResultBlock:^(NSString * _Nonnull result) {
        self.addressTf.text = result;
    }];
}
- (void)saveAction {
    NSString *name = [self.nameTf.text trim];
    if (![name isNoEmpty]||name.length>20) {
        [self showError:LocalizedStr(@"text_error")];
        return;
    }
    NSString *address = [self.addressTf.text trim];
    if (![address isContract]) {
        [self showError:LocalizedStr(@"text_addressError")];
        return;
    }
    NSString *note = [self.noteTf.text trim];
    PW_AddressBookModel *model = [[PW_AddressBookModel alloc] init];
    model.name = name;
    model.address = address;
    model.note = note;
    model.chainId = self.typeModel.chainId;
    model.chainName = self.typeModel.title;
    model.time = [[NSDate date] timeIntervalSince1970];
    [[PW_AddressBookManager shared] saveModel:model];
    [self showSuccess:LocalizedStr(@"text_saveSuccess")];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.saveBlock) {
        self.saveBlock(model);
    }
}
- (void)refreshUI {
    self.iconIv.image = [UIImage imageNamed:self.typeModel.iconName];
    self.nameLb.text = self.typeModel.title;
    self.subNameLb.text = self.typeModel.subTitle;
}
- (void)makeViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor g_bgColor];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
        make.height.greaterThanOrEqualTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    self.tokenView = [[UIView alloc] init];
    self.tokenView.backgroundColor = [UIColor g_bgCardColor];
    [self.tokenView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [self.tokenView addTapTarget:self action:@selector(changeTypeAction)];
    [self.contentView addSubview:self.tokenView];
    [self.tokenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(36);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(65);
    }];
    self.nameView = [[UIView alloc] init];
    self.nameView.backgroundColor = [UIColor g_bgCardColor];
    [self.nameView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [self.contentView addSubview:self.nameView];
    self.addressView = [[UIView alloc] init];
    self.addressView.backgroundColor = [UIColor g_bgCardColor];
    [self.addressView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [self.contentView addSubview:self.addressView];
    self.noteView = [[UIView alloc] init];
    self.noteView.backgroundColor = [UIColor g_bgCardColor];
    [self.noteView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [self.contentView addSubview:self.noteView];
    UIButton *saveBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_save") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(saveAction)];
    [self.contentView addSubview:saveBtn];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tokenView.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(84);
    }];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(84);
    }];
    [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(84);
    }];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.noteView.mas_bottom).offset(25);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(55);
        make.bottomMargin.offset(-20);
    }];
    [self createTokenItems];
    [self createNameItems];
    [self createAddressItems];
    [self createNoteItems];
    [self.contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
}
- (void)createTokenItems {
    self.iconIv = [[UIImageView alloc] init];
    [self.tokenView addSubview:self.iconIv];
    self.nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    [self.tokenView addSubview:self.nameLb];
    self.subNameLb = [PW_ViewTool labelMediumText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.tokenView addSubview:self.subNameLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [self.tokenView addSubview:arrowIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tokenView.mas_left).offset(35);
        make.centerY.offset(0);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(70);
        make.bottom.equalTo(self.tokenView.mas_centerY);
    }];
    [self.subNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.tokenView.mas_centerY);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-18);
    }];
}
- (void)createNameItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_name") fontSize:20 textColor:[UIColor g_textColor]];
    [self.nameView addSubview:tipLb];
    self.nameTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_setup")];
    [self.nameView addSubview:self.nameTf];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(10);
    }];
    [self.nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(32);
        make.left.offset(18);
        make.right.offset(-15);
        make.bottom.offset(-10);
    }];
}
- (void)createAddressItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_walletAddress") fontSize:20 textColor:[UIColor g_textColor]];
    [self.addressView addSubview:tipLb];
    self.addressTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_inputCopyAddress")];
    [self.addressView addSubview:self.addressTf];
    UIButton *scanBtn = [PW_ViewTool buttonImageName:@"icon_scan" target:self action:@selector(scanAction)];
    [self.addressView addSubview:scanBtn];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(10);
    }];
    [self.addressTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(32);
        make.left.offset(18);
        make.right.offset(-18);
        make.bottom.offset(-10);
    }];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.top.offset(12);
    }];
}
- (void)createNoteItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_note") fontSize:20 textColor:[UIColor g_textColor]];
    [self.noteView addSubview:tipLb];
    self.noteTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_optional")];
    [self.noteView addSubview:self.noteTf];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(10);
    }];
    [self.noteTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(32);
        make.left.offset(18);
        make.right.offset(-15);
        make.bottom.offset(-10);
    }];
}

@end
