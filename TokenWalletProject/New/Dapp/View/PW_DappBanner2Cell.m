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
@property (nonatomic, strong) UIImageView *rightIv;

@end

@implementation PW_DappBanner2Cell

+ (CGSize)getItemSize {
    CGFloat width = (SCREEN_WIDTH-52)/2;
    return CGSizeMake(width, width*254/354);
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftView];
        [self.contentView addSubview:self.rightView];
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(26);
            make.top.offset(0);
            make.bottom.offset(0);
        }];
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftView.mas_right).offset(0);
            make.top.bottom.equalTo(self.leftView);
            make.right.offset(-26);
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
    }
    if (dataArr.count>1) {
        PW_BannerModel *model = dataArr[1];
        [self.rightIv sd_setImageWithURL:[NSURL URLWithString:model.imgH5]];
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
        [_leftView addSubview:self.leftIv];
        [self.leftIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        [_leftView addTapTarget:self action:@selector(btn1Action)];
    }
    return _leftView;
}
- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
        [_rightView addSubview:self.rightIv];
        [self.rightIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        [_rightView addTapTarget:self action:@selector(btn2Action)];
    }
    return _rightView;
}
- (UIImageView *)leftIv {
    if (!_leftIv) {
        _leftIv = [[UIImageView alloc] init];
        _leftIv.contentMode = UIViewContentModeScaleAspectFit;
        _leftIv.clipsToBounds = YES;
    }
    return _leftIv;
}
- (UIImageView *)rightIv {
    if (!_rightIv) {
        _rightIv = [[UIImageView alloc] init];
        _rightIv.contentMode = UIViewContentModeScaleAspectFit;
        _rightIv.clipsToBounds = YES;
    }
    return _rightIv;
}

@end
