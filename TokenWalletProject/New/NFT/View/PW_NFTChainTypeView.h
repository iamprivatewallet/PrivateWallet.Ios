//
//  PW_NFTChainTypeView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
@class PW_NFTChainTypeModel;

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTChainTypeView : UIView

@property (nonatomic, copy) NSArray<PW_NFTChainTypeModel *> *dataArr;
@property (nonatomic, copy) void(^clickBlock)(PW_NFTChainTypeModel *model);
- (void)showInView:(UIView *)view;
- (void)dismiss;

@end

@interface PW_NFTChainTypeCell : PW_BaseTableCell

@property (nonatomic, strong) PW_NFTChainTypeModel *model;

@end

@interface PW_NFTChainTypeModel : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, nullable) NSString *chainId;
@property (nonatomic, copy) void(^clickBlock)(PW_NFTChainTypeModel *model);
+ (instancetype)modelWithTitle:(NSString *)title imageName:(NSString *)imageName chainId:(nullable NSString *)chainId;

@end


NS_ASSUME_NONNULL_END
