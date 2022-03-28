//
//  WalletTagView.m
//  TokenWalletProject
//
//  Created by jackygood on 2018/12/2.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "WalletTagView.h"
#import "SKTagView.h"
#import "HexColors.h"

#define bg_margin 20
@interface WalletTagView()

@property BOOL isEdit;
@property BOOL isError;
@property (nonatomic, strong) SKTagView *wordView;
@property (nonatomic, strong) SKTagView *editView;
@property (nonatomic, strong) SKTagView *optionView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) NSMutableArray *orignArray;
@property (nonatomic, strong) NSMutableArray *shuffleOrignArray;
@property (nonatomic, strong) NSMutableArray *shuffleOrignCopyArray;
@property (nonatomic, strong) NSMutableArray *inputArray;

@property(nonatomic,assign) NSInteger originalButtonCount;
@property(nonatomic,assign) NSInteger inputButtonCount;

@end
@implementation WalletTagView

-(instancetype)initWithFrame:(CGRect)frame isEdit:(BOOL)isEdit words:(NSArray*)words
{
    self.isEdit = isEdit;
    self.isError = NO;
    if (self = [super initWithFrame:frame]) {
        self.orignArray = [[NSMutableArray alloc] initWithArray:words];
        self.inputArray = [[NSMutableArray alloc] init];
        self.shuffleOrignArray = [[NSMutableArray alloc] initWithArray:[self.orignArray bjl_shuffledArray]];
        self.shuffleOrignCopyArray = [[NSMutableArray alloc] initWithArray:self.shuffleOrignArray];
        self.originalButtonCount = _orignArray.count;
        self.inputButtonCount = 0;
        
        if (isEdit) {
//            [self addSubview:self.infoLabel];
            [self addSubview:self.editView];
            [self addSubview:self.optionView];
            [self fillOptionView];
        }else{
            [self addSubview:self.wordView];
            [self fillWordView];
        }
    }
    return self;
}
-(SKTagView *)wordView
{
    if (!_wordView) {
        _wordView = ({
            SKTagView *view = [SKTagView new];
            view.backgroundColor = [UIColor im_tagViewColor];
            view.padding = UIEdgeInsetsMake(CGFloatScale(10), CGFloatScale(12), CGFloatScale(10), CGFloatScale(12));
            view.interitemSpacing = CGFloatScale(11);
            view.lineSpacing = CGFloatScale(10);
            view.layer.cornerRadius = 5;
            view.didTapTagAtIndex = ^(NSUInteger index){
                NSLog(@"tap index::%ld",index);
            };
            view;
        });
        _wordView.frame = CGRectMake(0, 0, self.width, self.height);
    }
    return _wordView;
}

- (UILabel*)infoLabel{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.textColor = [UIColor redColor];
        _infoLabel.text = @"助记词填写错误！";
        _infoLabel.font = GCSFontRegular(14);
        _infoLabel.hidden = YES;
    }
    return _infoLabel;
}
-(SKTagView *)editView
{
    if (!_editView) {
        _editView = ({
            SKTagView *view = [SKTagView new];
            view.backgroundColor = [UIColor im_tagViewColor];
            view.layer.borderColor = [UIColor im_borderLineColor].CGColor;
            view.layer.borderWidth = 1;
            view.padding = UIEdgeInsetsMake(CGFloatScale(10), CGFloatScale(12), CGFloatScale(10), CGFloatScale(12));
            view.interitemSpacing = CGFloatScale(11);
            view.lineSpacing = CGFloatScale(10);
            view.layer.cornerRadius = 8;
            view.didTapTagAtIndex = ^(NSUInteger index){
                NSLog(@"tap index::%ld",index);
                
            };
            view;
        });
        _editView.frame = CGRectMake(0, 0, self.width, self.height/2);
    }
    return _editView;
}

