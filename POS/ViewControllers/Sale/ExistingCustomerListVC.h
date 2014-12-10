//
//  ExistingCustomerListVC.h
//  POS
//
//  Created by Macbook Pro on 4/28/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"

@protocol DismissDelegate <NSObject>

-(void)didTap;

@end

@interface ExistingCustomerListVC : UIViewController

@property (strong, nonatomic) Customer* selectedCustomer;

@property (strong, nonatomic) id <DismissDelegate> delegate;

@end
