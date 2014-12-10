//
//  SaleReportCell.h
//  POS
//
//  Created by Macbook Pro on 4/30/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleReportCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellDate;
@property (strong, nonatomic) IBOutlet UILabel *cellItemName;
@property (strong, nonatomic) IBOutlet UILabel *cellItemQty;
@property (strong, nonatomic) IBOutlet UILabel *cellItemUnitPrice;
@property (strong, nonatomic) IBOutlet UILabel *cellItemTotal;
@property (strong, nonatomic) IBOutlet UIView *cellBtnBkgView;
@property (strong, nonatomic) IBOutlet UIView *cellUpdateBtnBkgView;



@end