-(SKTagView *)optionView
{
    if (!_optionView) {
        _optionView = ({
            SKTagView *view = [SKTagView new];
            view.backgroundColor = [UIColor whiteColor];
            view.padding = UIEdgeInsetsMake(0, 0, 0, CGFloatScale(12));
            view.interitemSpacing = CGFloatScale(11);
            view.backgroundColor = [UIColor clearColor];
            view.lineSpacing = CGFloatScale(10);
            view.didTapTagAtIndex = ^(NSUInteger index){
                NSLog(@"_optionView tap index::%ld",index);
                NSString *tagText = self.shuffleOrignCopyArray[index];
                SKTag *tag = [SKTag tagWithText:tagText];
                
                if (self.isError) {
                    [self.editView removeTagAtIndex:self.inputArray.count-1];
                    self.isError = NO;
                    [self.inputArray removeLastObject];
                    self.inputButtonCount--;
                    if (self.inputButtonCount < 0) {
                        self.inputButtonCount = 0;
                    }
                }
                
                if ([self.orignArray[self.inputButtonCount] isEqualToString:tagText]) {
                    [self dl_configTag:tag withIndex:self.inputButtonCount];
                    
                    [self.editView insertTag:tag atIndex:self.inputButtonCount];
                    self.inputButtonCount ++ ;
                    [self.inputArray addObject:tagText];
                    
//                    [self.shuffleOrignCopyArray removeObjectAtIndex:index];
//
                    [self.optionView changeTagAtIndex:index];
                    
                    self.infoLabel.hidden = YES;
                }else{
                    [self error_configTag:tag withIndex:self.inputButtonCount];
                    
                    [self.editView insertTag:tag atIndex:self.inputButtonCount];
                    self.inputButtonCount++ ;
                    
                    [self.inputArray addObject:tagText];
                    self.isError = YES;
                    self.infoLabel.hidden = NO;
                }
                if (self.inputArray.count == self.orignArray.count) {
                    [self checkIsFinished];
                }
                
            };
            view;
        });
        _optionView.frame = CGRectMake(0, self.height/2+20, self.width, self.height/2);
    }
    return _optionView;
}

#pragma methods

-(void)dl_configTag:(SKTag *)tag withIndex:(NSUInteger)index
{
    tag.padding = UIEdgeInsetsMake(12, 12, 12, 12);
    tag.nrmColor = [UIColor clearColor];
    tag.bgColor = [UIColor whiteColor];
    tag.borderColor = [UIColor mp_lineGrayColor];
    tag.borderWidth = 1;
    tag.cornerRadius = 8;

}
-(void)dl_configOptionTag:(SKTag *)tag withIndex:(NSUInteger)index
{
    tag.padding = UIEdgeInsetsMake(12, 12, 12, 12);
    tag.nrmColor = [UIColor clearColor];
    tag.bgColor = [UIColor whiteColor];
    tag.borderColor = [UIColor mp_lineGrayColor];
    tag.borderWidth = 1;
    tag.cornerRadius = 8;

}
-(void)error_configTag:(SKTag *)tag withIndex:(NSUInteger)index
{
    tag.textColor = [UIColor redColor];
    tag.padding = UIEdgeInsetsMake(12, 12, 12, 12);

    tag.nrmColor = [UIColor clearColor];
    tag.bgColor =[UIColor whiteColor];
    tag.borderColor = [UIColor mp_lineGrayColor];
    tag.borderWidth = 1;
    tag.cornerRadius = 8;
}

- (void)fillWordView{
    [self.orignArray enumerateObjectsUsingBlock: ^(NSString *text, NSUInteger idx, BOOL *stop) {
        SKTag *tag = [SKTag tagWithText: text];
        [self dl_configTag:tag withIndex:idx];
        [self.wordView addTag:tag];
    }];
}
// Edit view
- (void)fillOptionView{
    [self.shuffleOrignArray enumerateObjectsUsingBlock: ^(NSString *text, NSUInteger idx, BOOL *stop) {
        SKTag *tag = [SKTag tagWithText: text];
        [self dl_configOptionTag:tag withIndex:idx];
        [self.optionView addTag:tag];
    }];
}

- (void)checkIsFinished{
    self.isFinished = NO;
    if ([self.inputArray isEqualToArray:self.orignArray]) {
        self.isFinished = YES;
    }
}

@end
