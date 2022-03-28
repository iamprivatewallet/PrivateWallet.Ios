//
//  IDInfoViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/5.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "IDInfoViewController.h"
#import "SubscribeToMailView.h"
@interface IDInfoViewController ()
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, strong) UIButton *detailBtn;

@end

@implementation IDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"身份信息"];
    [self makeViews];
    // Do any additional setup after loading the view.
}

- (void)makeViews{
    [self.view addSubview:self.tableView];
    self.isSetRadius = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)helpButtonAction{
    
}
- (void)detailButtonAction{
    
}
#pragma mark delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 1) {
//        return 2;
//    }
//    return 1;
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"idCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSString *str;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(20);
            make.centerY.equalTo(cell.contentView);
        }];
//        if (indexPath.section == 0) {
//            str = @"身份ID";
//
//            [cell.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(cell.contentView).offset(20);
//                make.top.equalTo(cell.contentView).offset(15);
//            }];
//
//            self.detailBtn = [ZZCustomView im_buttonInitWithView:cell.contentView title:@"" titleFont:GCSFontRegular(13) titleColor:[UIColor im_textLightGrayColor] isHighlighted:YES];
//            [self.detailBtn addTarget:self action:@selector(detailButtonAction) forControlEvents:UIControlEventTouchUpInside];
//            [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(cell.contentView).offset(20);
//                make.top.equalTo(cell.textLabel.mas_bottom);
//            }];
//
//            UIButton *helpBtn = [ZZCustomView buttonInitWithView:cell.contentView imageName:@"helpBlack"];
//            [helpBtn addTarget:self action:@selector(helpButtonAction) forControlEvents:UIControlEventTouchUpInside];
//            [helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(cell.textLabel.mas_right).offset(6);
//                make.centerY.equalTo(cell.textLabel);
//                make.width.height.mas_equalTo(15);
//            }];
//        }else if(indexPath.section == 1){
            if (indexPath.row == 0) {
                str = @"头像";
                UIImageView *userIcon = [ZZCustomView imageViewInitView:cell.contentView imageName:@"defaultAvatar"];
                [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView).offset(-20);
                    make.centerY.equalTo(cell.contentView);
                    make.width.height.mas_equalTo(50);
                }];
                
            }else{
                str = @"身份名";
                self.detailLbl = [ZZCustomView labelInitWithView:cell.contentView text:@"" textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(15)];
                [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView).offset(-50);
                    make.centerY.equalTo(cell.contentView);
                }];
            }
//        }else{
//            str = @"邮箱";
//        }
        cell.textLabel.text = str;
        cell.textLabel.textColor = [UIColor im_textColor_three];
        cell.textLabel.font = GCSFontRegular(16);
        if ((indexPath.section == 1 && indexPath.row == 1 ) || indexPath.section == 2) {
            UIImageView *arrowImg = [ZZCustomView imageViewInitView:cell.contentView imageName:@"arrowRightGray"];
            [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-CGFloatScale(20));
                make.size.mas_equalTo(CGSizeMake(CGFloatScale(15), CGFloatScale(15)));
                make.centerY.equalTo(cell.contentView);
            }];
        }
    }
    [self.detailBtn setTitle:@"" forState:UIControlStateNormal];
    self.detailLbl.text = User_manager.currentUser.user_name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 1) {
//        return CGFloatScale(66);
//    }else if (indexPath.section == 2) {
//        return CGFloatScale(55);
//    }else{
//        return CGFloatScale(70);
//    }
    return CGFloatScale(55);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return CGFloatScale(40);
    }
    return CGFloatScale(20);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 2) {
//        UIView *bgView = [[UIView alloc] init];
//        UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGFloatScale(20), 8, ScreenWidth, 30)];
//        textLbl.text = @"订阅。。。最新资讯";
//        textLbl.textColor = [UIColor im_textColor_nine];
//        textLbl.font = GCSFontRegular(16);
//        [bgView addSubview:textLbl];
//        return bgView;
//    }
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
//    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            [TokenAlertView showViewWithTitle:@"修改身份名" textField_p:User_manager.currentUser.user_name action:^(NSInteger index, NSString * _Nonnull inputText) {
                [User_manager updateUserName:inputText];
                [self.tableView reloadData];
            }];
        }
//    }else if(indexPath.section == 2){
//        [SubscribeToMailView showMailViewWithAction:^(NSString * _Nonnull emailStr) {
//
//        }];
//    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
