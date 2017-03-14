//
//  OpenCVWrapper.h
//  Hotei
//
//  Created by Ryan Dowse on 14/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject
- (UIImage *) trainSVM: (double []) hr_arr
                andHRV:(double []) hrv_arr
              andState:(int []) label_arr
               andSize:(int) size;
- (UIImage *) getPlot;
- (UIImage *)plotData;
- (bool)predict: (double) hr andHRV: (double) hrv;
@end
