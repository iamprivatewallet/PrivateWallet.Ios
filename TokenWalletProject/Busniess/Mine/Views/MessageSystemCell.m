//
//  MessageSystemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/16.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "MessageSystemCell.h"

@interface MessageSystemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@end

@implementation MessageSystemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MessageSystemModel *)model {
    _model = model;
    self.titleLb.text = model.title;
    self.descLb.text = model.context;
    self.timeLb.text = model.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
