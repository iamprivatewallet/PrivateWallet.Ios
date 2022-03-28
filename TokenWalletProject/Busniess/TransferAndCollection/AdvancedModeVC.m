//
//  AdvancedModeVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/16.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AdvancedModeVC.h"

@interface AdvancedModeVC ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *placeholderLbl;

@end

@implementation AdvancedModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"高级模式" rightTitle:@"保存" rightAction:@selector(rightNavItemAction) isNoLine:YES];
    [self makeViews];
    // Do any additional setup after loading the view.
}
- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    UIView *bgView = [ZZCustomView viewInitWithView:self.view bgColor:[UIColor whiteColor]];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(CGFloatScale(191));
    }];
    
    UILabel *titleLbl = [ZZCustomView labelInitWithView:bgView text:@"Data" textColor:[UIColor im_textColor_six] font:GCSFontRegular(14)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(CGFloatScale(20));
        make.left.equalTo(bgView).offset(15);
    }];
    
    UIButton *imgBtn = [ZZCustomView buttonInitWithView:bgView imageName:@"suggested"];
    [imgBtn addTarget:self action:@selector(imgBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl);
        make.left.equalTo(titleLbl.mas_right).offset(5);
        make.width.height.mas_equalTo(20);
    }];
    UIView *textBgView = [ZZCustomView viewInitWithView:bgView bgColor:[UIColor navAndTabBackColor]];
    textBgView.layer.cornerRadius = 8;
    textBgView.layer.borderColor = [UIColor mp_lineGrayColor].CGColor;
    textBgView.layer.borderWidth = 1;
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl.mas_bottom).offset(15);
        make.left.equalTo(bgView).offset(15);
        make.right.equalTo(bgView).offset(-15);
        make.bottom.equalTo(bgView).offset(-25);
    }];
    UITextView *textView = [ZZCustomView textViewInitFrame:CGRectZero view:textBgView delegate:self font:GCSFontRegular(14) textColor:[UIColor im_textColor_three]];
    textView.backgroundColor = [UIColor navAndTabBackColor];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBgView).offset(8);
        make.top.equalTo(textBgView).offset(5);
        make.right.bottom.equalTo(textBgView).offset(-8);
    }];
    
    self.placeholderLbl = [ZZCustomView labelInitWithView:textView text:@"十六进制字符" textColor:[UIColor im_lightGrayColor] font:GCSFontRegular(14)];
    [self.placeholderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textView).offset(5);
        make.top.equalTo(textView).offset(8);
    }];
    
}
- (void)rightNavItemAction{
    //保存
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.placeholderLbl.hidden = YES;
    }else{
        self.placeholderLbl.hidden = NO;
    }
}
- (void)imgBtnAction{
    
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
