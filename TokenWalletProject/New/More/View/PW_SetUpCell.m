//
//  PW_SetUpCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SetUpCell.h"

@interface PW_SetUpCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *descLb;
@property (nonatomic, strong) UIImageView *arrowIv;
@property (nonatomic, strong) UISwitch *switchBtn;

@end

@implementation PW_SetUpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)switchAction:(UISwitch *)switchBtn {
    if (self.switchBlock) {
        self.switchBlock(self.model, switchBtn.isOn);
    }
}
- (void)setModel:(PW_SetUpModel *)model {
    _model = model;
    self.iconIv.image = [UIImage imageNamed:model.iconName];
    self.titleLb.text = model.title;
    self.descLb.text = model.desc;
    self.switchBtn.on = model.isOpen;
    if (model.isSwitch) {
        self.descLb.hidden = self.arrowIv.hidden = YES;
        self.switchBtn.hidden = NO;
    }else{
        self.descLb.hidden = self.arrowIv.hidden = NO;
        self.switchBtn.hidden = YES;
    }
}
- (void)makeViews {
    self.bodyView = [[UIView alloc] init];
    [self.bodyView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    self.bodyView.backgroundColor = [UIColor g_bgColor];
    self.bodyView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.bodyView];
    self.iconIv = [[UIImageView alloc] init];
    [self.bodyView addSubview:self.iconIv];
    self.titleLb = [PW_ViewTool labelMediumText:@"--" fontSize:16 textColor:[UIColor g_boldTextColor]];
    [self.bodyView addSubview:self.titleLb];
    self.descLb = [PW_ViewTool labelMediumText:@"" fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.bodyView addSubview:self.descLb];
    self.arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [self.bodyView addSubview:self.arrowIv];
    self.switchBtn = [[UISwitch alloc] init];
    [self.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.bodyView addSubview:self.switchBtn];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.bottom.offset(-5);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.height.offset(36);
        make.centerY.offset(0);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(10);
        make.centerY.offset(0);
    }];
    [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowIv.mas_left).offset(-8);
        make.centerY.offset(0);
    }];
    [self.arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-22);
        make.centerY.offset(0);
    }];
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-22);
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
