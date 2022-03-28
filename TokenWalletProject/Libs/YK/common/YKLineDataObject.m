//
//  YKLineDataObject.m
//  YKCharts
//
//  Created by kang lin on 2018/3/26.
//  Copyright © 2018年 康林. All rights reserved.
//

#import "YKLineDataObject.h"

@implementation YKLineDataObject

-(CGFloat)max{
    if (_max != 0) {
        return  _max;
    }
    CGFloat tempMax = 0;
    for (NSNumber *number in self.showNumbers) {
        if ([number floatValue] > tempMax) {
            tempMax = [number floatValue];
        }
    }
    _max = tempMax + 200;
    return _max;
}

-(CGFloat)min{
    if (_min != 0) {
        return  _min;
    }
    CGFloat tempMin = [self.showNumbers.firstObject floatValue];
    for (NSNumber *number in self.showNumbers) {
        if ([number floatValue] < tempMin) {
            tempMin = [number floatValue];
        }
    }
    if (tempMin < 0) {
        _min = tempMin - 200;
    }else{
        _min = 0;
    }
    return _min;
}
@end
