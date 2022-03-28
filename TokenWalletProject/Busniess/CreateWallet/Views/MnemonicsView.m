//
//  MnemonicsView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/26.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MnemonicsView.h"
@interface MnemonicsView()
@property (nonatomic, strong) NSMutableArray *wordsList;
@end
@implementation MnemonicsView

- (instancetype)initWithFrame:(CGRect)frame words:(NSArray *)words
{
    self = [super initWithFrame:frame];
    if (self) {
        self.wordsList = [[NSMutableArray alloc] initWithArray:words];
        [self makeViews];
    }
    return self;
}
- (void)makeViews{
    self.backgroundColor = [UIColor im_inputBgColor];
    self.layer.cornerRadius = 8;
    self.layer.borderColor = [UIColor im_borderLineColor].CGColor;
    self.layer.borderWidth = 1;
        
    CGFloat item_w = self.width/3;
    CGFloat item_h = self.height/4;
    CGFloat item_margin = 12;
    
    for (int i = 0; i<2; i++) {
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = [UIColor im_borderLineColor];
        [self addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(item_w*(i+1));
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(1);
        }];
    }
    for (int i = 0; i<3; i++) {
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = [UIColor im_borderLineColor];
        [self addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(item_h*(i+1));
            make.left.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];
    }
    __block CGFloat current_x = 0;
    __block CGFloat current_y = 0;
    [self.wordsList enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL *stop) {
        UILabel *item = [ZZCustomView labelInitWithView:self text:text textColor:[UIColor blackColor] font:GCSFontRegular(16) textAlignment:NSTextAlignmentLeft];
        if (current_x==self.width) {
            current_x = 0;
            current_y += item_h;
        }
        
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(current_x+item_margin);
            make.top.equalTo(self).offset(current_y);
            make.size.mas_equalTo(CGSizeMake(item_w-item_margin, item_h));
        }];
        UILabel *numLbl = [ZZCustomView labelInitWithView:item text:NSStringWithFormat(@"%lu",idx+1) textColor:[UIColor im_textColor_nine] font:GCSFontRegular(10)];
        [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(item).offset(-5);
            make.top.equalTo(item).offset(5);
            make.width.height.mas_equalTo(13);
        }];
        
        current_x += item_w;

    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
