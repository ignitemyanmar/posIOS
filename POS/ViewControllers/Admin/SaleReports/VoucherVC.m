//
//  VoucherVC.m
//  POS
//
//  Created by Macbook Pro on 5/20/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "VoucherVC.h"
#import "SaleTransaction.h"
#import "Item.h"
#import "SaleReportCell.h"
#import "ZMFMDBSQLiteHelper.h"

@interface VoucherVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) ZMFMDBSQLiteHelper *db;

@property (strong, nonatomic) IBOutlet UILabel *lblVoucherNo;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblBuyer;
@property (strong, nonatomic) IBOutlet UILabel *lblVoucherTotal;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;

- (IBAction)Done:(id)sender;

@end

@implementation VoucherVC

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
    
    _db = [ZMFMDBSQLiteHelper new];
    
    [_db createTransactionTable];
    
    _dataFiller = [_db getTransactionByVoucher:_voucherid];
    
    double reportTotal = 0.0;
    for (SaleTransaction* sale in _dataFiller) {
        reportTotal += [sale.itemtotal doubleValue];
    }
    _lblVoucherTotal.text = [NSString stringWithFormat:@"%.2f Ks",reportTotal];
    
    _lblVoucherNo.text = [NSString stringWithFormat:@"#%@",_voucherid];
    _lblDate.text = _vouncherdate;
    _lblBuyer.text = [NSString stringWithFormat:@"Buyer: %@",_voucherbuyer];
    
    _btnDone.layer.borderColor = [[UIColor colorWithRed:3.0f/255 green:83.0f/255 blue:108.0f/255 alpha:1] CGColor];
    _btnDone.layer.borderWidth = 1;

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

#pragma UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"voucherCell";
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


- (IBAction)Done:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
