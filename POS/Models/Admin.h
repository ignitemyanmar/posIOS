//
//  Admin.h
//  POS
//
//  Created by Macbook Pro on 5/2/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "JSONModel.h"

@interface Admin : JSONModel

@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* password;

@end
