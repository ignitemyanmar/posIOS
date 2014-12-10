//
//  CreditReportVC.m
//  POS
//
//  Created by Macbook Pro on 5/21/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "CreditReportVC.h"
#import "SaleReportCell.h"
#import "Credit.h"
#import "ZMFMDBSQLiteHelper.h"
#import "Customer.h"

@interface CreditReportVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *dataFiller;
@property (strong, nonatomic) UIPopoverController *myPopoverController;
@property (strong, nonatomic) ZMFMDBSQLiteHelper *db;

@property (strong, nonatomic) IBOutlet UIButton *btnSelectBuyer;
@property (strong, nonatomic) IBOutlet UITableView *tbCredit;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalCredit;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;



- (IBAction)Search:(id)sender;
- (IBAction)Done:(id)sender;

@end

@implementation CreditReportVC

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
    
    _btnDone.layer.borderColor = [[UIColor colorWithRed:3.0f/255 green:83.0f/255 blue:108.0f/255 alpha:1] CGColor];
    _btnDone.layer.borderWidth = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectBuyerFromCredit:) name:@"didSelectBuyerFromCredit" object:nil];
    
    _db = [ZMFMDBSQLiteHelper new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"credit" forKey:@"salereport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectBuyerFromCredit:(NSNotification *)notification
{
    NSString* str = (NSString*)notification.object;
    [_btnSelectBuyer setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];

}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    //    editPopover.delegate = (id <UIPopoverControllerDelegate>)self;
}

- (IBAction)Search:(id)sender {
    [_db createCreditTable];
    _dataFiller = [_db getCreditByBuyer:_btnSelectBuyer.titleLabel.text];
    
    Customer *customer = [_db getCustomer:_btnSelectBuyer.titleLabel.text];
    
    _lblTotalCredit.text = [NSString stringWithFormat:@"%.2f Ks",customer.cusCredit];
    
    [_tbCredit reloadData];
}

- (IBAction)Done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"creditcell";
    SaleReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SaleReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    Credit* credit = _dataFiller[indexPath.row];
//    [_db createItemTable];
//    Item* itemObj = [_db getItem:sale.itemid];
    //    NSDate* datewithNewFormat = [_dateFormat dateFromString:sale.vdate];
    //    cell.cellDate.text = sale.vdate;
    cell.cellItemName.text = credit.creditDate;//[NSString stringWithFormat:@"%@-%@",sale.itemid,itemObj.itemName];
    cell.cellItemQty.text = [NSString stringWithFormat:@"%@ Ks",credit.creditTotal];//sale.qty;
    cell.cellItemTotal.text = [NSString stringWithFormat:@"%@ Ks", credit.creditLeftToPayAmt];//sale.itemtotal;
    cell.cellItemUnitPrice.text = [NSString stringWithFormat:@"%@ Ks", credit.creditPayAmt];//[NSString stringWithFormat:@"%.2f",itemObj.itemPrice];
    
    return cell;
}

@end
