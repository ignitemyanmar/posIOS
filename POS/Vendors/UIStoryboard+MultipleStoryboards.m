//
//  UIStoryboard+MultipleStoryboards.m
//  POS
//
//  Created by Zune Moe on 3/17/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "UIStoryboard+MultipleStoryboards.h"

@implementation UIStoryboard (MultipleStoryboards)

+ (UIStoryboard *)getSaleStoryboard
{
    return [UIStoryboard storyboardWithName:@"Sale" bundle:nil];
}

+ (UIStoryboard *)getAdminStoryboard
{
    return [UIStoryboard storyboardWithName:@"Admin" bundle:nil];
}

@end
