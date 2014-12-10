//
//  ItemReportListVC.m
//  POS
//
//  Created by Macbook Pro on 5/2/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "ItemReportListVC.h"
#import "ItemReportVC.h"
#import "UIStoryboard+MultipleStoryboards.h"

@interface ItemReportListVC ()

- (IBAction)showItemDailyReport:(id)sender;

- (IBAction)showItemWeeklyReport:(id)sender;

- (IBAction)showItemMonthlyReport:(id)sender;

@end

@implementation ItemReportListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showItemDailyReport:(id)sender {
    
    UIStoryboard* sb = [UIStoryboard getAdminStoryboard];
    ItemReportVC* destVC = (ItemReportVC*)[sb instantiateViewControllerWithIdentifier:@"ItemReportVC"];
    destVC.selectedReport = @"Daily";
    [self presentViewController:destVC animated:YES completion:nil];
}

- (IBAction)showItemWeeklyReport:(id)sender {
    
    UIStoryboard* sb = [UIStoryboard getAdminStoryboard];
    ItemReportVC* destVC = (ItemReportVC*)[sb instantiateViewControllerWithIdentifier:@"ItemReportVC"];
    destVC.selectedReport = @"Weekly";
    [self presentViewController:destVC animated:YES completion:nil];
}

- (IBAction)showItemMonthlyReport:(id)sender {
    
    UIStoryboard* sb = [UIStoryboard getAdminStoryboard];
    ItemReportVC* destVC = (ItemReportVC*)[sb instantiateViewControllerWithIdentifier:@"ItemReportVC"];
    destVC.selectedReport = @"Monthly";
    [self presentViewController:destVC animated:YES completion:nil];

}
@end
