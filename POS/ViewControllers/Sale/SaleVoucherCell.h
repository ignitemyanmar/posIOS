//
//  SaleVoucherCell.h
//  POS
//
//  Created by Macbook Pro on 5/7/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleVoucherCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellItemName;
@property (strong, nonatomic) IBOutlet UILabel *cellItemQty;
@property (strong, nonatomic) IBOutlet UILabel *cellItemTotal;


@end
