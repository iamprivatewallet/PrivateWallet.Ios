//
//  PW_MoreCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MoreCell.h"

@interface PW_MoreCell ()

@property (nonatomic, strong) UIView *bodyView;

@end

@implementation PW_MoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}
- (void)setDataArr:(NSArray<PW_MoreModel *> *)dataArr {
    _dataArr = dataArr;
    [self.bodyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastView = nil;
    for (NSInteger i=0; i<dataArr.count; i++) {
        UIView *rowView = [self createRow:dataArr[i]];
        [self.bodyView addSubview:rowView];
        [rowView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            }else{
                make.top.offset(0);
            }
            make.left.right.offset(0);
            make.height.equalTo(self.bodyView).multipliedBy(1.0/dataArr.count);
        }];
        lastView = rowView;
    }
}
- (UIView *)createRow:(PW_MoreModel *)model {
    UIView *rowView = [[UIView alloc] init];
    [rowView addTapBlock:^(UIView * _Nonnull view) {
        if(model.actionBlock){
            model.actionBlock(model);
        }
    }];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:model.iconName]];
    [rowView addSubview:iconIv];
    UILabel *titleLb = [PW_ViewTool labelText:model.title fontSize:15 textColor:[UIColor g_textColor]];
    [rowView addSubview:titleLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [rowView addSubview:arrowIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIv.mas_right).offset(10);
        make.centerY.offset(0);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
    return rowView;
}
- (void)makeViews {
    self.bodyView = [[UIView alloc] init];
    self.bodyView.backgroundColor = [UIColor g_bgColor];
    self.bodyView.layer.cornerRadius = 8;
    [self.bodyView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [self.contentView addSubview:self.bodyView];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.bottom.offset(0);
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
