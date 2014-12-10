//
//  UIStoryboard+MultipleStoryboards.h
//  POS
//
//  Created by Zune Moe on 3/17/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (MultipleStoryboards)
+ (UIStoryboard *)getSaleStoryboard;
+ (UIStoryboard *)getAdminStoryboard;
@end
