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
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [self.bodyView addSubview:lineView];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.bottom.offset(0);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bodyView.mas_left).offset(22);
        make.centerY.offset(0);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(56);
        make.centerY.offset(0);
    }];
    [self.subNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.mas_right).offset(8);
        make.centerY.offset(0);
    }];
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1);
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
