//
//  PW_DappBanner2Cell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappBanner2Cell.h"

@interface PW_DappBanner2Cell ()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIImageView *leftIv;
@property (nonatomic, strong) UILabel *leftTitleLb;
@property (nonatomic, strong) UIImageView *rightIv;
@property (nonatomic, strong) UILabel *rightTitleLb;

@end

@implementation PW_DappBanner2Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftView];
        [self.contentView addSubview:self.rightView];
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(36);
            make.top.offset(26);
            make.bottom.offset(0);
        }];
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftView.mas_right).offset(16);
            make.top.bottom.equalTo(self.leftView);
            make.right.offset(-36);
            make.width.equalTo(self.leftView);
        }];
    }
    return self;
}
- (void)setDataArr:(NSArray<PW_BannerModel *> *)dataArr {
    _dataArr = dataArr;
    if (dataArr.count>0) {
        PW_BannerModel *model = dataArr.firstObject;
        [self.leftIv sd_setImageWithURL:[NSURL URLWithString:model.imgH5]];
        self.leftTitleLb.text = model.title;
    }
    if (dataArr.count>1) {
        PW_BannerModel *model = dataArr[1];
        [self.rightIv sd_setImageWithURL:[NSURL URLWithString:model.imgH5]];
        self.rightTitleLb.text = model.title;
    }
}
- (void)btn1Action {
    if (self.clickBlock&&self.dataArr.count>0) {
        self.clickBlock(self.dataArr[0]);
    }
}
- (void)btn2Action {
    if (self.clickBlock&&self.dataArr.count>1) {
        self.clickBlock(self.dataArr[1]);
    }
}
- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
        [_leftView setCornerRadius:8];
        [_leftView addSubview:self.leftIv];
        [_leftView addSubview:self.leftTitleLb];
        [self.leftTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.height.offset(28);
        }];
        [self.leftIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.equalTo(self.leftTitleLb.mas_top).offset(0);
        }];
        [_leftView addTapTarget:self action:@selector(btn1Action)];
    }
    return _leftView;
}
- (UIImageView *)leftIv {
    if (!_leftIv) {
        _leftIv = [[UIImageView alloc] init];
        _leftIv.contentMode = UIViewContentModeScaleAspectFill;
        _leftIv.clipsToBounds = YES;
    }
    return _leftIv;
}
- (UILabel *)leftTitleLb {
    if (!_leftTitleLb) {
        _leftTitleLb = [PW_ViewTool labelText:@"--" fontSize:15 textColor:[UIColor g_whiteTextColor]];
        _leftTitleLb.textAlignment = NSTextAlignmentCenter;
        _leftTitleLb.backgroundColor = [UIColor g_hex:@"#6200EE"];
    }
    return _leftTitleLb;
}
- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
        [_rightView setCornerRadius:8];
        [_rightView addSubview:self.rightIv];
        [_rightView addSubview:self.rightTitleLb];
        [self.rightTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.height.offset(28);
        }];
        [self.rightIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.equalTo(self.rightTitleLb.mas_top).offset(0);
        }];
        [_rightView addTapTarget:self action:@selector(btn2Action)];
    }
    return _rightView;
}
- (UIImageView *)rightIv {
    if (!_rightIv) {
        _rightIv = [[UIImageView alloc] init];
        _rightIv.contentMode = UIViewContentModeScaleAspectFill;
        _rightIv.clipsToBounds = YES;
    }
    return _rightIv;
}
- (UILabel *)rightTitleLb {
    if (!_rightTitleLb) {
        _rightTitleLb = [PW_ViewTool labelText:@"--" fontSize:15 textColor:[UIColor g_whiteTextColor]];
        _rightTitleLb.textAlignment = NSTextAlignmentCenter;
        _rightTitleLb.backgroundColor = [UIColor g_hex:@"#6200EE"];
    }
    return _rightTitleLb;
}

@end
