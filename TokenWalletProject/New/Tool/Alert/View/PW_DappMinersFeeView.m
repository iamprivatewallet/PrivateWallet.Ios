//
//  PW_DappMinersFeeView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappMinersFeeView.h"

static NSInteger SpeedFeeBtnTag = 100;

@interface PW_DappMinersFeeView ()

@property (nonatomic, strong) UILabel *minersFeeLb;
@property (nonatomic, strong) UILabel *minersFeeUTLb;
@property (nonatomic, strong) UILabel *gweiLb;
@property (nonatomic, strong) PW_SliderView *sliderView;
@property (nonatomic, strong) UIView *speedFeeView;
@property (nonatomic, strong) UIView *customFeeView;
@property (nonatomic, strong) UITextField *gasPriceTF;
@property (nonatomic, strong) UITextField *gasTF;
@property (nonatomic, strong, readonly) PW_GasModel *gasModel;
@property (nonatomic, strong) PW_GasModel *customGasModel;

@property (nonatomic, weak) UIButton *selectedSpeedFeeBtn;
@property (nonatomic, assign) NSInteger speedFeeIdx;
@property (nonatomic, assign) BOOL showCustomFee;

@end

@implementation PW_DappMinersFeeView

- (PW_GasModel *)getCurrentGasModel {
    if (self.showCustomFee) {
        return self.customGasModel;
    }
    return self.gasModel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
        [self makeViews];
    }
    return self;
}
- (void)changeSpeedAction:(UIButton *)btn {
    self.selectedSpeedFeeBtn.selected = NO;
    btn.selected = YES;
    self.selectedSpeedFeeBtn = btn;
    self.speedFeeIdx = btn.tag-SpeedFeeBtnTag;
}
- (void)customFeeAction {
    self.showCustomFee = !self.showCustomFee;
}
- (void)sliderValueChange:(PW_SliderView *)slider {
    
}
- (void)setToolModel:(PW_GasToolModel *)toolModel {
    _toolModel = toolModel;
    _gasModel = toolModel.recommendModel;
    self.customGasModel = [toolModel.recommendModel mutableCopy];
    _title = LocalizedStr(@"text_avg");
    self.sliderView.minimumValue = [toolModel.slowModel.gas_price doubleValue];
    self.sliderView.maximumValue = [toolModel.soonModel.gas_price doubleValue];
    [self refreshGasUI];
}
- (void)setGas:(PW_GasModel *)gasModel title:(NSString *)title {
    _gasModel = gasModel;
    _title = title;
}
- (void)makeViews {
    self.speedFeeIdx = 1;
    [self createMinersFeeItems];
    __weak typeof(self) weakSelf = self;
    [RACObserve(self, showCustomFee) subscribeNext:^(NSNumber * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf refreshGasUI];
        if(x.boolValue){
            [strongSelf.customFeeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(strongSelf.speedFeeView.mas_bottom).offset(0);
                make.left.offset(18);
                make.right.offset(-18);
                make.bottom.offset(-20);
            }];
        }else{
            [strongSelf.customFeeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(strongSelf.speedFeeView.mas_bottom).offset(0);
                make.left.offset(18);
                make.right.offset(-18);
            }];
        }
    }];
    [RACObserve(self, speedFeeIdx) subscribeNext:^(NSNumber * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIButton *btn = [strongSelf.speedFeeView viewWithTag:SpeedFeeBtnTag+x.integerValue];
        if(x.integerValue==0){
            [strongSelf setGas:strongSelf.toolModel.slowModel title:btn.titleLabel.text];
        }else if(x.integerValue==1){
            [strongSelf setGas:strongSelf.toolModel.recommendModel title:btn.titleLabel.text];
        }else if(x.integerValue==2){
            [strongSelf setGas:strongSelf.toolModel.fastModel title:btn.titleLabel.text];
        }else if(x.integerValue==3){
            [strongSelf setGas:strongSelf.toolModel.soonModel title:btn.titleLabel.text];
        }
        [strongSelf refreshGasUI];
    }];
    [RACObserve(self, customGasModel) subscribeNext:^(id  _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.gasPriceTF.text = strongSelf.customGasModel.gas_gwei;
        [strongSelf.gasPriceTF pw_setPlaceholder:strongSelf.customGasModel.gas_gwei];
        strongSelf.gasTF.text = strongSelf.customGasModel.gas;
        [strongSelf.gasTF pw_setPlaceholder:strongSelf.customGasModel.gas];
    }];
    [self.gasPriceTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (![x isFloat]) {
            if (x.length==0) {
                return;
            }
            strongSelf.gasPriceTF.text = strongSelf.customGasModel.gas_gwei;
            return;
        }
        strongSelf.customGasModel.gas_price = [x stringDownMultiplyingBy10Power:9 scale:0];
        [strongSelf refreshGasUI];
    }];
    [self.gasTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (![x isInt]) {
            if (x.length==0) {
                return;
            }
            strongSelf.gasTF.text = strongSelf.customGasModel.gas;
            return;
        }
        strongSelf.customGasModel.gas = x;
        [strongSelf refreshGasUI];
    }];
}
- (void)refreshGasUI {
    PW_GasModel *gasModel = [self getCurrentGasModel];
    if (![gasModel.gas_price isNoEmpty]) {
        return;
    }
    self.sliderView.value = [gasModel.gas_price doubleValue];
    self.minersFeeLb.text = NSStringWithFormat(@"%@%@",gasModel.gas_amount,[[SettingManager sharedInstance] getChainCoinName]);
    self.minersFeeUTLb.text = NSStringWithFormat(@" ≈ $%@",gasModel.gas_ut_amout);
    self.gweiLb.text = NSStringWithFormat(@"%@ GWEI",gasModel.gas_gwei);
}
- (void)createMinersFeeItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_minersFee") fontSize:20 textColor:[UIColor g_textColor]];
    [self addSubview:tipLb];
    UIButton *customBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_custom") fontSize:14 titleColor:[UIColor g_textColor] imageName:nil target:self action:@selector(customFeeAction)];
    [self addSubview:customBtn];
    self.minersFeeLb = [PW_ViewTool labelText:@"--" fontSize:14 textColor:[UIColor g_grayTextColor]];
    [self addSubview:self.minersFeeLb];
    self.minersFeeUTLb = [PW_ViewTool labelText:@"--" fontSize:14 textColor:[UIColor g_grayTextColor]];
    [self addSubview:self.minersFeeUTLb];
    self.gweiLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_textColor]];
    [self addSubview:self.gweiLb];
    [self addSubview:self.sliderView];
    self.speedFeeView = [[UIView alloc] init];
    [self addSubview:self.speedFeeView];
    NSArray *titleArr = @[LocalizedStr(@"text_slow"),LocalizedStr(@"text_avg"),LocalizedStr(@"text_fast"),LocalizedStr(@"text_soon")];
    UIView *lastBtn = nil;
    for (NSInteger i=0;i<titleArr.count;i++) {
        NSString *text = titleArr[i];
        UIButton *btn = [PW_ViewTool buttonSemiboldTitle:text fontSize:13 titleColor:[UIColor g_grayTextColor] cornerRadius:8 backgroundColor:nil target:self action:@selector(changeSpeedAction:)];
        btn.tag = SpeedFeeBtnTag+i;
        [btn setTitleColor:[UIColor g_whiteTextColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor g_hex:@"#E6E6E6"] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor g_hex:@"#333333"] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        if(i==self.speedFeeIdx){
            btn.selected = YES;
            self.selectedSpeedFeeBtn = btn;
        }
        [self.speedFeeView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastBtn){
                make.left.equalTo(lastBtn.mas_right).offset(10);
                make.width.equalTo(lastBtn);
            }else{
                make.left.offset(0);
            }
            make.top.bottom.offset(0);
            if(i==titleArr.count-1){
                make.right.offset(0);
            }
        }];
        lastBtn = btn;
    }
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(14);
        make.left.offset(18);
    }];
    [customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(22);
        make.right.offset(-20);
    }];
    [self.minersFeeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.equalTo(tipLb.mas_bottom).offset(8);
    }];
    [self.minersFeeUTLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minersFeeLb.mas_right).offset(0);
        make.centerY.equalTo(self.minersFeeLb);
    }];
    [self.gweiLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.minersFeeLb.mas_bottom).offset(8);
    }];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.equalTo(self.gweiLb.mas_bottom).offset(4);
    }];
    [self.speedFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sliderView.mas_bottom).offset(6);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(18);
        make.bottom.offset(-20).priorityMedium();
    }];
    self.customFeeView = [[UIView alloc] init];
    [self addSubview:self.customFeeView];
    UILabel *gasPriceLb = [PW_ViewTool labelMediumText:@"Gas Price" fontSize:20 textColor:[UIColor g_textColor]];
    [self.customFeeView addSubview:gasPriceLb];
    UILabel *gasLb = [PW_ViewTool labelMediumText:@"Gas Limit" fontSize:20 textColor:[UIColor g_textColor]];
    [self.customFeeView addSubview:gasLb];
    UIView *gasPriceView = [[UIView alloc] init];
    gasPriceView.backgroundColor = [UIColor g_grayBgColor];
    [gasPriceView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.customFeeView addSubview:gasPriceView];
    UIView *gasView = [[UIView alloc] init];
    gasView.backgroundColor = [UIColor g_grayBgColor];
    [gasView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.customFeeView addSubview:gasView];
    UILabel *gasPriceGweiLb = [PW_ViewTool labelBoldText:@"GWEI" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [gasPriceGweiLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [gasPriceGweiLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [gasPriceView addSubview:gasPriceGweiLb];
    self.gasPriceTF = [PW_ViewTool textFieldFont:[UIFont pw_mediumFontOfSize:14] color:[UIColor g_textColor] placeholder:@"0.0"];
    self.gasPriceTF.keyboardType = UIKeyboardTypeNumberPad;
    [gasPriceView addSubview:self.gasPriceTF];
    self.gasTF = [PW_ViewTool textFieldFont:[UIFont pw_mediumFontOfSize:14] color:[UIColor g_textColor] placeholder:@"0.0"];
    self.gasTF.keyboardType = UIKeyboardTypeNumberPad;
    [gasView addSubview:self.gasTF];
    [self.customFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speedFeeView.mas_bottom).offset(0);
        make.left.offset(18);
        make.right.offset(-18);
    }];
    [gasPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.left.offset(0);
    }];
    [gasLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gasPriceLb);
        make.left.equalTo(self.mas_centerX).offset(7);
    }];
    [gasPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(gasPriceLb.mas_bottom).offset(15);
        make.height.offset(28);
        make.bottom.offset(0);
    }];
    [self.gasPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.offset(0);
        make.right.equalTo(gasPriceGweiLb.mas_left).offset(-5);
    }];
    [gasPriceGweiLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-14);
        make.centerY.offset(0);
    }];
    [gasView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gasPriceView.mas_right).offset(14);
        make.top.width.height.equalTo(gasPriceView);
        make.right.offset(0);
    }];
    [self.gasTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.right.offset(0);
    }];
}
#pragma mark - lazy
- (PW_SliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[PW_SliderView alloc] init];
        [_sliderView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        _sliderView.maximumValue = 100;
        _sliderView.minimumValue = 0;
        _sliderView.continuous = NO;
        _sliderView.userInteractionEnabled = NO;
    }
    return _sliderView;
}
- (PW_GasModel *)customGasModel {
    if (!_customGasModel) {
        _customGasModel = [[PW_GasModel alloc] init];
    }
    return _customGasModel;
}

@end
