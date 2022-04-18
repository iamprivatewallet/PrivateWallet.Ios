//
//  PW_NodeListCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NodeListCell.h"

@interface PW_NodeListCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *openBtn;

@end

@implementation PW_NodeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_NetworkModel *)model {
    _model = model;
    self.titleLb.text = model.rpcUrl;
    self.openBtn.selected = model.selected;
}
- (void)makeViews {
    self.bodyView = [[UIView alloc] init];
    [self.bodyView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    self.bodyView.backgroundColor = [UIColor g_bgColor];
    self.bodyView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.bodyView];
    self.titleLb = [PW_ViewTool labelMediumText:@"--" fontSize:16 textColor:[UIColor g_boldTextColor]];
    [self.bodyView addSubview:self.titleLb];
    self.openBtn = [[UIButton alloc] init];
    self.openBtn.userInteractionEnabled = NO;
    [self.openBtn setImage:[UIImage imageNamed:@"icon_uncheck"] forState:UIControlStateNormal];
    [self.openBtn setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.openBtn];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(6);
        make.bottom.offset(-6);
        make.left.offset(20);
        make.right.offset(-76);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.mas_lessThanOrEqualTo(-18);
        make.centerY.offset(0);
    }];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
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
