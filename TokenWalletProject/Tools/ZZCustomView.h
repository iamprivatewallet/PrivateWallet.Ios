//
//  CustomView.h
//  QDJob
//
//  Created by yinxiufeng on 15/7/1.
//  Copyright (c) 2015年 qidong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZZCustomView : NSObject



#pragma mark -

#pragma mark UIView
+(UIView *)viewInitWithView:(UIView *)view
                      bgColor:(UIColor *)bgColor;


+(UIView *)normalTableViewHeaderFrame:(CGRect)frame
                                title:(NSString *)title;


#pragma mark -

#pragma mark UILabel

+(UILabel *)labelInitWithView:(UIView *)view
                          text:(NSString *)text;

+(UILabel *)labelInitWithView:(UIView *)view
                          text:(NSString *)text
                     textColor:(UIColor *)textColor;

+(UILabel *)labelInitWithView:(UIView *)view
                          text:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font;

+(UILabel *)labelInitWithView:(UIView *)view
                          text:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font
                 textAlignment:(NSTextAlignment)textAlignment;

#pragma mark -

#pragma mark UIButton
+(UIButton *)im_buttonInitWithView:(UIView *)view
                           title:(NSString *)title
                       titleFont:(UIFont *)titleFont
                      titleColor:(UIColor *)titleColor
                     isHighlighted:(BOOL)isHighlighted;

+(UIButton *)buttonInitWithView:(UIView *)view
                      imageName:(NSString *)imgName;

+(UIButton *)im_ButtonDefaultWithView:(UIView *)view
                                title:(NSString *)title
                            titleFont:(UIFont *)titleFont
                               enable:(BOOL)enable;

+(UIButton *)buttonInitWithView:(UIView *)view
                           title:(NSString *)title;

+(UIButton *)buttonInitWithView:(UIView *)view
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor;

+(UIButton *)buttonInitWithView:(UIView *)view
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont;

+(UIButton *)buttonInitWithView:(UIView *)view
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                         bgColor:(UIColor *)bgColor;


+(UIButton *)buttonInitWithView:(UIView *)view
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                         bgColor:(UIColor *)bgColor
                    normalImage :(NSString *)normalImage
                highlightedImage:(NSString *)highlightedImage;

+(UIButton *)normalButtonInitWithDoneBtnView:(UIView *)view
                                  title:(NSString *)title
                                   font:(UIFont *)font
                              isAUsable:(BOOL)isUsable;

#pragma mark -

#pragma mark UIImageView

+(UIImageView *)imageViewInitView:(UIView *)view
                             image:(UIImage *)image;

+(UIImageView *)imageViewInitView:(UIView *)view
                             image:(UIImage *)image
                           bgColor:(UIColor *)bgColor;

+(UIImageView *)imageViewInitView:(UIView *)view
                         imageName:(NSString *)imageName;

+(UIImageView *)imageViewInitView:(UIView *)view
                         imageName:(NSString *)imageName
                           bgColor:(UIColor *)bgColor;
#pragma mark -

#pragma mark UITextField

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view;

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder;

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate;

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font;

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor;

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor;

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor
                      keyboardType:(UIKeyboardType)keyboardType;

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor
                      keyboardType:(UIKeyboardType)keyboardType
                     returnKeyType:(UIReturnKeyType)returnKeyType;

+(UITextField *)textFieldInitFrame:(CGRect)frame
                              view:(UIView *)view
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate
                              font:(UIFont *)font
                         textColor:(UIColor *)textColor
                           bgColor:(UIColor *)bgColor
                      keyboardType:(UIKeyboardType)keyboardType
                     returnKeyType:(UIReturnKeyType)returnKeyType
                   clearButtonMode:(UITextFieldViewMode)clearButtonMode;

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
                       borderStyle:(UITextBorderStyle)borderStyle;

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
                          leftView:(UIView *)leftView;

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
                         rightView:(UIView *)rightView;

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
                   secureTextEntry:(BOOL)secureTextEntry;


+(UITextField *)NormaltextFieldInitFrame:(CGRect)frame view:(UIView *)view placeholder:(NSString *)placeholder;

