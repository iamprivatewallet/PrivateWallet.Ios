//
//  PW_SetDataViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SetDataViewController.h"
#import <TZImagePickerController.h>

@interface PW_SetDataViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextField *nickNameTf;
@property (nonatomic, strong) IQTextView *synopsisTv;
@property (nonatomic, strong) UIButton *uploadAvatarBtn;
@property (nonatomic, strong) UIImageView *avatarIv;
@property (nonatomic, strong) UIButton *deleteAvatarBtn;
@property (nonatomic, strong) UIButton *uploadBackgroundBtn;
@property (nonatomic, strong) UIImageView *backgroundIv;
@property (nonatomic, strong) UIButton *deleteBgBtn;

@end

@implementation PW_SetDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_setData")];
    [self makeViews];
}
- (void)deleteAvatarAction {
    self.avatarIv.image = nil;
    self.deleteAvatarBtn.hidden = YES;
}
- (void)deleteBgAction {
    self.backgroundIv.image = nil;
    self.deleteBgBtn.hidden = YES;
}
- (void)uploadAvatarAction {
    TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    vc.allowPickingVideo = NO;
    vc.allowTakeVideo = NO;
    [vc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count>0) {
            TZImagePickerController *cropVc = [[TZImagePickerController alloc] initCropTypeWithAsset:assets.firstObject photo:photos.firstObject completion:^(UIImage *cropImage, PHAsset *asset) {
                self.avatarIv.image = cropImage;
                self.deleteAvatarBtn.hidden = NO;
            }];
            cropVc.needCircleCrop = NO;
            CGSize size = cropVc.view.bounds.size;
            CGFloat imageW = 80;
            CGFloat iamgeH = 80;
            cropVc.cropRect = CGRectMake((size.width-imageW)/2, (size.height-iamgeH)/2, imageW, iamgeH);
            [self presentViewController:cropVc animated:YES completion:nil];
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)uploadBackgroundAction {
    TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    vc.allowPickingVideo = NO;
    vc.allowTakeVideo = NO;
    [vc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count>0) {
            TZImagePickerController *cropVc = [[TZImagePickerController alloc] initCropTypeWithAsset:assets.firstObject photo:photos.firstObject completion:^(UIImage *cropImage, PHAsset *asset) {
                self.backgroundIv.image = cropImage;
                self.deleteBgBtn.hidden = NO;
            }];
            cropVc.needCircleCrop = NO;
            CGSize size = cropVc.view.bounds.size;
            CGFloat imageW = 310;
            CGFloat iamgeH = 140;
            cropVc.cropRect = CGRectMake((size.width-imageW)/2, (size.height-iamgeH)/2, imageW, iamgeH);
            [self presentViewController:cropVc animated:YES completion:nil];
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)sureAction {
    
}
- (void)makeViews {
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [bodyView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [bodyView addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24);
        make.left.right.bottom.offset(0);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.width.equalTo(self.scrollView);
        make.height.mas_greaterThanOrEqualTo(self.scrollView);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_baseInfo") fontSize:15 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(36);
    }];
    UIView *nicknameView = [[UIView alloc] init];
    nicknameView.backgroundColor = [UIColor g_hex:@"#FCFAFA"];
    [nicknameView setBorderColor:[UIColor g_hex:@"#F6F4F5"] width:1 radius:6];
    [self.contentView addSubview:nicknameView];
    [nicknameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(22);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(95);
    }];
    UILabel *nicknameTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_nickname") fontSize:16 textColor:[UIColor g_textColor]];
    [nicknameView addSubview:nicknameTipLb];
    [nicknameTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(12);
    }];
    [nicknameView addSubview:self.nickNameTf];
    [self.nickNameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-15);
        make.top.offset(45);
        make.bottom.offset(-20);
    }];
    UIView *synopsisView = [[UIView alloc] init];
    synopsisView.backgroundColor = [UIColor g_hex:@"#FCFAFA"];
    [synopsisView setBorderColor:[UIColor g_hex:@"#F6F4F5"] width:1 radius:6];
    [self.contentView addSubview:synopsisView];
    [synopsisView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nicknameView.mas_bottom).offset(10);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(115);
    }];
    UILabel *synopsisTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_synopsis") fontSize:16 textColor:[UIColor g_textColor]];
    [synopsisView addSubview:synopsisTipLb];
    [synopsisTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(12);
    }];
    [synopsisView addSubview:self.synopsisTv];
    [self.synopsisTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-15);
        make.top.offset(45);
        make.bottom.offset(-15);
    }];
    UILabel *uploadTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_upload") fontSize:15 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:uploadTipLb];
    [uploadTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(synopsisView.mas_bottom).offset(30);
        make.left.offset(36);
    }];
    [self.contentView addSubview:self.uploadAvatarBtn];
    [self.uploadAvatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(34);
        make.top.equalTo(uploadTipLb.mas_bottom).offset(10);
        make.width.height.mas_equalTo(80);
    }];
    [self.uploadAvatarBtn addSubview:self.avatarIv];
    [self.avatarIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(3);
        make.bottom.right.offset(-3);
    }];
    [self.contentView addSubview:self.deleteAvatarBtn];
    [self.deleteAvatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.uploadAvatarBtn.mas_right);
        make.centerY.equalTo(self.uploadAvatarBtn.mas_top).offset(5);
    }];
    UILabel *uploadAvatarTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_avatarTip") fontSize:12 textColor:[[UIColor g_textColor] alpha:0.8]];
    [self.contentView addSubview:uploadAvatarTipLb];
    [uploadAvatarTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.uploadAvatarBtn);
        make.left.equalTo(self.uploadAvatarBtn.mas_right).offset(20);
    }];
    [self.contentView addSubview:self.uploadBackgroundBtn];
    [self.uploadBackgroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uploadAvatarBtn.mas_bottom).offset(22);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(140);
    }];
    UILabel *uploadBackgroundTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_backgroundImageTip") fontSize:12 textColor:[[UIColor g_textColor] alpha:0.8]];
    [self.uploadBackgroundBtn addSubview:uploadBackgroundTipLb];
    [uploadBackgroundTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-30);
        make.centerX.equalTo(self.uploadBackgroundBtn);
    }];
    [self.uploadBackgroundBtn addSubview:self.backgroundIv];
    [self.backgroundIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(3);
        make.bottom.right.offset(-3);
    }];
    [self.contentView addSubview:self.deleteBgBtn];
    [self.deleteBgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.uploadBackgroundBtn.mas_right);
        make.centerY.equalTo(self.uploadBackgroundBtn.mas_top).offset(5);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_sure") fontSize:15 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(sureAction)];
    [self.contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.uploadBackgroundBtn.mas_bottom).offset(40);
        make.bottom.mas_lessThanOrEqualTo(-20-PW_SafeBottomInset);
    }];
}
#pragma mark - lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
- (UITextField *)nickNameTf {
    if (!_nickNameTf) {
        _nickNameTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_nicknameTip")];
    }
    return _nickNameTf;
}
- (UITextView *)synopsisTv {
    if (!_synopsisTv) {
        _synopsisTv = [[IQTextView alloc] init];
        _synopsisTv.backgroundColor = [UIColor clearColor];
        _synopsisTv.font = [UIFont pw_regularFontOfSize:14];
        _synopsisTv.textColor = [UIColor g_textColor];
        _synopsisTv.placeholder = LocalizedStr(@"text_synopsisTip");
        _synopsisTv.placeholderTextColor = [UIColor g_placeholderColor];
    }
    return _synopsisTv;
}
- (UIButton *)uploadAvatarBtn {
    if (!_uploadAvatarBtn) {
        _uploadAvatarBtn = [PW_ViewTool buttonImageName:@"icon_add_pic" target:self action:@selector(uploadAvatarAction)];
        _uploadAvatarBtn.backgroundColor = [UIColor g_bgColor];
        _uploadAvatarBtn.layer.cornerRadius = 6;
        [_uploadAvatarBtn setShadowColor:[UIColor g_hex:@"#CCCCCC"] offset:CGSizeMake(0, 9) radius:18];
    }
    return _uploadAvatarBtn;
}
- (UIImageView *)avatarIv {
    if (!_avatarIv) {
        _avatarIv = [[UIImageView alloc] init];
        _avatarIv.contentMode = UIViewContentModeScaleAspectFill;
        _avatarIv.clipsToBounds = YES;
    }
    return _avatarIv;
}
- (UIButton *)deleteAvatarBtn {
    if (!_deleteAvatarBtn) {
        _deleteAvatarBtn = [PW_ViewTool buttonImageName:@"icon_close_pic" target:self action:@selector(deleteAvatarAction)];
        _deleteAvatarBtn.hidden = YES;
    }
    return _deleteAvatarBtn;
}
- (UIButton *)uploadBackgroundBtn {
    if (!_uploadBackgroundBtn) {
        _uploadBackgroundBtn = [PW_ViewTool buttonImageName:@"icon_add_pic" target:self action:@selector(uploadBackgroundAction)];
        _uploadBackgroundBtn.backgroundColor = [UIColor g_bgColor];
        _uploadBackgroundBtn.layer.cornerRadius = 6;
        [_uploadBackgroundBtn setShadowColor:[UIColor g_hex:@"#CCCCCC"] offset:CGSizeMake(0, 9) radius:18];
    }
    return _uploadBackgroundBtn;
}
- (UIImageView *)backgroundIv {
    if (!_backgroundIv) {
        _backgroundIv = [[UIImageView alloc] init];
        _backgroundIv.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundIv.clipsToBounds = YES;
    }
    return _backgroundIv;
}
- (UIButton *)deleteBgBtn {
    if (!_deleteBgBtn) {
        _deleteBgBtn = [PW_ViewTool buttonImageName:@"icon_close_pic" target:self action:@selector(deleteBgAction)];
        _deleteBgBtn.hidden = YES;
    }
    return _deleteBgBtn;
}

@end
