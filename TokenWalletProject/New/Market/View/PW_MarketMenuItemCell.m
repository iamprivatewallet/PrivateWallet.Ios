//
//  PW_MarketMenuItemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MarketMenuItemCell.h"

@interface PW_MarketMenuItemCell ()

@property (nonatomic, strong) PW_Button *titleBtn;

@end

@implementation PW_MarketMenuItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleBtn = [PW_Button buttonWithType:UIButtonTypeCustom];
        self.titleBtn.userInteractionEnabled = NO;
        [self.titleBtn setTitleColor:[UIColor g_darkTextColor] forState:UIControlStateNormal];
        [self.titleBtn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateSelected];
        [self.titleBtn pw_setNormalFont:[UIFont pw_semiBoldFontOfSize:15] selectedFont:[UIFont pw_semiBoldFontOfSize:17]];
        [self.contentView addSubview:self.titleBtn];
        [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
        }];
    }
    return self;
}
- (void)setModel:(PW_MarketMenuModel *)model {
    _model = model;
    [self.titleBtn setTitle:model.title forState:UIControlStateNormal];
    self.titleBtn.selected = model.selected;
    self.contentView.backgroundColor = model.selected?[UIColor g_bgColor]:[UIColor clearColor];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    CGSize size = layoutAttributes.size;
    size.width = [self.model.title boundingRectWithSize:CGSizeMake(MAXFLOAT, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont pw_semiBoldFontOfSize:17]} context:nil].size.width+30;
    layoutAttributes.size = size;
    return layoutAttributes;
}

@end
