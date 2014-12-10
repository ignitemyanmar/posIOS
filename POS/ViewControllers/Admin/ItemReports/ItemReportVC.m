//
//  ItemReportVC.m
//  POS
//
//  Created by Macbook Pro on 5/2/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "ItemReportVC.h"
#import "SaleReportCell.h"
#import "ZMFMDBSQLiteHelper.h"

@interface ItemReportVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tvItemReport;

@property (strong, nonatomic) IBOutlet UILabel *lblReportTotal;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;

@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;
@property (strong, nonatomic) NSArray* dataFiller;

@property (strong, nonatomic) NSDateFormatter *dateFormat;

- (IBAction)done:(id)sender;


@end

@implementation ItemReportVC

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
    
    _db = [ZMFMDBSQLiteHelper new];
    [_db createTransactionTable];
    _dateFormat = [[NSDateFormatter alloc]init];
    [_dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *currentdate = [_dateFormat stringFromDate:[NSDate date]];
    if ([_selectedReport isEqualToString:@"Daily"]) {
        _dataFiller = [_db getTransactionDaily:currentdate];
    }
    else if ([_selectedReport isEqualToString:@"Monthly"])
    {
        [_dateFormat setDateFormat:@"MM"];
        NSString *currentMonth = [_dateFormat stringFromDate:[NSDate date]];
        _dataFiller = [self.db getTransactionMonthly:currentMonth];
    }
    else {
        _dataFiller = [_db getTransactionWeekly:currentdate];
    }
    
    double reportTotal = 0.0;
    for (SaleTransaction* sale in _dataFiller) {
        reportTotal += [sale.itemtotal doubleValue];
    }
    _lblReportTotal.text = [NSString stringWithFormat:@"%.2f Ks",reportTotal];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"SaleReportCell";
    SaleReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SaleReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    SaleTransaction* sale = _dataFiller[indexPath.row];
    [_db createItemTable];
    Item* itemObj = [_db getItem:sale.itemid];
//    NSDate* datewithNewFormat = [_dateFormat dateFromString:sale.vdate];
//    cell.cellDate.text = sale.vdate;
    cell.cellItemName.text = [NSString stringWithFormat:@"%@-%@",sale.itemid,itemObj.itemName];
    cell.cellItemQty.text = sale.qty;
    cell.cellItemTotal.text = sale.itemtotal;
    cell.cellItemUnitPrice.text = [NSString stringWithFormat:@"%.2f",itemObj.itemPrice];
    
    return cell;
}

- (IBAction)done:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
