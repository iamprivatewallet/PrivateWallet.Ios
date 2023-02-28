//
//  PW_NFTDetailViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/4.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTDetailViewController.h"
#import "PW_NFTDetailHeaderView.h"
#import "PW_NFTDetailDataSectionHeaderView.h"
#import "PW_NFTDetailOfferSectionHeaderView.h"
#import "PW_NFTDetailDealSectionHeaderView.h"
#import "PW_NFTDetailPropertyCell.h"
#import "PW_NFTDetailOfferCell.h"
#import "PW_NFTDetailDealCell.h"
#import "PW_PendingAlertViewController.h"
#import "PW_BidNFTAlertViewController.h"
#import "PW_ConfirmPurchaseNFTAlertViewController.h"
#import "PW_ConfirmNFTAlertViewController.h"
#import "PW_OfferNFTAlertViewController.h"
#import "PW_TransferNFTAlertViewController.h"
#import "PW_PutawaySellNFTAlertViewController.h"
#import "PW_PutawayAuctionNFTAlertViewController.h"
#import "PW_DappAlertTool.h"
#import "PW_NFTDetailModel.h"
#import "PW_ShareAppTool.h"
#import "PW_Web3Test.h"

@interface PW_NFTDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) PW_NFTDetailHeaderView *headerView;
@property (nonatomic, assign) NSInteger segmentIndex;
@property (nonatomic, strong) UIView *bottomView;
//visitor
@property (nonatomic, strong) UIButton *approveBtn;
@property (nonatomic, strong) UIButton *offerBtn;//报价
@property (nonatomic, strong) UIButton *buyBtn;//购买
@property (nonatomic, strong) UIButton *cancelOfferBtn;//撤回报价
@property (nonatomic, strong) UIButton *updateOfferBtn;//更新报价
//owner
@property (nonatomic, strong) UIButton *withdrawBtn;//撤回
@property (nonatomic, strong) UIButton *transferBtn;//转让
@property (nonatomic, strong) UIButton *ownerOfferBtn;//报价
@property (nonatomic, strong) UIView *groupBtnView;
@property (nonatomic, strong) UIButton *leaseBtn;//出租
@property (nonatomic, strong) UIButton *sellBtn;//出售
@property (nonatomic, strong) UIButton *auctionBtn;//竞拍

@property (nonatomic, strong) PW_NFTDetailModel *detailModel;

@property (nonatomic, strong) PW_GasToolModel *gasToolModel;
@property (nonatomic, assign) BOOL isApproved;

@end

