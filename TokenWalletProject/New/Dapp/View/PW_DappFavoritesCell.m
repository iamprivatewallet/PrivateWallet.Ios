//
//  PW_DappFavoritesCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/15.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappFavoritesCell.h"

@interface PW_DappFavoritesCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *favoriteBtn;

@end

@implementation PW_DappFavoritesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self makeViews];
    }
    return self;
}
- (void)favoriteAction {
    if (self.favoriteBlock) {
        self.favoriteBlock(self.model);
    }
}
- (void)setModel:(PW_DappModel *)model{
    _model = model;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    self.titleLb.text = model.appUrl;
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.titleLb];
    [self.bodyView addSubview:self.favoriteBtn];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.offset(0);
        make.width.height.offset(46);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(12);
        make.centerY.offset(0);
        make.right.mas_lessThanOrEqualTo(0);
    }];
    [self.favoriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if(!_bodyView) {
        _bodyView = [[UIView alloc] init];
    }
    return _bodyView;
}
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
    }
    return _iconIv;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelText:@"--" fontSize:18 textColor:[UIColor g_textColor]];
    }
    return _titleLb;
}
- (UIButton *)favoriteBtn {
    if (!_favoriteBtn) {
        _favoriteBtn = [PW_ViewTool buttonImageName:@"icon_star" selectedImage:@"icon_star_full" target:self action:@selector(favoriteAction)];
        _favoriteBtn.selected = YES;
    }
    return _favoriteBtn;
}

@end
