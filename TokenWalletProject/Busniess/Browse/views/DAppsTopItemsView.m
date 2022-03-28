//
//  DappsTopItemsView.m
//  TokenWalletProject
//
//  Created by FChain on 2021/9/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "DAppsTopItemsView.h"
@interface DAppsTopItemsView()
@property (nonatomic, strong) UIView *line;
@end
@implementation DAppsTopItemsView

- (void)makeViewsWithArr:(NSArray *)list{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    UIView *lastView = nil;
    for (int i = 0; i < list.count; i++) {
        UIButton *itemBtn = [ZZCustomView buttonInitWithView:self title:list[i] titleColor:[UIColor im_textColor_six] titleFont:GCSFontRegular(13)];
        itemBtn.tag = i;
        [itemBtn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView?lastView.mas_right : self).offset(lastView?30:15);
            make.bottom.equalTo(self).offset(-2);
        }];
        if (i == 0) {
            [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.line = [ZZCustomView viewInitWithView:self bgColor:[UIColor im_textColor_three]];
            [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(itemBtn);
                make.bottom.equalTo(self);
                make.height.equalTo(@2);
                make.width.equalTo(@25);
            }];
        }
        lastView = itemBtn;
    }
}

- (void)itemBtnAction:(UIButton *)sender{
    for(UIButton *btn in self.subviews){
        [btn setTitleColor:[UIColor im_textColor_six] forState:UIControlStateNormal];
    }
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sender);
        make.bottom.equalTo(self);
        make.height.equalTo(@2);
        make.width.equalTo(@25);
    }];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if(self.changeItemBlock){
        self.changeItemBlock(sender.tag);
    }
}

@end
