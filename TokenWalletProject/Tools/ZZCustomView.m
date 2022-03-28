//
//  CustomView.m
//  QDJob
//
//  Created by yinxiufeng on 15/7/1.
//  Copyright (c) 2015年 qidong. All rights reserved.
//

#import "ZZCustomView.h"
@interface ZZCustomView ()

@end

@implementation ZZCustomView


#pragma mark -

#pragma mark UIView
+(UIView *)viewInitWithView:(UIView *)view
                      bgColor:(UIColor *)bgColor
{
    UIView *uiView = [[UIView alloc]init];
    uiView.backgroundColor = bgColor;
    [view addSubview:uiView];
    return uiView;
}

#pragma mark -

#pragma mark UILabel


+(UILabel *)labelInitWithView:(UIView *)view
                          text:(NSString *)text
{
    return [self labelInitWithView:view text:text textColor:nil font:nil textAlignment:0];
}

+(UILabel *)labelInitWithView:(UIView *)view
                          text:(NSString *)text
                     textColor:(UIColor *)textColor
{
    return [self labelInitWithView:view text:text textColor:textColor font:nil textAlignment:0];
}

+(UILabel *)labelInitWithView:(UIView *)view
                          text:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font
{
    return [self labelInitWithView:view text:text textColor:textColor font:font textAlignment:0];
}

+(UILabel *)labelInitWithView:(UIView *)view
                          text:(NSString *)text
                     textColor:(UIColor *)textColor
                         font:(UIFont *)font
                 textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    if(textColor)
    {
        label.textColor = textColor;
    }
    if(font)
    {
       label.font = font;
    }
    if(textAlignment)
    {
      label.textAlignment = textAlignment;
    }
    label.numberOfLines = 0;
    [view addSubview:label];
    return label;
}

#pragma mark -

#pragma mark UIButton
+(UIButton *)im_ButtonDefaultWithView:(UIView *)view
                                title:(NSString *)title
                            titleFont:(UIFont *)titleFont
                               enable:(BOOL)enable{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = titleFont;
    btn.layer.cornerRadius = 8;
    if (enable) {
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [UIColor im_btnSelectColor];

    }else{
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = [UIColor im_btnUnSelectColor];

    }
    [view addSubview:btn];
    return btn;
    
}
+(UIButton *)im_buttonInitWithView:(UIView *)view
                           title:(NSString *)title
                       titleFont:(UIFont *)titleFont
                      titleColor:(UIColor *)titleColor
                     isHighlighted:(BOOL)isHighlighted
                              {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    if (isHighlighted) {
        [btn setTitleColor:[UIColor im_lightGrayColor] forState:UIControlStateHighlighted];
    }
                                  btn.titleLabel.numberOfLines = 0;

    btn.titleLabel.font = titleFont;
    
    [view addSubview:btn];
    return btn;
    
}
+(UIButton *)buttonInitWithView:(UIView *)view
                      imageName:(NSString *)imgName
{
    return [self buttonInitWithView:view title:nil titleColor:nil titleFont:nil bgColor:nil normalImage:imgName highlightedImage:nil];
}

+(UIButton *)buttonInitWithView:(UIView *)view
                           title:(NSString *)title
{
    return [self buttonInitWithView:view title:title titleColor:nil titleFont:nil bgColor:nil normalImage:nil highlightedImage:nil];
}

+(UIButton *)buttonInitWithView:(UIView *)view
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
{
    return [self buttonInitWithView:view title:title titleColor:titleColor titleFont:nil bgColor:nil normalImage:nil highlightedImage:nil];
}

+(UIButton *)buttonInitWithView:(UIView *)view
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
{
    return [self buttonInitWithView:view title:title titleColor:titleColor titleFont:titleFont bgColor:nil normalImage:nil highlightedImage:nil];
}

+(UIButton *)buttonInitWithView:(UIView *)view
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                         bgColor:(UIColor *)bgColor
{
    return [self buttonInitWithView:view title:title titleColor:titleColor titleFont:titleFont bgColor:bgColor normalImage:nil highlightedImage:nil];
}


