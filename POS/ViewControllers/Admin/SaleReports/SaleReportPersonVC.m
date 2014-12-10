//
//  SaleReportPersonVC.m
//  POS
//
//  Created by Macbook Pro on 4/30/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "SaleReportPersonVC.h"
#import "ZMFMDBSQLiteHelper.h"
#import "SaleReportCell.h"

@interface SaleReportPersonVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnSalePerson;
@property (strong, nonatomic) IBOutlet UIButton *btnFromDate;
@property (strong, nonatomic) IBOutlet UIButton *btnToDate;
@property (strong, nonatomic) IBOutlet UITableView *tvSaleTransaction;
@property (strong, nonatomic) IBOutlet UILabel *lblReportTotal;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;

@property (strong, nonatomic) NSArray* saleTransactions;

@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;

@property (strong, nonatomic) NSString *strbtn;

- (IBAction)search:(id)sender;

- (IBAction)doneButtonOnClick:(id)sender;
@property (strong, nonatomic) UIPopoverController* myPopoverController;

@end

@implementation SaleReportPersonVC

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

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelect:) name:@"didSelect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDate:) name:@"didSelectDate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectToDate:) name:@"didSelectToDate" object:nil];
    
    _lblReportTotal.text = @"0.00 Ks";
    
    _strbtn = [[NSUserDefaults standardUserDefaults] objectForKey:@"salereport"];
    if ([_strbtn isEqualToString:@"buyer"]) {
        [_btnSalePerson setTitle:@"Buyers" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    //    editPopover.delegate = (id <UIPopoverControllerDelegate>)self;
}

- (void)didSelectToDate:(NSNotification *)noti
{
    NSString* str = (NSString*)noti.object;
    [_btnToDate setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelectDate:(NSNotification *)noti
{
    NSString* str = (NSString*)noti.object;
    [_btnFromDate setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (void)didSelect:(NSNotification *)noti
{
    NSString* str = (NSString*)noti.object;
    [_btnSalePerson setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (IBAction)search:(id)sender {
    
    if (![_btnSalePerson.titleLabel.text isEqualToString:@"Sale Person"] && ![_btnFromDate.titleLabel.text isEqualToString:@"From Date"] && ![_btnToDate.titleLabel.text isEqualToString:@"To Date"])
    {
//        NSString* fromDate = [NSString stringWithFormat:@"%@ 00:00:00",_btnFromDate.titleLabel.text];
//        NSString* toDate = [NSString stringWithFormat:@"%@ 24:00:00",_btnToDate.titleLabel.text];
        _db = [ZMFMDBSQLiteHelper new];
        [_db createTransactionTable];
//        _saleTransactions = [_db getTransactionDaily:_btnFromDate.titleLabel.text];
        if ([_strbtn isEqualToString:@"person"]) {
             _saleTransactions = [_db getTransactionWithStartDate:_btnFromDate.titleLabel.text withEndDate:_btnToDate.titleLabel.text withSalePerson:_btnSalePerson.titleLabel.text];
        }
        else if ([_strbtn isEqualToString:@"buyer"]) {
            _saleTransactions = [_db getBuyerTransactionWithStartDate:_btnFromDate.titleLabel.text withEndDate:_btnToDate.titleLabel.text withBuyer:_btnSalePerson.titleLabel.text];
        }
       
        [_tvSaleTransaction reloadData];
        
        double reportTotal = 0.0;
        for (SaleTransaction* sale in _saleTransactions) {
            reportTotal += [sale.itemtotal doubleValue];
        }
        _lblReportTotal.text = [NSString stringWithFormat:@"%.2f Ks",reportTotal];
    }
}

- (IBAction)doneButtonOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _saleTransactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellID = @"SaleReportCell";
    SaleReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SaleReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    SaleTransaction* sale = _saleTransactions[indexPath.row];
    [_db createItemTable];
    Item* itemObj = [_db getItem:sale.itemid];
    cell.cellDate.text = sale.vdate;
    cell.cellItemName.text = [NSString stringWithFormat:@"%@-%@",sale.itemid,itemObj.itemName];
    cell.cellItemQty.text = sale.qty;
    cell.cellItemTotal.text = sale.itemtotal;
    cell.cellItemUnitPrice.text = [NSString stringWithFormat:@"%.2f",itemObj.itemPrice];
    return cell;
}
@end