@implementation PW_NFTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self clearBackground];
    [self makeViews];
    __weak typeof(self) weakSelf = self;
    [RACObserve(self.bottomView, hidden) subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue) {
            weakSelf.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10+PW_SafeBottomInset, 0);
        }else{
            weakSelf.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10+PW_SafeBottomInset+60, 0);
        }
    }];
    [self requestData];
    [self requestGasData];
    [self requestApprove];
}
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)collectAction {
    
}
- (void)shareAction {
    [PW_ShareAppTool showShareApp];
}
//visitor
- (void)approveAction {
    Wallet *wallet = [[SettingManager sharedInstance] getCurrentWallet];
    PW_DappPayModel *payModel = [[PW_DappPayModel alloc] init];
    payModel.value = @"1";
    payModel.symbol = self.detailModel.asset.symbol;
    payModel.paymentAddress = wallet.address;
    payModel.acceptAddress = @"";//合约地址
    payModel.gasToolModel.gas_price = [self.gasToolModel.gas_price strTo10];
    payModel.gasToolModel.gas = [self.gasToolModel.gas strTo10];
    payModel.gasToolModel.price = [PW_GlobalData shared].mainTokenModel.price;
    [PW_DappAlertTool showDappAuthorizationConfirm:payModel sureBlock:^(PW_DappPayModel * _Nonnull model) {
        PW_PendingAlertViewController *vc = [[PW_PendingAlertViewController alloc] init];
        vc.type = PW_PendingAlertPending;
        vc.msg = PW_StrFormat(@"Approve %@",self.detailModel.asset.name);
        [self presentViewController:vc animated:NO completion:nil];
        __weak typeof(vc) weakVc = vc;
//        [[PWWalletERC721ContractTool shared] approveWithPrivateKey:wallet.priKey contract:self.model.assetContract to:@"" tokenId:self.model.tokenId gas:model.gasModel.gas gasPrice:model.gasModel.gas_price completionHandler:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
//            __strong typeof(weakVc) strongVc = weakVc;
//            if ([hash isNoEmpty]) {
//                if(strongVc){
//                    strongVc.type = PW_PendingAlertSuccess;
//                    strongVc.msg = PW_StrFormat(@"View on %@ chain",[[SettingManager sharedInstance] getChainType]);
//                }else{
//                    PW_PendingAlertViewController *vc = [[PW_PendingAlertViewController alloc] init];
//                    vc.type = PW_PendingAlertSuccess;
//                    vc.msg = PW_StrFormat(@"View on %@ chain",[[SettingManager sharedInstance] getChainType]);
//                    [self presentViewController:vc animated:NO completion:nil];
//                }
//            }else{
//                if (strongVc) {
//                    strongVc.type = PW_PendingAlertError;
//                }else{
//                    PW_PendingAlertViewController *vc = [[PW_PendingAlertViewController alloc] init];
//                    vc.type = PW_PendingAlertError;
//                    [self presentViewController:vc animated:NO completion:nil];
//                }
//            }
//        }];
    } closeBlock:^{
        PW_PendingAlertViewController *vc = [[PW_PendingAlertViewController alloc] init];
        vc.type = PW_PendingAlertError;
        [self presentViewController:vc animated:NO completion:nil];
    }];
}
- (void)offerAction {
    PW_BidNFTAlertViewController *vc = [[PW_BidNFTAlertViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)buyAction {
    PW_ConfirmPurchaseNFTAlertViewController *vc = [[PW_ConfirmPurchaseNFTAlertViewController alloc] init];
    vc.sureBlock = ^{
        PW_DappPayModel *payModel = [[PW_DappPayModel alloc] init];
        [PW_DappAlertTool showDappConfirmPayInfo:payModel sureBlock:^(PW_DappPayModel * _Nonnull model) {
            
        } closeBlock:^{
            
        }];
    };
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)cancelOfferAction {
    PW_ConfirmNFTAlertViewController *vc = [[PW_ConfirmNFTAlertViewController alloc] init];
    vc.titleStr = LocalizedStr(@"text_confirmCancel");
    vc.descStr = LocalizedStr(@"text_withdrawOfferTip");
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)updateOfferAction {
    PW_BidNFTAlertViewController *vc = [[PW_BidNFTAlertViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}
//owner
- (void)withdrawAction {
    PW_ConfirmNFTAlertViewController *vc = [[PW_ConfirmNFTAlertViewController alloc] init];
    vc.titleStr = LocalizedStr(@"text_withdraw");
    vc.descStr = LocalizedStr(@"text_withdrawNFTTip");
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)transferAction {
    PW_TransferNFTAlertViewController *vc = [[PW_TransferNFTAlertViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)ownerOfferAction {
    PW_OfferNFTAlertViewController *vc = [[PW_OfferNFTAlertViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)leaseAction {
    
}
- (void)sellAction {
    PW_PutawaySellNFTAlertViewController *vc = [[PW_PutawaySellNFTAlertViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)auctionAction {
    PW_PutawayAuctionNFTAlertViewController *vc = [[PW_PutawayAuctionNFTAlertViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)segmentChange:(NSInteger)index {
    self.segmentIndex = index;
    [self.tableView reloadData];
}
- (void)refreshUI {
    self.collectBtn.selected = self.detailModel.isFollow;
    self.headerView.model = self.detailModel;
    [self.tableView reloadData];
    [self refreshBottomView];
}
#pragma mark - request
- (void)requestGasData {
//    [[PWWalletERC721ContractTool shared] estimateGasWithContract:self.model.assetContract to:nil completionHandler:^(NSString * _Nullable gas, NSString * _Nullable gasPrice, NSString * _Nullable errorDesc) {
//        if([gas isNoEmpty]){
//            self.gasToolModel.gas_price = gasPrice;
//            self.gasToolModel.gas = gas;
//            self.gasToolModel.price = [PW_GlobalData shared].mainTokenModel.price;
//        }
//    }];
}
- (void)requestApprove {
//    [[PWWalletERC721ContractTool shared] getApprovedWithContract:self.model.assetContract tokenId:self.model.tokenId completionHandler:^(BOOL isApproved, NSString * _Nullable errorDesc) {
//        self.isApproved = isApproved;
//        [self refreshBottomView];
//    }];
}
#pragma mark - api
- (void)requestData {
    User *user = User_manager.currentUser;
    [self showLoading];
    [self pw_requestNFTApi:NFTAssetItemURL params:@{
        @"chainId":user.current_chainId,
        @"tokenId":self.model.tokenId,
        @"assetContract":self.model.assetContract,
        @"address":user.chooseWallet_address,
    } completeBlock:^(id  _Nonnull data) {
        [self dismissLoading];
        self.detailModel = [PW_NFTDetailModel mj_objectWithKeyValues:data];
        [self refreshUI];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self dismissLoading];
    }];
}
#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentIndex==0) {
        return self.detailModel.traits.count;
    }else if (self.segmentIndex==1) {
        return 30;
    }
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentIndex==0) {
        PW_NFTDetailPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_NFTDetailPropertyCell.class)];
        cell.model = self.detailModel.traits[indexPath.row];
        return cell;
    }else if (self.segmentIndex==1) {
        PW_NFTDetailOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_NFTDetailOfferCell.class)];
        
        return cell;
    }
    PW_NFTDetailDealCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_NFTDetailDealCell.class)];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak typeof(self) weakSelf = self;
    if (self.segmentIndex==0) {
        if (section==0) {
            PW_NFTDetailDataSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(PW_NFTDetailDataSectionHeaderView.class)];
            view.model = self.detailModel;
            view.index = self.segmentIndex;
            view.segmentIndexBlock = ^(NSInteger index) {
                [weakSelf segmentChange:index];
            };
            return view;
        }
        return nil;
    }else if (self.segmentIndex==1) {
        PW_NFTDetailOfferSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(PW_NFTDetailOfferSectionHeaderView.class)];
        view.index = self.segmentIndex;
        view.segmentIndexBlock = ^(NSInteger index) {
            [weakSelf segmentChange:index];
        };
        return view;
    }
    PW_NFTDetailDealSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(PW_NFTDetailDealSectionHeaderView.class)];
    view.index = self.segmentIndex;
    view.segmentIndexBlock = ^(NSInteger index) {
        [weakSelf segmentChange:index];
    };
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.segmentIndex==0) {
        return 200;
    }
    return 80;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat hiddenHeight = PW_NavStatusHeight;
    CGFloat alpha = scrollView.contentOffset.y/hiddenHeight;
    alpha = MIN(1,MAX(0,alpha));
    self.navBar.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    self.titleLb.alpha = alpha;
}
#pragma mark - views
- (void)makeViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(PW_NavStatusHeight);
        make.left.right.bottom.offset(0);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(50);
        make.bottom.offset(-PW_SafeBottomInset-10);
    }];
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_equalTo(PW_NavStatusHeight);
    }];
    [self.navContentView addSubview:self.backBtn];
    [self.navContentView addSubview:self.titleLb];
    [self.navContentView addSubview:self.collectBtn];
    [self.navContentView addSubview:self.shareBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(10);
        make.centerY.offset(0);
        make.right.mas_lessThanOrEqualTo(-108);
    }];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.mas_left).offset(-10);
        make.centerY.offset(0);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
    [self refreshBottomView];
}
- (void)refreshBottomView {
    User *user = User_manager.currentUser;
    self.bottomView.hidden = NO;
    [self.bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    BOOL isOwner = [self.detailModel.asset.owner isEqualToString:user.chooseWallet_address];
    if (isOwner) {
        //在售竞拍
//        [self.bottomView addSubview:self.withdrawBtn];
//        [self.bottomView addSubview:self.transferBtn];
//        [self.bottomView addSubview:self.ownerOfferBtn];
//        [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.bottom.offset(0);
//        }];
//        [self.transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.withdrawBtn.mas_right).offset(10);
//            make.top.bottom.offset(0);
//            make.width.equalTo(self.withdrawBtn);
//        }];
//        [self.ownerOfferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.transferBtn.mas_right).offset(10);
//            make.top.bottom.right.offset(0);
//            make.width.equalTo(self.withdrawBtn);
//        }];
        //在售非竞拍
//        [self.bottomView addSubview:self.withdrawBtn];
//        [self.bottomView addSubview:self.transferBtn];
//        [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.bottom.offset(0);
//        }];
//        [self.transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.withdrawBtn.mas_right).offset(20);
//            make.top.bottom.right.offset(0);
//            make.width.equalTo(self.withdrawBtn);
//        }];
        //未出售
        [self.bottomView addSubview:self.groupBtnView];
        [self.bottomView addSubview:self.auctionBtn];
        [self.groupBtnView addSubview:self.leaseBtn];
        [self.groupBtnView addSubview:self.sellBtn];
        [self.groupBtnView addSubview:self.transferBtn];
        UIView *line1View = [[UIView alloc] init];
        line1View.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
        [self.groupBtnView addSubview:line1View];
        UIView *line2View = [[UIView alloc] init];
        line2View.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
        [self.groupBtnView addSubview:line2View];
        [self.groupBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset(0);
        }];
        [self.auctionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.groupBtnView.mas_right).offset(10);
            make.top.bottom.right.offset(0);
            make.width.mas_equalTo(110);
        }];
        [self.leaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset(0);
        }];
        [self.sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leaseBtn.mas_right);
            make.top.bottom.offset(0);
            make.width.equalTo(self.leaseBtn);
        }];
        [self.transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sellBtn.mas_right);
            make.top.bottom.right.offset(0);
            make.width.equalTo(self.leaseBtn);
        }];
        [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leaseBtn.mas_right);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(1);
            make.centerY.offset(0);
        }];
        [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sellBtn.mas_right);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(1);
            make.centerY.offset(0);
        }];
    }else{
        if (!self.isApproved) {//未授权
            [self.bottomView addSubview:self.approveBtn];
            [self.approveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.offset(0);
            }];
        }else{//授权后
            [self.bottomView addSubview:self.offerBtn];
            [self.bottomView addSubview:self.buyBtn];
            [self.offerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.offset(0);
            }];
            [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.offerBtn.mas_right).offset(20);
                make.top.right.bottom.offset(0);
                make.width.mas_equalTo(self.offerBtn);
            }];
        }
        //参与竞拍后
