//
//  DSError.h
//  DSWKWebView
//
//  Created by 张强 on 2020/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSError : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy)  NSString* message;
@property (nonatomic, copy) NSString *data;

@end

NS_ASSUME_NONNULL_END
