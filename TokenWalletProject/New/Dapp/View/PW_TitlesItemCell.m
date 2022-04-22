//
//  PW_TitlesItemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TitlesItemCell.h"

@interface PW_TitlesItemCell ()

@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_TitlesItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLb = [PW_ViewTool labelSemiboldText:@"" fontSize:16 textColor:[UIColor g_grayTextColor]];
        self.titleLb.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
        }];
    }
    return self;
}
- (void)setTitle:(NSString *)title selected:(BOOL)selected {
    self.titleLb.text = title;
    self.titleLb.textColor = selected?[UIColor g_boldTextColor]:[UIColor g_grayTextColor];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    CGSize size = layoutAttributes.size;
    size.width = [self.titleLb.text boundingRectWithSize:CGSizeMake(MAXFLOAT, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont pw_semiBoldFontOfSize:16]} context:nil].size.width+10;
    layoutAttributes.size = size;
    return layoutAttributes;
}

@end
