//
//  Credit.h
//  POS
//
//  Created by Macbook Pro on 5/21/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "JSONModel.h"

@interface Credit : JSONModel

@property (strong, nonatomic) NSString *creditCusName;
@property (strong, nonatomic) NSString *creditDate;
@property (strong, nonatomic) NSString *creditTotal;
@property (strong, nonatomic) NSString *creditPayAmt;
@property (strong, nonatomic) NSString *creditLeftToPayAmt;

@end
