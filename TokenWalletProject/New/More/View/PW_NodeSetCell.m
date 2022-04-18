//
//  PW_NodeSetCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NodeSetCell.h"

@interface PW_NodeSetCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *descLb;

@end

@implementation PW_NodeSetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_NetworkModel *)model {
    _model = model;
    self.titleLb.text = model.title;
    self.descLb.text = model.rpcUrl;
}
- (void)makeViews {
    self.bodyView = [[UIView alloc] init];
    [self.bodyView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    self.bodyView.backgroundColor = [UIColor g_bgColor];
    [self.contentView addSubview:self.bodyView];
    self.titleLb = [PW_ViewTool labelMediumText:@"--" fontSize:16 textColor:[UIColor g_boldTextColor]];
    [self.bodyView addSubview:self.titleLb];
    self.descLb = [PW_ViewTool labelMediumText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.bodyView addSubview:self.descLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [self.bodyView addSubview:arrowIv];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.offset(6);
        make.bottom.offset(-6);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bodyView.mas_centerY);
        make.left.offset(25);
    }];
    [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.top.equalTo(self.bodyView.mas_centerY).offset(4);
        make.right.mas_lessThanOrEqualTo(-20);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
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
