//
//  SaleTransaction.h
//  POS
//
//  Created by Macbook Pro on 4/25/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "JSONModel.h"

@interface SaleTransaction : JSONModel

//tranDict[@"vid"], tranDict[@"cusname"], tranDict[@"itemid"], tranDict[@"qty"], tranDict[@"itemtotal"],tranDict[@"vdate"], tranDict[@"total"

@property (strong, nonatomic) NSString *vid;
@property (strong, nonatomic) NSString *cusname;
@property (strong, nonatomic) NSString *itemid;
@property (strong, nonatomic) NSString *qty;
@property (strong, nonatomic) NSString *itemtotal;
@property (strong, nonatomic) NSString *vdate;
@property (strong, nonatomic) NSString *total;
@property (strong, nonatomic) NSString *salePerson;

@end
