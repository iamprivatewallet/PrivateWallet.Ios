//
//  WalletLeftView.m
//  GCSWallet
//
//  Created by MM on 2020/10/13.
//

#import "WalletLeftView.h"
@interface WalletLeftView ()
@property (nonatomic, strong) NSMutableArray *unSelectList;
@property (nonatomic, strong) NSMutableArray *selectedList;
@property (nonatomic, strong) UIView *blueLine;

@end
@implementation WalletLeftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self refreshWalletLeftView];
    }
    return self;
}

- (void)refreshWalletLeftView{
    if (self.unSelectList.count >0) {
        [self.unSelectList removeAllObjects];
    }
    if (self.selectedList.count >0) {
        [self.selectedList removeAllObjects];
    }
    //获取默认钱包个数，并显示图片
    NSArray *orignList = [[WalletManager shareWalletManager] getOrignWallets];
    [self.unSelectList addObject:@"icon_gray_all"];
    [self.selectedList addObject:@"icon_all"];
    for (int i = 0; i< orignList.count; i++) {
        Wallet *w = orignList[i];
        NSString *icon = NSStringWithFormat(@"icon_%@",w.type);
        NSString *icon_gray = NSStringWithFormat(@"icon_gray_%@",w.type);
        [self.unSelectList addObject:icon_gray];
        [self.selectedList addObject:icon];
    }
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    [self makeSubviews];
}


- (void)makeSubviews {
    self.backgroundColor = [UIColor whiteColor];
    CGFloat item_w = CGFloatScale(60);
    UIView *lastView;
    for (int i = 0; i< self.unSelectList.count; i++) {
        UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tagButton.tag = i;
        [self addSubview:tagButton];
        [tagButton addTarget:self action:@selector(tagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(i==0 ? 5:i*item_w);
            make.height.mas_equalTo(CGFloatScale(60));
        }];
        UIImageView *image = [[UIImageView alloc] initWithImage:ImageNamed(self.unSelectList[i])];
        image.tag = 10+i;
        [self addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(tagButton);
            make.width.height.mas_equalTo(38);
        }];
        if (i == self.unSelectList.count-1) {
            lastView = tagButton;
        }
        UIView *blueLine = [[UIView alloc] init];
        blueLine.tag = 20+i;
        blueLine.hidden = YES;
        blueLine.backgroundColor = [UIColor im_blueColor];
        [tagButton addSubview:blueLine];
        [blueLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tagButton).offset(-5);
            make.centerY.equalTo(image);
            make.width.mas_equalTo(2.5);
            make.height.mas_equalTo(22);

        }];
    }
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = COLOR(251, 251, 252);
    [self addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(lastView);
        make.width.mas_equalTo(1);
    }];
    
    
}

- (void)tagButtonAction:(UIButton *)sender {
    [self makeDefaultImage];
    [self chooseItem:sender.tag];
    if ([self.delegate respondsToSelector:@selector(clickTagButtonIndex:)]){
        [self.delegate clickTagButtonIndex:sender.tag];
    }
}

- (void)chooseItem:(NSInteger)index{
    [self makeDefaultImage];
    UIImageView *icon = [self viewWithTag:index+10];
    icon.image = ImageNamed(self.selectedList[index]);
    UIButton *btn = [self viewWithTag:index];
    UIView *line = [btn viewWithTag:20+index];
    line.hidden = NO;
}

- (void)makeDefaultImage {
    for (int i=0; i< self.unSelectList.count; i++) {
        UIImageView *img = [self viewWithTag:10+i];
        img.image = ImageNamed(self.unSelectList[i]);
        UIButton *btn = [self viewWithTag:i];
        UIView *line = [btn viewWithTag:20+i];
        line.hidden = YES;
    }
}
- (NSMutableArray *)unSelectList{
    if (!_unSelectList) {
        _unSelectList = [[NSMutableArray alloc] init];
    }
    return _unSelectList;
}
- (NSMutableArray *)selectedList{
    if (!_selectedList) {
        _selectedList = [[NSMutableArray alloc] init];
    }
    return _selectedList;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
