//
//  PW_SearchHistoryDappCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchHistoryDappCell.h"

@interface PW_SearchHistoryDappCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIImageView *arrowIv;

@end

@implementation PW_SearchHistoryDappCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    [self.contentView addSubview:self.bodyView];
    self.iconIv = [[UIImageView alloc] init];
    [self.bodyView addSubview:self.iconIv];
    self.nameLb = [PW_ViewTool labelText:@"--" fontSize:16 textColor:[UIColor g_textColor]];
    self.nameLb.numberOfLines = 2;
    [self.bodyView addSubview:self.nameLb];
    self.arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_black"]];
    [self.bodyView addSubview:self.arrowIv];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [self.bodyView addSubview:lineView];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.bottom.offset(0);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.offset(0);
        make.width.height.offset(50);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(8);
        make.right.mas_lessThanOrEqualTo(-20);
        make.centerY.offset(0);
    }];
    [self.arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
    }];
}

@end
