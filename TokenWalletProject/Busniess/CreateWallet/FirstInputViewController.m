//
//  CreateUserIDViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/19.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "FirstInputViewController.h"
#import "CreateIDViewController.h"
#import "RecoveryIDViewController.h"
#import "ReadServiceView.h"

@interface FirstInputViewController ()
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *moveButton;

@end

@implementation FirstInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeViews];
    // Do any additional setup after loading the view.
}

- (void)createIdAction{
//    [ReadServiceView showServiceViewWithAction:^{
        CreateIDViewController *idVC = [[CreateIDViewController alloc] init];
        [self.navigationController pushViewController:idVC animated:YES];
//    }];
}
- (void)recoveryIdAction{
//    [ReadServiceView showServiceViewWithAction:^{
        RecoveryIDViewController *idVC = [[RecoveryIDViewController alloc] init];
        [self.navigationController pushViewController:idVC animated:YES];
//    }];   
}
- (void)makeViews{
    self.iconImage = [[UIImageView alloc] initWithImage:ImageNamed(@"create_icon")];
    [self.view addSubview:self.iconImage];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(CGFloatScale(363));
    }];
    
    self.moveButton = [ZZCustomView buttonInitWithView:self.view title:@" 如何迁移???钱包" titleColor:[UIColor im_blueColor] titleFont:GCSFontRegular(13)];
    [self.moveButton addTarget:self action:@selector(moveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.moveButton setImage:ImageNamed(@"help") forState:UIControlStateNormal];
    [self.moveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kBottomSafeHeight-CGFloatScale(30));
    }];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor mp_lineGrayColor].CGColor;
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(22);
        make.right.equalTo(self.view).offset(-22);
        make.bottom.equalTo(self.moveButton.mas_top).offset(-25);
        make.height.mas_equalTo(CGFloatScale(130));
    }];
    UIView *view1 = [self createItemWithTitle:@"创建身份" detailTitle:@"第一次使用钱包"];
    [self.bgView addSubview:view1];
    UITapGestureRecognizer *tag1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createIdAction)];
    [view1 addGestureRecognizer:tag1];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.height.mas_equalTo(CGFloatScale(130)/2);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor mp_lineGrayColor];
    [self.bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(18);
        make.right.equalTo(self.bgView);
        make.top.equalTo(view1.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UIView *view2 = [self createItemWithTitle:@"恢复身份" detailTitle:@"已拥有钱包"];
    [self.bgView addSubview:view2];
    UITapGestureRecognizer *tag2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recoveryIdAction)];
    [view2 addGestureRecognizer:tag2];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.bgView);
        make.height.equalTo(view1);
    }];
}

- (UIView *)createItemWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle{
    UIView *bgView = [[UIView alloc] init];
    UILabel *titleLbl = [ZZCustomView labelInitWithView:bgView text:title textColor:[UIColor im_blueColor] font:GCSFontRegular(15)];
    UILabel *detailLbl = [ZZCustomView labelInitWithView:bgView text:detailTitle textColor:COLOR(187, 194, 203) font:GCSFontRegular(13)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(18);
        make.top.equalTo(bgView).offset(18);
    }];
    [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLbl);
        make.top.equalTo(titleLbl.mas_bottom);
    }];
    UIImageView *icon = [ZZCustomView imageViewInitView:bgView imageName:@"arrow"];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-18);
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(13, 14));
    }];
    return bgView;
}

- (void)moveButtonAction{
    
   
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
