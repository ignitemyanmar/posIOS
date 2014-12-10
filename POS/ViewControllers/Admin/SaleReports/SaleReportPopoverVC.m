//
//  SaleReportPopoverVC.m
//  POS
//
//  Created by Macbook Pro on 5/20/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "SaleReportPopoverVC.h"
#import "SaleReportPersonVC.h"
#import "VoucherReportVC.h"

@interface SaleReportPopoverVC ()

- (IBAction)GotoSalepersonReport:(id)sender;

- (IBAction)GotoBuyerReport:(id)sender;

- (IBAction)GotoVoucherReport:(id)sender;
@end

@implementation SaleReportPopoverVC

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)GotoSalepersonReport:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"person" forKey:@"salereport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    SaleReportPersonVC *personReportVC = (SaleReportPersonVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"SaleReportPersonVC"];
    [self presentViewController:personReportVC animated:YES completion:nil];
}

- (IBAction)GotoBuyerReport:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"buyer" forKey:@"salereport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    SaleReportPersonVC *personReportVC = (SaleReportPersonVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"SaleReportPersonVC"];
    [self presentViewController:personReportVC animated:YES completion:nil];
}

- (IBAction)GotoVoucherReport:(id)sender {
    //VoucherReportVC
    
    VoucherReportVC *personReportVC = (VoucherReportVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"VoucherReportVC"];
    [self presentViewController:personReportVC animated:YES completion:nil];
}
@end
