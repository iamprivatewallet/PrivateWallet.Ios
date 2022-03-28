//
//  NodeTableViewCell.m
//  TokenWalletProject
//
//  Created by fchain on 2021/9/1.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "NodeTableViewCell.h"
@interface NodeTableViewCell()
@property (nonatomic, strong) UIImageView *checkImg;
@property (nonatomic, strong) UILabel *titleLbl;

@end
@implementation NodeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor im_tableBgColor];

        [self makeViews];
    }
    return self;
}

- (void)setViewWithData:(id)data{
    if ([data isKindOfClass:[NodeModel class]]) {
        NodeModel *model = data;
        self.titleLbl.text = model.node_name;
        NSString *url = User_manager.currentUser.current_Node;
        if ([model.node_url isEqualToString:url]) {
            self.checkImg.hidden = NO;
        }else{
            self.checkImg.hidden = YES;
        }
    }
    
}

- (void)makeViews{
    UIView *bgView = [ZZCustomView viewInitWithView:self.contentView bgColor:[UIColor whiteColor]];
    bgView.layer.cornerRadius = 8;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    self.checkImg = [ZZCustomView imageViewInitView:bgView imageName:@"checkBlue"];
    [self.checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(15);
        make.centerY.equalTo(bgView);
        make.width.height.equalTo(@15);
    }];
    self.titleLbl = [ZZCustomView labelInitWithView:bgView text:@"eee" textColor:[UIColor im_textColor_three] font:GCSFontMedium(14)];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkImg.mas_right).offset(10);
        make.centerY.equalTo(bgView);
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
