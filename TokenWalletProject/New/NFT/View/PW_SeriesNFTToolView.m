//
//  PW_SeriesNFTToolView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/31.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SeriesNFTToolView.h"
#import "PW_SegmentedControl.h"

@interface PW_SeriesNFTToolView ()

@property (nonatomic, strong) PW_SegmentedControl *segmentedControl;
@property (nonatomic, strong) UIButton *typesettingBtn;
@property (nonatomic, strong) UIButton *filtrateBtn;

@end

@implementation PW_SeriesNFTToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)typesettingAction {
    self.typesettingBtn.selected = !self.typesettingBtn.isSelected;
    if (self.typesettingBlock) {
        self.typesettingBlock(self.typesettingBtn.isSelected?1:0);
    }
}
- (void)filtrateAction {
    if (self.filtrateBlock) {
        self.filtrateBlock();
    }
}
- (void)makeViews {
    [self addSubview:self.segmentedControl];
    [self addSubview:self.typesettingBtn];
    [self addSubview:self.filtrateBtn];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.bottom.offset(0);
        make.width.mas_equalTo(246);
    }];
    [self.typesettingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.filtrateBtn.mas_left).offset(-20);
        make.centerY.offset(0);
    }];
    [self.filtrateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-25);
        make.centerY.offset(0);
    }];
}
#pragma mark - lazy
- (PW_SegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[PW_SegmentedControl alloc] init];
        _segmentedControl.dataArr = @[LocalizedStr(@"text_bazaar"),LocalizedStr(@"text_favorites"),LocalizedStr(@"text_follow")];
        _segmentedControl.selectedIndex = 0;
        __weak typeof(self) weakSelf = self;
        _segmentedControl.didClick = ^(NSInteger index) {
            weakSelf.typesettingBtn.hidden = weakSelf.filtrateBtn.hidden = index==2;
            if (weakSelf.segmentIndexBlock) {
                weakSelf.segmentIndexBlock(index);
            }
        };
    }
    return _segmentedControl;
}
- (UIButton *)typesettingBtn {
    if (!_typesettingBtn) {
        _typesettingBtn = [PW_ViewTool buttonImageName:@"icon_typesetting_grid" selectedImage:@"icon_typesetting_vertical" target:self action:@selector(typesettingAction)];
    }
    return _typesettingBtn;
}
- (UIButton *)filtrateBtn {
    if (!_filtrateBtn) {
        _filtrateBtn = [PW_ViewTool buttonImageName:@"icon_filtrate" target:self action:@selector(filtrateAction)];
    }
    return _filtrateBtn;
}

@end
