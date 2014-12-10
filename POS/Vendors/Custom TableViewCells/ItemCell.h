//
//  ItemCell.h
//  POS
//
//  Created by Zune Moe on 3/18/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface ItemCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UITextField *itemQty;
@property (weak, nonatomic) IBOutlet UILabel *itemUnitPrice;
@property (weak, nonatomic) IBOutlet UILabel *itemTotalPrice;

- (void)configureCell:(Item *)item quantity:(int)quantity indexPath:(NSIndexPath *)indexPath;
@end
