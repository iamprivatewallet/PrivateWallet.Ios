//
//  UIFont+PW_Font.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#import "UIFont+PW_Font.h"

@implementation UIFont (PW_Font)

+ (instancetype)pw_regularFontOfSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
}
+ (instancetype)pw_boldFontOfSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}
+ (instancetype)pw_mediumFontOfSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}
+ (instancetype)pw_semiBoldFontOfSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
}
+ (instancetype)pw_thinFontOfSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size weight:UIFontWeightThin];
}
+ (instancetype)pw_heavyFontOfSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size weight:UIFontWeightHeavy];
}

@end
