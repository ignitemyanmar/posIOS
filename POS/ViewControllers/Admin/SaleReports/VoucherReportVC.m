//
//  VoucherReportVC.m
//  POS
//
//  Created by Macbook Pro on 5/20/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "VoucherReportVC.h"
#import "SaleReportCell.h"
#import "SaleTransaction.h"
#import "Item.h"
#import "ZMFMDBSQLiteHelper.h"
#import "VoucherVC.h"

@interface VoucherReportVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *dataFiller;
@property (strong, nonatomic) ZMFMDBSQLiteHelper *db;
@property (strong, nonatomic) UIPopoverController *myPopoverController;

@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UITableView *tbVoucherList;
@property (strong, nonatomic) IBOutlet UILabel *lblAllTotal;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectDate;


- (IBAction)Done:(id)sender;
- (IBAction)SelectDate:(id)sender;
- (IBAction)Search:(id)sender;

@end

@implementation VoucherReportVC

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectVoucherDate:) name:@"didSelectVoucherDate" object:nil];
    
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

- (IBAction)Done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)SelectDate:(id)sender {
}

- (IBAction)Search:(id)sender {
    
    _db = [ZMFMDBSQLiteHelper new];
    [_db createTransactionTable];
    
    _dataFiller = [_db getTransactionVoucher:_btnSelectDate.titleLabel.text];
    [_tbVoucherList reloadData];
    
    double reportTotal = 0.0;
    for (SaleTransaction* sale in _dataFiller) {
        reportTotal += [sale.total doubleValue];
    }
    _lblAllTotal.text = [NSString stringWithFormat:@"%.2f Ks",reportTotal];
}

- (void)didSelectVoucherDate:(NSNotification *)notification
{
    NSString* str = (NSString*)notification.object;
    [_btnSelectDate setTitle:str forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    //    editPopover.delegate = (id <UIPopoverControllerDelegate>)self;
}

- (void)myAction:(id)sender event:(id)event
{
    UIButton *btnVD = (UIButton *)sender;
    SaleTransaction* sale = _dataFiller[btnVD.tag];
    
    VoucherVC *destVC = (VoucherVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"VoucherVC"];
    destVC.voucherid = sale.vid;
    destVC.vouncherdate = _btnSelectDate.titleLabel.text;
    destVC.voucherbuyer = sale.cusname;
    [self presentViewController:destVC animated:YES completion:nil];

}


#pragma UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"voucherReportCell";
    SaleReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SaleReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    SaleTransaction* sale = _dataFiller[indexPath.row];
//    [_db createItemTable];
//    Item* itemObj = [_db getItem:sale.itemid];
    //    NSDate* datewithNewFormat = [_dateFormat dateFromString:sale.vdate];
    //    cell.cellDate.text = sale.vdate;
    cell.cellItemName.text = sale.vid;//[NSString stringWithFormat:@"%@-%@",sale.itemid,itemObj.itemName];
    cell.cellItemQty.text = sale.cusname;
//    cell.cellItemTotal.text = sale.total;
    cell.cellItemUnitPrice.text = sale.total;//[NSString stringWithFormat:@"%.2f",itemObj.itemPrice];
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"View Detail" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(myAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];

    
    return cell;
}

@end
