//
//  NodeSetTableCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/9/1.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "NodeSetTableCell.h"
@interface NodeSetTableCell()
@property (nonatomic, strong) UIImageView *checkImg;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;

@end
@implementation NodeSetTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeViews];
    }
    return self;
}

- (void)fillData:(id)data{
    if ([data isKindOfClass:[NodeModel class]]) {
        NodeModel *model = data;
        self.titleLbl.text = model.node_name;
        self.contentLbl.text = model.node_url;
        NSString *url = User_manager.currentUser.current_Node;
        if ([model.node_url isEqualToString:url]) {
            self.checkImg.hidden = NO;
        }else{
            self.checkImg.hidden = YES;
        }
    }
}

- (void)makeViews{
    self.checkImg = [ZZCustomView imageViewInitView:self.contentView imageName:@"checkBlue"];
    [self.checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@15);
    }];
    self.titleLbl = [ZZCustomView labelInitWithView:self.contentView text:@"eee" textColor:[UIColor im_textColor_three] font:GCSFontMedium(14)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkImg.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(12);
    }];
    self.contentLbl = [ZZCustomView labelInitWithView:self.contentView text:@"eee" textColor:[UIColor im_lightGrayColor] font:GCSFontMedium(12)];
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkImg.mas_right).offset(10);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(5);
    }];
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
