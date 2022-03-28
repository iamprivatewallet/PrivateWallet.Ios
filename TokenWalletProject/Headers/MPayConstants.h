//
//  MPayConstants.h
//  MPay
//
//  Created by Hyper on 8/11/20.
//  Copyright © 2020 Hyper. All rights reserved.
//

#ifndef MPayConstants_h
#define MPayConstants_h

#define isOnline      0
#define isTest        1
#define isABTest      0
#define isDevelop     0


#if isOnline  //**** 生产↓ ****/

#define MPayNeedForceUpdate 1
#define MPaygIndex          0
#define MPay_H5Hosts        @"https://m2.moniesbank.io"
#define MPay_Share_Hosts    @"https://m2.moniesbank.io"
#else

#if isTest  //**** 测试↓ ****/

#define MPayNeedForceUpdate 1
#define MPaygIndex          1
#define MPay_H5Hosts        @"http://m2-test.hypercode.me"
#define MPay_Share_Hosts    @"http://m2-test.hypercode.me"

#else

#if isABTest  //**** 灰度↓ ****/

#define MPayNeedForceUpdate 1
#define MPaygIndex          2
#define MPay_H5Hosts        @"http://m2-stage.hypercode.me"
#define MPay_Share_Hosts    @"http://m2-stage.hypercode.me"

#else

#if isDevelop  //**** 开发↓ ****/

#define MPayNeedForceUpdate 0
#define MPaygIndex          3
#define MPay_H5Hosts        @"http://m2-test.hypercode.me/"
#define MPay_Share_Hosts    @"http://m2-test.hypercode.me/"

#else

#endif
#endif
#endif
#endif

#endif /* MPayConstants_h */
