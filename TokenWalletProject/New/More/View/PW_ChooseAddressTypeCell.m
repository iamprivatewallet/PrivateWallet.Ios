//
//  PW_ChooseAddressTypeCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ChooseAddressTypeCell.h"

@interface PW_ChooseAddressTypeCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *subNameLb;
@property (nonatomic, strong) UIButton *stateBtn;

@end

@implementation PW_ChooseAddressTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_ChooseAddressTypeModel *)model {
    _model = model;
    self.iconIv.image = [UIImage imageNamed:model.iconName];
    self.nameLb.text = model.title;
    self.subNameLb.text = model.subTitle;
    self.stateBtn.selected = model.selected;
}
- (void)makeViews {
    self.bodyView = [[UIView alloc] init];
    [self.bodyView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    self.bodyView.backgroundColor = [UIColor g_bgColor];
    [self.contentView addSubview:self.bodyView];
    self.iconIv = [[UIImageView alloc] init];
    [self.bodyView addSubview:self.iconIv];
    self.nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    [self.bodyView addSubview:self.nameLb];
    self.subNameLb = [PW_ViewTool labelBoldText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.bodyView addSubview:self.subNameLb];
    self.stateBtn = [[UIButton alloc] init];
    self.stateBtn.userInteractionEnabled = NO;
    [self.stateBtn setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
    [self.stateBtn setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateSelected];
    [self.bodyView addSubview:self.stateBtn];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.offset(5);
        make.bottom.offset(-5);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.width.height.offset(40);
        make.centerY.offset(0);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(15);
        make.centerY.offset(0);
    }];
    [self.subNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.mas_right).offset(8);
        make.centerY.offset(0);
    }];
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.centerY.offset(0);
    }];
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
