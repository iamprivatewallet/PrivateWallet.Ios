//
//  PW_AddressBookCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddressBookCell.h"

@interface PW_AddressBookCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *addressTypeLb;
@property (nonatomic, strong) UILabel *addressLb;
@property (nonatomic, strong) UILabel *noteLb;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation PW_AddressBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    self.deleteBtn.hidden = !isEdit;
}
- (void)setModel:(PW_AddressBookModel *)model {
    _model = model;
    self.nameLb.text = model.name;
    self.addressTypeLb.text = PW_StrFormat(@"%@：",model.chainName);
    self.addressLb.text = model.address;
    self.noteLb.text = model.note;
}
- (void)deleteAction {
    if (self.deleteBlock) {
        self.deleteBlock(self.model);
    }
}
- (void)makeViews {
    self.bodyView = [[UIView alloc] init];
    [self.bodyView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [self.bodyView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.bodyView];
    self.nameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_boldTextColor]];
    [self.bodyView addSubview:self.nameLb];
    self.addressTypeLb = [PW_ViewTool labelMediumText:@"--" fontSize:14 textColor:[UIColor g_grayTextColor]];
    [self.addressTypeLb setRequiredHorizontal];
    [self.bodyView addSubview:self.addressTypeLb];
    self.addressLb = [PW_ViewTool labelMediumText:@"--" fontSize:13 textColor:[UIColor g_boldTextColor]];
    [self.bodyView addSubview:self.addressLb];
    UILabel *noteTipLb = [PW_ViewTool labelMediumText:PW_StrFormat(@"%@：",LocalizedStr(@"text_note")) fontSize:14 textColor:[UIColor g_grayTextColor]];
    [noteTipLb setRequiredHorizontal];
    [self.bodyView addSubview:noteTipLb];
    self.noteLb = [PW_ViewTool labelMediumText:@"--" fontSize:13 textColor:[UIColor g_boldTextColor]];
    self.noteLb.numberOfLines = 3;
    [self.bodyView addSubview:self.noteLb];
    self.deleteBtn = [PW_ViewTool buttonImageName:@"icon_delete" target:self action:@selector(deleteAction)];
    self.deleteBtn.hidden = YES;
    [self.bodyView addSubview:self.deleteBtn];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.offset(8);
        make.bottom.offset(-8);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(10);
    }];
    [self.addressTypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.equalTo(self.nameLb.mas_bottom).offset(20);
    }];
    [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressTypeLb.mas_right).offset(8);
        make.top.equalTo(self.addressTypeLb);
        make.right.mas_lessThanOrEqualTo(-40);
    }];
    [noteTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.equalTo(self.addressLb.mas_bottom).offset(18);
    }];
    [self.noteLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noteTipLb.mas_right).offset(8);
        make.top.equalTo(noteTipLb);
        make.right.mas_lessThanOrEqualTo(-40);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-20);
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