//        [self.bottomView addSubview:self.cancelOfferBtn];
//        [self.bottomView addSubview:self.updateOfferBtn];
//        [self.cancelOfferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.bottom.offset(0);
//        }];
//        [self.updateOfferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.cancelOfferBtn.mas_right).offset(20);
//            make.top.right.bottom.offset(0);
//            make.width.mas_equalTo(self.cancelOfferBtn);
//        }];
        //未出售
//        self.bottomView.hidden = YES;
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:PW_NFTDetailDataSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PW_NFTDetailDataSectionHeaderView.class)];
        [_tableView registerClass:PW_NFTDetailOfferSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PW_NFTDetailOfferSectionHeaderView.class)];
        [_tableView registerClass:PW_NFTDetailDealSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PW_NFTDetailDealSectionHeaderView.class)];
        [_tableView registerClass:PW_NFTDetailPropertyCell.class forCellReuseIdentifier:NSStringFromClass(PW_NFTDetailPropertyCell.class)];
        [_tableView registerClass:PW_NFTDetailOfferCell.class forCellReuseIdentifier:NSStringFromClass(PW_NFTDetailOfferCell.class)];
        [_tableView registerClass:PW_NFTDetailDealCell.class forCellReuseIdentifier:NSStringFromClass(PW_NFTDetailDealCell.class)];
        _tableView.clipsToBounds = NO;
        _tableView.rowHeight = 28;
        _tableView.sectionHeaderHeight = 80;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.tableHeaderView = self.headerView;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10+PW_SafeBottomInset+60, 0);
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}
- (PW_NFTDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PW_NFTDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 450-PW_NavStatusHeight)];
    }
    return _headerView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:18 textColor:[UIColor whiteColor]];
    }
    return _titleLb;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [PW_ViewTool buttonImageName:@"icon_nav_back" target:self action:@selector(backAction)];
    }
    return _backBtn;
}
- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [PW_ViewTool buttonImageName:@"icon_nav_collect" selectedImage:@"icon_nav_collect_selected" target:self action:@selector(collectAction)];
    }
    return _collectBtn;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [PW_ViewTool buttonImageName:@"icon_nav_share" target:self action:@selector(shareAction)];
    }
    return _shareBtn;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}
