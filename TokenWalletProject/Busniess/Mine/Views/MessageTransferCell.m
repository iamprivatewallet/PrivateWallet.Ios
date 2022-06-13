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

- (void)setModel:(PW_TokenDetailModel *)model {
    _model = model;
    self.titleLb.text = NSStringWithFormat(@"%@: %@ %@",model.tokenName,model.value,model.isOut?LocalizedStr(@"text_tradeSuccess"):LocalizedStr(@"text_collectionSuccess"));
    self.descLb.text = NSStringWithFormat(@"%@: %@",model.isOut?@"to:":@"from:",model.isOut?model.toAddress:model.fromAddress);
    self.timeLb.text = model.timeStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