+(UIButton *)buttonInitWithView:(UIView *)view
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                         bgColor:(UIColor *)bgColor
                    normalImage :(NSString *)normalImage
                highlightedImage:(NSString *)highlightedImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    if(titleColor)
    {
        [btn setTitleColor: titleColor forState:UIControlStateNormal];
    }
    if(titleFont)
    {
        btn.titleLabel.font = titleFont;
    }
    if(bgColor)
    {
        btn.backgroundColor = bgColor;
    }
    if(normalImage){
        [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    }
    if(highlightedImage){
        [btn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    }
    [view addSubview:btn];
    return btn;
}


+(UIButton *)normalButtonInitWithDoneBtnFrame:(CGRect)frame
                                         view:(UIView *)view
                                        title:(NSString *)title
                                         font:(UIFont *)font
                                    isAUsable:(BOOL)isUsable{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.layer.cornerRadius = kRealValue(4);
    btn.layer.masksToBounds = YES;
    if (isUsable) {
        btn.backgroundColor = [UIColor UIColorWithHexColorString:@"#12AAA1" AndAlpha:1];
        btn.userInteractionEnabled = YES;
    }else{
        btn.backgroundColor = [UIColor UIColorWithHexColorString:@"#C9D4D3" AndAlpha:1];
        btn.userInteractionEnabled = NO;
    }
    
    [view addSubview:btn];
    return btn;
}

#pragma mark -

#pragma mark UIImageView

+(UIImageView *)imageViewInitView:(UIView *)view
                             image:(UIImage *)image
{
    return [self imageViewInitView:view image:image bgColor:nil];
}

+(UIImageView *)imageViewInitView:(UIView *)view
                             image:(UIImage *)image
                           bgColor:(UIColor *)bgColor
{
    UIImageView *imageView = [[UIImageView alloc]init];
    if(image)
    {
        imageView.image = image;
    }
    if(bgColor)
    {
        imageView.backgroundColor = bgColor;
    }

    [view addSubview:imageView];
    return imageView;
}

+(UIImageView *)imageViewInitView:(UIView *)view
                         imageName:(NSString *)imageName
{
    return [self imageViewInitView:view imageName:imageName bgColor:nil];
}

+(UIImageView *)imageViewInitView:(UIView *)view
                         imageName:(NSString *)imageName
                           bgColor:(UIColor *)bgColor
{
    UIImageView *imageView = [[UIImageView alloc]init];
    if(imageName)
    {
        imageView.image = [UIImage imageNamed:imageName];
    }
    if(bgColor)
    {
        imageView.backgroundColor = bgColor;
    }
    [view addSubview:imageView];
    return imageView;
}

#pragma mark -

#pragma mark UITextField


+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
{
    return [self textFieldInitFrame:frame view:view placeholder:nil delegate:nil font:nil textColor:nil bgColor:nil keyboardType:0 returnKeyType:0 clearButtonMode:0 borderStyle:0 leftView:nil rightView:nil secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
{
    return [self textFieldInitFrame:frame view:view placeholder:placeholder delegate:nil font:nil textColor:nil bgColor:nil keyboardType:0 returnKeyType:0 clearButtonMode:0 borderStyle:0 leftView:nil rightView:nil secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
{
    return [self textFieldInitFrame:frame view:view placeholder:placeholder delegate:delegate font:nil textColor:nil bgColor:nil keyboardType:0 returnKeyType:0 clearButtonMode:0 borderStyle:0 leftView:nil rightView:nil secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
{
    return [self textFieldInitFrame:frame view:view placeholder:placeholder delegate:delegate font:font textColor:nil bgColor:nil keyboardType:0 returnKeyType:0 clearButtonMode:0 borderStyle:0 leftView:nil rightView:nil secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
{
    return [self textFieldInitFrame:frame view:view placeholder:placeholder delegate:delegate font:font textColor:textColor bgColor:nil keyboardType:0 returnKeyType:0 clearButtonMode:0 borderStyle:0 leftView:nil rightView:nil secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor
{
    return [self textFieldInitFrame:frame view:view placeholder:placeholder delegate:delegate font:font textColor:textColor bgColor:bgColor keyboardType:0 returnKeyType:0 clearButtonMode:0 borderStyle:0 leftView:nil rightView:nil secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor
                      keyboardType:(UIKeyboardType)keyboardType
{
    return [self textFieldInitFrame:frame view:view placeholder:placeholder delegate:delegate font:font textColor:textColor bgColor:bgColor keyboardType:keyboardType returnKeyType:0 clearButtonMode:0 borderStyle:0 leftView:nil rightView:nil secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor
                      keyboardType:(UIKeyboardType)keyboardType
                     returnKeyType:(UIReturnKeyType)returnKeyType
{
    return [self textFieldInitFrame:frame view:view placeholder:placeholder delegate:delegate font:font textColor:textColor bgColor:bgColor keyboardType:keyboardType returnKeyType:returnKeyType clearButtonMode:0 borderStyle:0 leftView:nil rightView:nil secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor
                      keyboardType:(UIKeyboardType)keyboardType
                     returnKeyType:(UIReturnKeyType)returnKeyType
                   clearButtonMode:(UITextFieldViewMode)clearButtonMode
{
    return [self textFieldInitFrame:frame view:view placeholder:placeholder delegate:delegate font:font textColor:textColor bgColor:bgColor keyboardType:keyboardType returnKeyType:returnKeyType clearButtonMode:clearButtonMode borderStyle:0 leftView:nil rightView:nil secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor
                      keyboardType:(UIKeyboardType)keyboardType
                     returnKeyType:(UIReturnKeyType)returnKeyType
                   clearButtonMode:(UITextFieldViewMode)clearButtonMode
                       borderStyle:(UITextBorderStyle)borderStyle
{
    return [self textFieldInitFrame:frame view:view placeholder:placeholder delegate:delegate font:font textColor:textColor bgColor:bgColor keyboardType:keyboardType returnKeyType:returnKeyType clearButtonMode:clearButtonMode borderStyle:borderStyle leftView:nil rightView:nil secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor
                      keyboardType:(UIKeyboardType)keyboardType
                     returnKeyType:(UIReturnKeyType)returnKeyType
                   clearButtonMode:(UITextFieldViewMode)clearButtonMode
                       borderStyle:(UITextBorderStyle)borderStyle
                          leftView:(UIView *)leftView
{
    return [self textFieldInitFrame:frame view:view placeholder:placeholder delegate:delegate font:font textColor:textColor bgColor:bgColor keyboardType:keyboardType returnKeyType:returnKeyType clearButtonMode:clearButtonMode borderStyle:borderStyle leftView:leftView rightView:nil secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor
                      keyboardType:(UIKeyboardType)keyboardType
                     returnKeyType:(UIReturnKeyType)returnKeyType
                   clearButtonMode:(UITextFieldViewMode)clearButtonMode
                       borderStyle:(UITextBorderStyle)borderStyle
                          leftView:(UIView *)leftView
                         rightView:(UIView *)rightView
{
    return [self textFieldInitFrame:frame view:view placeholder:placeholder delegate:delegate font:font textColor:textColor bgColor:bgColor keyboardType:keyboardType returnKeyType:returnKeyType clearButtonMode:clearButtonMode borderStyle:borderStyle leftView:leftView rightView:rightView secureTextEntry:NO];
}

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor
                      keyboardType:(UIKeyboardType)keyboardType
                     returnKeyType:(UIReturnKeyType)returnKeyType
                   clearButtonMode:(UITextFieldViewMode)clearButtonMode
                       borderStyle:(UITextBorderStyle)borderStyle
                          leftView:(UIView *)leftView
                         rightView:(UIView *)rightView
                   secureTextEntry:(BOOL)secureTextEntry

{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    if(placeholder)
    {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:placeholder];
        [att addAttributes:@{NSForegroundColorAttributeName:[UIColor im_inputPlaceholderColor]} range:NSMakeRange(0, placeholder.length)];
        textField.attributedPlaceholder = att;
    }
    if(delegate)
    {
        textField.delegate = delegate;
    }
    if(font)
    {
        textField.font = font;
    }
    if(textColor)
    {
        textField.textColor = textColor;
    }
    if(bgColor)
    {
        textField.backgroundColor = bgColor;
    }
    if(keyboardType)
    {
        textField.keyboardType = keyboardType;
    }
    if(returnKeyType)
    {
        textField.returnKeyType = returnKeyType;
    }
    if(clearButtonMode)
    {
        textField.clearButtonMode = clearButtonMode;
    }
    if(borderStyle)
    {
        textField.borderStyle = borderStyle;
    }
    if(leftView)
    {
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    if(rightView)
    {
        textField.rightView =rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    if(secureTextEntry)
    {
        textField.secureTextEntry = YES;
    }
    [view addSubview:textField];
    return textField;
}


+(UITextField *)NormaltextFieldInitFrame:(CGRect)frame view:(UIView *)view placeholder:(NSString *)placeholder{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kRealValue(14)], NSForegroundColorAttributeName:[UIColor UIColorWithHexColorString:@"000000" AndAlpha:0.25]}];
    [textField setAttributedPlaceholder:str];
    [self setTextFieldLeftPadding:textField forWidth:kRealValue(12)];
    textField.layer.cornerRadius = kRealValue(4);
    textField.layer.masksToBounds = YES;
    textField.backgroundColor = [UIColor UIColorWithHexColorString:@"000000" AndAlpha:0.04];
    [view addSubview:textField];
    return textField;
}

+(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

#pragma mark -

#pragma mark UITextView

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view
{
    return [self textViewInitFrame:frame view:view delegate:nil font:nil textColor:nil keyboardType:0 returnKeyType:0];
}

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view
                        delegate:(id)delegate
{
    return [self textViewInitFrame:frame view:view delegate:delegate font:nil textColor:nil keyboardType:0 returnKeyType:0];
}

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view
                        delegate:(id)delegate
                            font:(UIFont *)font
{
    return [self textViewInitFrame:frame view:view delegate:delegate font:font textColor:nil keyboardType:0 returnKeyType:0];
}

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view
                        delegate:(id)delegate
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor
{
    return [self textViewInitFrame:frame view:view delegate:delegate font:font textColor:textColor keyboardType:0 returnKeyType:0];
}

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view
                        delegate:(id)delegate
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor
                    keyboardType:(UIKeyboardType)keyboardType
{
    return [self textViewInitFrame:frame view:view delegate:delegate font:font textColor:textColor keyboardType:keyboardType returnKeyType:0];
}

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view
                        delegate:(id)delegate
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor
                    keyboardType:(UIKeyboardType)keyboardType
                   returnKeyType:(UIReturnKeyType)returnKeyType

{
    UITextView *textView = [[UITextView alloc]initWithFrame:frame];
    if(delegate)
    {
        textView.delegate = delegate;
    }
    if(font)
    {
        textView.font = font;
    }
    if(textColor)
    {
        textView.textColor = textColor;
    }
    if(keyboardType)
    {
        textView.keyboardType = keyboardType;
    }
    if(returnKeyType)
    {
        textView.returnKeyType = returnKeyType;
    }
    [view addSubview:textView];
    return textView;
}


#pragma mark -

#pragma mark UIScrollView

+(UIScrollView *)scrollViewInitFrame:(CGRect)frame
                                view:(UIView *)view
                         contentSize:(CGSize)contentSize
{
    return [self scrollViewInitFrame:frame view:view contentSize:contentSize delegate:nil bgColor:nil];
}

+(UIScrollView *)scrollViewInitFrame:(CGRect)frame
                                view:(UIView *)view
                         contentSize:(CGSize)contentSize
                            delegate:(id)delegate
{
    return [self scrollViewInitFrame:frame view:view contentSize:contentSize delegate:delegate bgColor:nil];
}

+(UIScrollView *)scrollViewInitFrame:(CGRect)frame
                                view:(UIView *)view
                         contentSize:(CGSize)contentSize
                            delegate:(id)delegate
                             bgColor:(UIColor *)bgColor
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame];
    scrollView.contentSize = contentSize;
    if(delegate)
    {
      scrollView.delegate = delegate;
    }
    if(bgColor)
    {
        scrollView.backgroundColor = bgColor;
    }
    [view addSubview:scrollView];
    return scrollView;
}


#pragma mark -

#pragma mark UISegmentedControl

+(UISegmentedControl *)segmentedControlInitFrame:(CGRect)frame
                                            view:(UIView *)view
                                           array:(NSArray *)array
{
    return [self segmentedControlInitFrame:frame view:view array:array selectedSegmentIndex:0 bgColor:nil normalColor:nil selectedColor:nil];
}

+(UISegmentedControl *)segmentedControlInitFrame:(CGRect)frame
                                            view:(UIView *)view
                                           array:(NSArray *)array
                            selectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    return [self segmentedControlInitFrame:frame view:view array:array selectedSegmentIndex:selectedSegmentIndex bgColor:nil normalColor:nil selectedColor:nil];
}

+(UISegmentedControl *)segmentedControlInitFrame:(CGRect)frame
                                            view:(UIView *)view
                                           array:(NSArray *)array
                            selectedSegmentIndex:(NSInteger)selectedSegmentIndex
                                         bgColor:(UIColor *)bgColor
{
    return [self segmentedControlInitFrame:frame view:view array:array selectedSegmentIndex:selectedSegmentIndex bgColor:bgColor normalColor:nil selectedColor:nil];
}

+(UISegmentedControl *)segmentedControlInitFrame:(CGRect)frame
                                           view:(UIView *)view
                                          array:(NSArray *)array
                           selectedSegmentIndex:(NSInteger)selectedSegmentIndex
                                        bgColor:(UIColor *)bgColor
                                    normalColor:(UIColor *)normalColor
                                  selectedColor:(UIColor *)selectedColor
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:array];
    segmentedControl.frame =  frame;
    segmentedControl.selectedSegmentIndex = selectedSegmentIndex;
    if(bgColor)
    {
        segmentedControl.tintColor =  bgColor;
    }
    if(normalColor)
    {
        NSDictionary *dictionaryNormal = [NSDictionary dictionaryWithObjectsAndKeys:normalColor,UITextAttributeTextColor, nil];
        NSDictionary *dictionarySelected = [NSDictionary dictionaryWithObjectsAndKeys:selectedColor,UITextAttributeTextColor, nil];
        [segmentedControl setTitleTextAttributes:dictionaryNormal forState:UIControlStateNormal];
        [segmentedControl setTitleTextAttributes:dictionarySelected forState:UIControlStateSelected];

    }
    [view addSubview:segmentedControl];
    return segmentedControl;
}

#pragma mark -

#pragma mark UITableView

+(UITableView *)tableViewInitFrame:(CGRect)frame
                              view:(UIView *)view
                          delegate:(id)delegate
                        dataSource:(id)dataSource
{
   return [self tableViewInitFrame:frame view:view delegate:delegate dataSource:dataSource separatorStyle:0 scrollEnabled:YES bgColor:nil tableviewstyle:UITableViewStylePlain];
}

+(UITableView *)tableViewInitFrame:(CGRect)frame
                              view:(UIView *)view
                          delegate:(id)delegate
                        dataSource:(id)dataSource
                    separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
{
   return [self tableViewInitFrame:frame view:view delegate:delegate dataSource:dataSource separatorStyle:separatorStyle scrollEnabled:NO bgColor:nil tableviewstyle:UITableViewStylePlain];
}

+(UITableView *)tableViewInitFrame:(CGRect)frame
                              view:(UIView *)view
                          delegate:(id)delegate
                        dataSource:(id)dataSource
                    separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
                     scrollEnabled:(BOOL)scrollEnabled
{
    return [self tableViewInitFrame:frame view:view delegate:delegate dataSource:dataSource separatorStyle:separatorStyle scrollEnabled:scrollEnabled bgColor:nil tableviewstyle:UITableViewStylePlain];
}

+(UITableView *)tableViewInitFrame2:(CGRect)frame
                              view:(UIView *)view
                          delegate:(id)delegate
                        dataSource:(id)dataSource
                    separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
                     scrollEnabled:(BOOL)scrollEnabled tableviewstyle:(UITableViewStyle)style
{
    return [self tableViewInitFrame:frame view:view delegate:delegate dataSource:dataSource separatorStyle:separatorStyle scrollEnabled:scrollEnabled bgColor:nil tableviewstyle:style];
}


+(UITableView *)tableViewInitFrame:(CGRect)frame
                              view:(UIView *)view
                          delegate:(id)delegate
                        dataSource:(id)dataSource
                    separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
                     scrollEnabled:(BOOL)scrollEnabled
                           bgColor:(UIColor *)bgColor tableviewstyle:(UITableViewStyle)style
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:style];
    tableView.delegate = delegate;
    tableView.dataSource = dataSource;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.tableHeaderView = [[UIView alloc]init];
    tableView.separatorStyle = separatorStyle;
    
    tableView.scrollEnabled = scrollEnabled;
    
    if(bgColor)
    {
        tableView.backgroundColor = bgColor;
    }
    if (view) {
        [view addSubview:tableView];
    }
    
    return tableView;
}

#




#pragma mark UIActivityIndicatorView
+(UIActivityIndicatorView *)activityIndicatorView:(CGRect)frame view:(UIView *)view
{
    UIActivityIndicatorView *activityView =[[UIActivityIndicatorView  alloc]initWithFrame:frame];
    activityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    activityView.hidesWhenStopped=YES;
    [view addSubview:activityView];
    return activityView;
}

+(UIButton *)doneBtninitFrame:(CGRect)frame
    view:(UIView *)view
  target:(id)target
selector:(SEL)selector
 title:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (view) {
        [view addSubview:btn];
    }
    btn.frame = frame;
    btn.layer.cornerRadius = kRealValue(3);
    btn.layer.masksToBounds = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor monies_BrownColor] forState:UIControlStateNormal];
    [btn addGradientLayer:CGSizeMake(kRealValue(335), kRealValue(50)) withColorArr:@[COLORFORRGB(0xFFD200),COLORFORRGB(0xF5A309)] withStartPoint:CGPointMake(0, 0.5) withEndPoint:CGPointMake(1, 0.5)];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:kRealValue(14)];
    if (target && selector) {
        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

@end