//visitor
- (UIButton *)approveBtn {
    if (!_approveBtn) {
        _approveBtn = [PW_ViewTool buttonSemiboldTitle:@"Approve" fontSize:15 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(approveAction)];
    }
    return _approveBtn;
}
- (UIButton *)offerBtn {
    if (!_offerBtn) {
        _offerBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_offer") fontSize:15 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(offerAction)];
    }
    return _offerBtn;
}
- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_buy") fontSize:15 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(buyAction)];
    }
    return _buyBtn;
}
- (UIButton *)cancelOfferBtn {
    if (!_cancelOfferBtn) {
        _cancelOfferBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_cancel") fontSize:15 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(cancelOfferAction)];
    }
    return _cancelOfferBtn;
}
- (UIButton *)updateOfferBtn {
    if (!_updateOfferBtn) {
        _updateOfferBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_updateOffer") fontSize:15 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(updateOfferAction)];
    }
    return _updateOfferBtn;
}
//owner
- (UIButton *)withdrawBtn {
    if (!_withdrawBtn) {
        _withdrawBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_withdraw") fontSize:15 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(withdrawAction)];
    }
    return _withdrawBtn;
}
- (UIButton *)transferBtn {
    if (!_transferBtn) {
        _transferBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_makeOver") fontSize:15 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(transferAction)];
    }
    return _transferBtn;
}
- (UIButton *)ownerOfferBtn {
    if (!_ownerOfferBtn) {
        _ownerOfferBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_offer") fontSize:15 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(ownerOfferAction)];
    }
    return _ownerOfferBtn;
}
- (UIView *)groupBtnView {
    if (!_groupBtnView) {
        _groupBtnView = [[UIView alloc] init];
        _groupBtnView.backgroundColor = [UIColor g_darkBgColor];
        [_groupBtnView setCornerRadius:8];
    }
    return _groupBtnView;
}
- (UIButton *)leaseBtn {
    if (!_leaseBtn) {
        _leaseBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_lease") fontSize:15 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(leaseAction)];
        _leaseBtn.enabled = NO;
    }
    return _leaseBtn;
}
- (UIButton *)sellBtn {
    if (!_sellBtn) {
        _sellBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_sell") fontSize:15 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(sellAction)];
    }
    return _sellBtn;
}
- (UIButton *)auctionBtn {
    if (!_auctionBtn) {
        _auctionBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_auction") fontSize:15 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(auctionAction)];
    }
    return _auctionBtn;
}
- (PW_GasToolModel *)gasToolModel {
    if (!_gasToolModel) {
        _gasToolModel = [[PW_GasToolModel alloc] init];
    }
    return _gasToolModel;
}

@end
