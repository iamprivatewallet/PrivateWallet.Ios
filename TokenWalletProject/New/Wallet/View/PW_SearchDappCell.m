//
//  PW_SearchDappCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchDappCell.h"

@interface PW_SearchDappCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;

@end

@implementation PW_SearchDappCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_DappModel *)model {
    _model = model;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    self.nameLb.text = model.appName;
}
- (void)makeViews {
    self.bodyView = [[UIView alloc] init];
    self.bodyView.backgroundColor = [UIColor g_bgColor];
    self.bodyView.layer.cornerRadius = 20;
    [self.contentView addSubview:self.bodyView];
    self.iconIv = [[UIImageView alloc] init];
    [self.bodyView addSubview:self.iconIv];
    self.nameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:16 textColor:[UIColor g_boldTextColor]];
    self.nameLb.numberOfLines = 2;
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.bottom.offset(0);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.offset(0);
        make.width.height.offset(20);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(8);
        make.right.offset(-10);
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
