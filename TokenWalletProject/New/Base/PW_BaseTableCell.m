//
//  PW_BaseTableCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"

@implementation PW_BaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor g_bgColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (self.selectionStyle != UITableViewCellSelectionStyleNone){
        if (highlighted) {
            self.backgroundColor = [UIColor g_grayBgColor];
        }else{
            self.backgroundColor = [UIColor g_bgColor];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
