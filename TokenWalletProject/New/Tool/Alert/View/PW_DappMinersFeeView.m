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

@property (nonatomic, weak) UIButton *selectedSpeedFeeBtn;
@property (nonatomic, assign) NSInteger speedFeeIdx;
@property (nonatomic, assign) BOOL showCustomFee;

@end

@implementation PW_DappMinersFeeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBorderColor:[UIColor g_borderColor] width:1 radius:8];
        [self makeViews];
    }
    return self;
}
- (void)changeSpeedAction:(UIButton *)btn {
    self.speedFeeIdx = btn.tag-SpeedFeeBtnTag;
}
- (void)customFeeAction {
//    self.showCustomFee = !self.showCustomFee;
}
- (void)sliderValueChange:(PW_SliderView *)slider {
    
}
- (void)setToolModel:(PW_GasToolModel *)toolModel {
    _toolModel = toolModel;
    _gasModel = toolModel.recommendModel;;
    _title = LocalizedStr(@"text_recommend");
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
        strongSelf.customFeeView.hidden = !x.boolValue;
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
        strongSelf.selectedSpeedFeeBtn.selected = NO;
        strongSelf.selectedSpeedFeeBtn.layer.borderWidth = 1;
        strongSelf.selectedSpeedFeeBtn.layer.borderColor = [[UIColor g_borderColor] CGColor];
        UIButton *btn = [strongSelf.speedFeeView viewWithTag:SpeedFeeBtnTag+x.integerValue];
        btn.selected = YES;
        btn.layer.borderWidth = 2;
        btn.layer.borderColor = [[UIColor g_primaryColor] CGColor];
        strongSelf.selectedSpeedFeeBtn = btn;
        if(x.integerValue==0){
            [strongSelf setGas:strongSelf.toolModel.slowModel title:btn.titleLabel.text];
        }else if(x.integerValue==1){
            [strongSelf setGas:strongSelf.toolModel.recommendModel title:btn.titleLabel.text];
        }else if(x.integerValue==2){
            [strongSelf setGas:strongSelf.toolModel.fastModel title:btn.titleLabel.text];
        }else if(x.integerValue==3){
            [strongSelf setGas:strongSelf.toolModel.soonModel title:btn.titleLabel.text];
        }
        if (strongSelf.changeBlock) {
            strongSelf.changeBlock(strongSelf.gasModel,strongSelf.title);
        }
        [strongSelf refreshGasUI];
    }];
}
- (void)refreshGasUI {
    if (![self.gasModel.gas_price isNoEmpty]) {
        return;
    }
    self.sliderView.value = [self.gasModel.gas_price doubleValue];
    self.minersFeeLb.text = NSStringWithFormat(@"%@%@",self.gasModel.gas_amount,[[SettingManager sharedInstance] getChainCoinName]);
    self.minersFeeUTLb.text = NSStringWithFormat(@"≈ $%@",self.gasModel.gas_ut_amout);
    self.gweiLb.text = NSStringWithFormat(@"%@ GWEI",self.gasModel.gas_gwei);
}
- (void)createMinersFeeItems {
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_minersFee") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self addSubview:tipLb];
    UIButton *customBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_custom") fontSize:13 titleColor:[UIColor g_textColor] imageName:nil target:self action:@selector(customFeeAction)];
    [self addSubview:customBtn];
    self.minersFeeLb = [PW_ViewTool labelText:@"--" fontSize:15 textColor:[UIColor g_textColor]];
    [self addSubview:self.minersFeeLb];
    self.minersFeeUTLb = [PW_ViewTool labelText:@"--" fontSize:15 textColor:[UIColor g_grayTextColor]];
    [self addSubview:self.minersFeeUTLb];
    self.gweiLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self addSubview:self.gweiLb];
    [self addSubview:self.sliderView];
    self.speedFeeView = [[UIView alloc] init];
    [self addSubview:self.speedFeeView];
    NSArray *titleArr = @[LocalizedStr(@"text_slow"),LocalizedStr(@"text_recommend"),LocalizedStr(@"text_fast"),LocalizedStr(@"text_soon")];
    UIView *lastBtn = nil;
    for (NSInteger i=0;i<titleArr.count;i++) {
        NSString *text = titleArr[i];
        UIButton *btn = [PW_ViewTool buttonSemiboldTitle:text fontSize:14 titleColor:[UIColor g_textColor] cornerRadius:17.5 backgroundColor:nil target:self action:@selector(changeSpeedAction:)];
        btn.tag = SpeedFeeBtnTag+i;
        [btn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateSelected];
        [btn setBorderColor:[UIColor g_borderColor] width:1 radius:17.5];
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
        make.top.offset(14);
        make.right.offset(-18);
    }];
    [self.minersFeeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.equalTo(tipLb.mas_bottom).offset(8);
    }];
    [self.minersFeeUTLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minersFeeLb.mas_right).offset(10);
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
        make.height.offset(35);
        make.bottom.offset(-20).priorityMedium();
    }];
    self.customFeeView = [[UIView alloc] init];
    [self addSubview:self.customFeeView];
    UILabel *gasPriceLb = [PW_ViewTool labelBoldText:@"Gas Price" fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.customFeeView addSubview:gasPriceLb];
    UILabel *gasLb = [PW_ViewTool labelBoldText:@"Gas" fontSize:13 textColor:[UIColor g_grayTextColor]];
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
    [gasView addSubview:gasPriceGweiLb];
    UILabel *gasGweiLb = [PW_ViewTool labelBoldText:@"GWEI" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [gasGweiLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [gasGweiLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [gasView addSubview:gasGweiLb];
    self.gasPriceTF = [[UITextField alloc] init];
    self.gasPriceTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.gasPriceTF pw_setPlaceholder:@"0.00"];
    self.gasPriceTF.font = [UIFont pw_mediumFontOfSize:14];
    self.gasPriceTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [gasPriceView addSubview:self.gasPriceTF];
    self.gasTF = [[UITextField alloc] init];
    self.gasTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.gasTF pw_setPlaceholder:@"0.00"];
    self.gasTF.font = [UIFont pw_mediumFontOfSize:14];
    self.gasTF.clearButtonMode = UITextFieldViewModeWhileEditing;
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
        make.height.offset(45);
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
        make.top.width.equalTo(gasPriceView);
        make.right.offset(0);
        make.height.offset(45);
    }];
    [self.gasTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.offset(0);
        make.right.equalTo(gasGweiLb.mas_left).offset(-5);
    }];
    [gasGweiLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-14);
        make.centerY.offset(0);
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

@end
