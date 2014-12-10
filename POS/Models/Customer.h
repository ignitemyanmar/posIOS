//
//  Customer.h
//  POS
//
//  Created by Macbook Pro on 4/23/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "JSONModel.h"

@interface Customer : JSONModel

@property (strong, nonatomic) NSString* cusName;
@property (strong, nonatomic) NSString* cusCity;
@property (strong, nonatomic) NSString* cusPh;
@property (strong, nonatomic) NSString* cusAddress;
@property (assign, nonatomic) double cusCredit;

@end
