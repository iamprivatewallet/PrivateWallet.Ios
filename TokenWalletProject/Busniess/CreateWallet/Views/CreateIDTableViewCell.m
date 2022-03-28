//
//  CreateIDTableViewCell.m
//  GCSWalletProject
//
//  Created by 馨媛 on 2021/7/20.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "CreateIDTableViewCell.h"
@interface CreateIDTableViewCell()
@property (nonatomic, strong) UITextField *textField;

@end
@implementation CreateIDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews{
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor navAndTabBackColor];
    bg.layer.cornerRadius = 8;
    bg.layer.borderColor = [UIColor mp_lineGrayColor].CGColor;
    bg.layer.borderWidth = 1;
    [self.contentView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(18);
        make.bottom.equalTo(self.contentView).offset(-12);
        make.right.equalTo(self.contentView).offset(-18);
    }];
    self.textField = [[UITextField alloc] init];
    [self.textField addTarget:self action:@selector(tfChangeAction) forControlEvents:UIControlEventValueChanged];
    self.textField.placeholder = @"身份名";
    [bg addSubview:self.textField];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bg).offset(18);
        make.top.equalTo(bg).offset(15);
        make.right.equalTo(bg).offset(-50);
    }];
}
- (void)tfChangeAction{
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
