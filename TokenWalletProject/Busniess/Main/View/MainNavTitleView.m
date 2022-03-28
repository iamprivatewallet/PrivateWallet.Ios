//
//  MainNavTitleView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/29.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MainNavTitleView.h"
@interface MainNavTitleView()
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, copy) void(^clickBlock)(void);
@end
@implementation MainNavTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeTitleView];
    }
    return self;
}
- (void)setViewWithData:(id)data{
    if ([data isKindOfClass:[NodeModel class]]) {
        NodeModel *model = data;
        self.contentLbl.text = model.node_name;
    }else if([data isKindOfClass:[NSString class]]){
        self.contentLbl.text = data;
    }
}
- (void)makeTitleView{
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapAction)];
    [bgView addGestureRecognizer:tap];

    self.contentLbl = [ZZCustomView labelInitWithView:bgView text:User_manager.currentUser.current_name textColor:[UIColor im_blueColor] font:GCSFontRegular(11)];
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).offset(-8);
        make.centerX.equalTo(bgView).offset(-3);
    }];
    self.arrowImg = [[UIImageView alloc] initWithImage:ImageNamed(@"main_downarrow")];
    [bgView addSubview:self.arrowImg];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLbl.mas_right).offset(CGFloatScale(5));
        make.centerY.equalTo(self.contentLbl);
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(10), CGFloatScale(10)));
    }];
    
    self.titleLbl = [ZZCustomView labelInitWithView:bgView text:@"钱包" textColor:[UIColor im_textColor_three] font:GCSFontRegular(13)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentLbl.mas_top);
        make.centerX.equalTo(bgView);
    }];
}

- (void)bgTapAction{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)clickNode:(void(^)(void))action{
    self.clickBlock = action;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
