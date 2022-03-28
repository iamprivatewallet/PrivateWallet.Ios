//
//  MessageTransferCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/16.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "MessageTransferCell.h"

@interface MessageTransferCell()

@property (weak, nonatomic) IBOutlet UIImageView *stateIv;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@end

@implementation MessageTransferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(WalletRecord *)model {
    _model = model;
    self.titleLb.text = NSStringWithFormat(@"%@: %@ %@",model.token_name,model.amount,model.is_out?@"转账成功":@"收款成功");
    self.descLb.text = NSStringWithFormat(@"%@: %@",model.is_out?@"收款地址":@"发送地址",model.is_out?model.to_addr:model.from_addr);
    self.timeLb.text = model.create_time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
