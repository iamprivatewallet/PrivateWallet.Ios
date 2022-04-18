//
//  MessageCenterItemsView.m
//  TokenWalletProject
//
//  Created by FChain on 2021/9/24.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MessageCenterItemsView.h"

@interface MessageCenterItemsView()
@property (nonatomic, strong) UIButton *transferBtn;
@property (nonatomic, strong) UIButton *systemBtn;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation MessageCenterItemsView
static NSInteger beginTag = 100;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeViews];
    }
    return self;
}

- (void)makeViews{
    self.backgroundColor = [UIColor navAndTabBackColor];
    self.transferBtn = [ZZCustomView buttonInitWithView:self title:LocalizedStr(@"text_transferNoti") titleColor:[UIColor im_textColor_three] titleFont:GCSFontRegular(13)];
    [self.transferBtn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.transferBtn.tag = beginTag;
    [self.transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_centerX);
    }];
    self.systemBtn = [ZZCustomView buttonInitWithView:self title:LocalizedStr(@"text_systemMessage") titleColor:[UIColor im_textColor_three] titleFont:GCSFontRegular(13)];
    self.systemBtn.tag = beginTag+1;
    [self.systemBtn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.systemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_centerX);
    }];
    UIView *line = [ZZCustomView viewInitWithView:self bgColor:[UIColor im_borderLineColor]];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    self.bottomLine = [ZZCustomView viewInitWithView:self bgColor:[UIColor blackColor]];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.transferBtn);
        make.bottom.equalTo(self.transferBtn);
        make.height.equalTo(@2);
        make.width.equalTo(@40);
    }];
}

- (void)itemBtnAction:(UIButton *)sender{
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sender);
        make.bottom.equalTo(sender);
        make.height.equalTo(@2);
        make.width.equalTo(@40);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    if(self.clickBlock){
        self.clickBlock(sender.tag-beginTag);
    }
}
- (void)setIndex:(NSInteger)index {
    UIView *sender = [self viewWithTag:beginTag+index];
    if(sender==nil){return;}
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sender);
        make.bottom.equalTo(sender);
        make.height.equalTo(@2);
        make.width.equalTo(@40);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
