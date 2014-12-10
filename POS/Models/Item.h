//
//  Item.h
//  POS
//
//  Created by Zune Moe on 3/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "JSONModel.h"

@interface Item : JSONModel
@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) NSString *itemName;
@property (assign, nonatomic) double itemPrice;
@property (strong, nonatomic) NSString *itemCategory;
@end
