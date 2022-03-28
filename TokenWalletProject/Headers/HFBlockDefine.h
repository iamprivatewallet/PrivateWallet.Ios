//
//  HFBlockDefine.h
//  HyperFund
//
//  Created by 孙林林 on 2020/7/7.
//  Copyright © 2020 HyperTech. All rights reserved.
//

#ifndef HFBlockDefine_h
#define HFBlockDefine_h

typedef void(^HFFinishBlk)(BOOL success, NSError *error);
typedef void(^HFFinishDicBlk)(BOOL success, NSDictionary *dic, NSError *error);
typedef void(^HFFinishAlertTxtBlk)(BOOL success, NSString *text, NSError *error);
typedef void(^HFFinishArrBlk)(BOOL success, NSArray *arr, NSError *error);

#endif /* HFBlockDefine_h */
