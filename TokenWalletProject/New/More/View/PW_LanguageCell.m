//
//  PW_LanguageCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_LanguageCell.h"

@interface PW_LanguageCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *openBtn;

@end

@implementation PW_LanguageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_LanguageModel *)model {
    _model = model;
    self.iconIv.image = [UIImage imageNamed:model.iconName];
    self.titleLb.text = model.name;
    self.openBtn.selected = model.selected;
}
- (void)makeViews {
    self.bodyView = [[UIView alloc] init];
    [self.bodyView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    self.bodyView.backgroundColor = [UIColor g_bgColor];
    [self.contentView addSubview:self.bodyView];
    self.iconIv = [[UIImageView alloc] init];
    [self.bodyView addSubview:self.iconIv];
    self.titleLb = [PW_ViewTool labelMediumText:@"--" fontSize:16 textColor:[UIColor g_boldTextColor]];
    [self.bodyView addSubview:self.titleLb];
    self.openBtn = [[UIButton alloc] init];
    self.openBtn.userInteractionEnabled = NO;
    [self.openBtn setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
    [self.openBtn setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateSelected];
    [self.bodyView addSubview:self.openBtn];
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
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(15);
        make.centerY.offset(0);
    }];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