#pragma mark -

#pragma mark UITextView

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view;

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view
                        delegate:(id)delegate;

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view
                        delegate:(id)delegate
                            font:(UIFont *)font;

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view
                        delegate:(id)delegate
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor;

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view
                        delegate:(id)delegate
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor
                    keyboardType:(UIKeyboardType)keyboardType;

+(UITextView *)textViewInitFrame:(CGRect)frame
                            view:(UIView *)view
                        delegate:(id)delegate
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor
                    keyboardType:(UIKeyboardType)keyboardType
                   returnKeyType:(UIReturnKeyType)returnKeyType;


#pragma mark -

#pragma mark UIScrollView

+(UIScrollView *)scrollViewInitFrame:(CGRect)frame
                                view:(UIView *)view
                         contentSize:(CGSize)contentSize;

+(UIScrollView *)scrollViewInitFrame:(CGRect)frame
                                view:(UIView *)view
                         contentSize:(CGSize)contentSize
                            delegate:(id)delegate;

+(UIScrollView *)scrollViewInitFrame:(CGRect)frame
                                view:(UIView *)view
                         contentSize:(CGSize)contentSize
                            delegate:(id)delegate
                             bgColor:(UIColor *)bgColor;


#pragma mark -

#pragma mark UISegmentedControl

+(UISegmentedControl *)segmentedControlInitFrame:(CGRect)frame
                                            view:(UIView *)view
                                           array:(NSArray *)array;

+(UISegmentedControl *)segmentedControlInitFrame:(CGRect)frame
                                            view:(UIView *)view
                                           array:(NSArray *)array
                            selectedSegmentIndex:(NSInteger)selectedSegmentIndex;

+(UISegmentedControl *)segmentedControlInitFrame:(CGRect)frame
                                            view:(UIView *)view
                                           array:(NSArray *)array
                            selectedSegmentIndex:(NSInteger)selectedSegmentIndex
                                         bgColor:(UIColor *)bgColor;

+(UISegmentedControl *)segmentedControlInitFrame:(CGRect)frame
                                            view:(UIView *)view
                                           array:(NSArray *)array
                            selectedSegmentIndex:(NSInteger)selectedSegmentIndex
                                         bgColor:(UIColor *)bgColor
                                     normalColor:(UIColor *)normalColor
                                   selectedColor:(UIColor *)selectedColor;

#pragma mark -

#pragma mark UITableView

+(UITableView *)tableViewInitFrame:(CGRect)frame
                              view:(UIView *)view
                          delegate:(id)delegate
                        dataSource:(id)dataSource;

+(UITableView *)tableViewInitFrame:(CGRect)frame
                              view:(UIView *)view
                          delegate:(id)delegate
                        dataSource:(id)dataSource
                    separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;

+(UITableView *)tableViewInitFrame:(CGRect)frame
                              view:(UIView *)view
                          delegate:(id)delegate
                        dataSource:(id)dataSource
                    separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
                     scrollEnabled:(BOOL)scrollEnabled;

+(UITableView *)tableViewInitFrame2:(CGRect)frame
                              view:(UIView *)view
                          delegate:(id)delegate
                        dataSource:(id)dataSource
                    separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
                     scrollEnabled:(BOOL)scrollEnabled tableviewstyle:(UITableViewStyle)style;

+(UITableView *)tableViewInitFrame:(CGRect)frame
                              view:(UIView *)view
                          delegate:(id)delegate
                        dataSource:(id)dataSource
                    separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
                     scrollEnabled:(BOOL)scrollEnabled
                           bgColor:(UIColor *)bgColor tableviewstyle:(UITableViewStyle)style;

#pragma mark -



#pragma mark UIActivityIndicatorView
+(UIActivityIndicatorView *)activityIndicatorView:(CGRect)frame
                                             view:(UIView *)view;


+(UIButton *)doneBtninitFrame:(CGRect)frame
                         view:(UIView *)view
                       target:(id)target
                     selector:(SEL)selector
                      title:(NSString *)title;


@end
