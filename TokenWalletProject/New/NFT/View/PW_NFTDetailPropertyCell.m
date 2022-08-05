//
//  PW_NFTDetailPropertyCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/5.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTDetailPropertyCell.h"

@interface PW_NFTDetailPropertyCell ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *descLb;

@end

@implementation PW_NFTDetailPropertyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.descLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.centerY.offset(0);
    }];
    [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.centerY.offset(0);
    }];
}
#pragma mark - lazy
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _titleLb;
}
- (UILabel *)descLb {
    if (!_descLb) {
        _descLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _descLb;
}

@end
