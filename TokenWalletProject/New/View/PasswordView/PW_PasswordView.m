//
//  PW_PasswordView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/22.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_PasswordView.h"

static NSInteger MAXCOUNT = 6;
static CGFloat SPACE = 16;
static NSString *SECURESTR = @"●";

@interface PW_PasswordView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) NSMutableArray<UILabel *> *numLbArr;

@end

@implementation PW_PasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
        [self addTapTarget:self action:@selector(becomeFirstResponder)];
        __weak typeof(self) weakSelf = self;
        [self.pwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            if (x.length==0) {
                [weakSelf setupText:weakSelf.pwdTF.text];
            }else if([x isInt]&&x.length<=MAXCOUNT){
                [weakSelf setupText:weakSelf.pwdTF.text ];
            }else{
                weakSelf.pwdTF.text = weakSelf.text;
            }
        }];
    }
    return self;
}
- (void)setupText:(NSString *)text {
    [self setupText:text noti:YES];
}
- (void)setupText:(NSString *)text noti:(BOOL)noti {
    _text = text;
    for (NSInteger i=0; i<self.numLbArr.count; i++) {
        UILabel *numLb = self.numLbArr[i];
        if (i<text.length) {
            numLb.text = SECURESTR;
        }else{
            numLb.text = @"";
        }
    }
    if(noti) {
        if (self.changeBlock) {
            self.changeBlock(self, text);
        }
        if (text.length==MAXCOUNT&&self.completeBlock) {
            self.completeBlock(self, text);
        }
    }
}
- (void)becomeFirstResponder {
    [super becomeFirstResponder];
    [self.pwdTF becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    [self.pwdTF resignFirstResponder];
    return [super resignFirstResponder];
}
- (void)reset {
    self.pwdTF.text = @"";
    [self setupText:@"" noti:NO];
}
- (void)makeViews {
    [self addSubview:self.pwdTF];
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    for (NSInteger i=0; i<MAXCOUNT; i++) {
        UILabel *numLb = [PW_ViewTool labelMediumText:@"" fontSize:14 textColor:[UIColor g_textColor]];
        numLb.textAlignment = NSTextAlignmentCenter;
        [numLb setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
        [self addSubview:numLb];
        [self.numLbArr addObject:numLb];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    NSInteger count = self.numLbArr.count;
    CGFloat itemW = (size.width-(count-1)*SPACE)/count;
    for (NSInteger i=0; i<count; i++) {
        UILabel *numLb = self.numLbArr[i];
        numLb.frame = CGRectMake(i*(SPACE+itemW), 0, itemW, size.height);
    }
}
#pragma mark - lazy
- (UITextField *)pwdTF {
    if (!_pwdTF) {
        _pwdTF = [PW_ViewTool textFieldFont:[UIFont pw_mediumFontOfSize:16] color:[UIColor g_textColor] placeholder:nil];
        _pwdTF.hidden = YES;
        _pwdTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _pwdTF;
}
- (NSMutableArray<UILabel *> *)numLbArr {
    if (!_numLbArr) {
        _numLbArr = [NSMutableArray array];
    }
    return _numLbArr;
}

@end
