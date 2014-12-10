//
//  UpdateBuyerVC.m
//  POS
//
//  Created by Macbook Pro on 5/21/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "UpdateBuyerVC.h"
#import "ZMFMDBSQLiteHelper.h"
#import "Customer.h"
#import "SaleReportCell.h"
#import "ZMKeypad.h"

@interface UpdateBuyerVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *dataFiller;
@property (strong, nonatomic) ZMFMDBSQLiteHelper *db;
@property (assign, nonatomic) double currentCusCredit;

@property (strong, nonatomic) IBOutlet UITableView *tbBuyer;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;

@property (strong, nonatomic) IBOutlet UIView *viewUpdate;
@property (strong, nonatomic) IBOutlet UIView *viewbkgUpdate;
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;


- (IBAction)btnDone:(id)sender;
- (IBAction)UpdateBuyerInfo:(id)sender;
- (IBAction)CancelUpdateView:(id)sender;



@end

@implementation UpdateBuyerVC

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
    
    _btnCancel.layer.borderColor = [[UIColor colorWithRed:3.0f/255 green:83.0f/255 blue:108.0f/255 alpha:1] CGColor];
    _btnCancel.layer.borderWidth = 1;
    
    _btnUpdate.layer.borderColor = [[UIColor colorWithRed:3.0f/255 green:83.0f/255 blue:108.0f/255 alpha:1] CGColor];
    _btnUpdate.layer.borderWidth = 1;
    
    _viewbkgUpdate.layer.borderColor = [[UIColor colorWithRed:3.0f/255 green:83.0f/255 blue:108.0f/255 alpha:1] CGColor];
    _viewbkgUpdate.layer.borderWidth = 1;

    _lblName.layer.borderWidth = 1;
    _lblName.layer.borderColor = [[UIColor grayColor] CGColor];
    
    ZMKeypad *keypad = [[ZMKeypad alloc] init];
    [keypad setTextView:self.txtCity];
    self.txtCity.delegate = self;
    
    ZMKeypad *keypad1 = [[ZMKeypad alloc] init];
    [keypad1 setTextView:self.txtPhone];
    self.txtPhone.delegate = self;
    
    ZMKeypad *keypad2 = [[ZMKeypad alloc] init];
    [keypad2 setTextView:self.txtAddress];
    self.txtAddress.delegate = self;

    
    _db = [ZMFMDBSQLiteHelper new];
    [_db createCustomerTable];
    _dataFiller = [[_db getAllCustomers] mutableCopy];
    
    _viewUpdate.hidden = YES;
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

- (void)myAction:(id)sender event:(id)event
{
    UIButton *btnVD = (UIButton *)sender;
    Customer* cusObj = _dataFiller[btnVD.tag];
    
    [_dataFiller removeObjectAtIndex:btnVD.tag];
    [_tbBuyer reloadData];
    [_db createCustomerTable];
    [_db removeCustormer:cusObj.cusName];
    
//    VoucherVC *destVC = (VoucherVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"VoucherVC"];
//    destVC.voucherid = sale.vid;
//    destVC.vouncherdate = _btnSelectDate.titleLabel.text;
//    destVC.voucherbuyer = sale.cusname;
//    [self presentViewController:destVC animated:YES completion:nil];
    
}

- (void)myUpdateAction:(id)sender event:(id)event
{
    _viewUpdate.hidden = NO;
    
    UIButton *btnVD = (UIButton *)sender;
    Customer* cusObj = _dataFiller[btnVD.tag];
    _lblName.text = cusObj.cusName;
    _txtCity.text = cusObj.cusCity;
    _txtPhone.text = cusObj.cusPh;
    _txtAddress.text = cusObj.cusAddress;
    _currentCusCredit = cusObj.cusCredit;
}

#pragma UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"buyerCell";
    SaleReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SaleReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    Customer* buyer = _dataFiller[indexPath.row];
    //    [_db createItemTable];
    //    Item* itemObj = [_db getItem:sale.itemid];
    //    NSDate* datewithNewFormat = [_dateFormat dateFromString:sale.vdate];
    //    cell.cellDate.text = sale.vdate;
    cell.cellItemName.text = buyer.cusName;//[NSString stringWithFormat:@"%@-%@",sale.itemid,itemObj.itemName];
    cell.cellItemQty.text = buyer.cusCity;
    cell.cellItemTotal.text = buyer.cusAddress;
    cell.cellItemUnitPrice.text = buyer.cusPh;//[NSString stringWithFormat:@"%.2f",itemObj.itemPrice];
    
    UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCell.frame = CGRectMake(0.0f, 0.0f, cell.cellBtnBkgView.frame.size.width, cell.cellBtnBkgView.frame.size.height);
    btnCell.backgroundColor = [UIColor clearColor];
    [btnCell setTitle:@"Delete" forState:UIControlStateNormal];
    [btnCell setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCell addTarget:self action:@selector(myAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCell.tag = indexPath.row;
    [cell.cellBtnBkgView addSubview:btnCell];
    
    UIButton *btnCellUpdate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCellUpdate.frame = CGRectMake(0.0f, 0.0f, cell.cellUpdateBtnBkgView.frame.size.width, cell.cellUpdateBtnBkgView.frame.size.height);
    btnCellUpdate.backgroundColor = [UIColor clearColor];
    [btnCellUpdate setTitle:@"Update" forState:UIControlStateNormal];
    [btnCellUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCellUpdate addTarget:self action:@selector(myUpdateAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    btnCellUpdate.tag = indexPath.row;
    [cell.cellUpdateBtnBkgView addSubview:btnCellUpdate];
    
    
    return cell;
}


- (IBAction)btnDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)UpdateBuyerInfo:(id)sender {
    
    NSDictionary *cusDictionary = @{@"cusName": _lblName.text,
                                    @"cusCity": _txtCity.text,
                                    @"cusPh": _txtPhone.text,
                                    @"cusAddress": _txtAddress.text,
                                    @"cusCredit": @(_currentCusCredit)
                                    };
    Customer *cusObj = [[Customer alloc] initWithDictionary:cusDictionary error:nil];
    
    [_db createCustomerTable];
    [_db updateCustomerInfo:cusObj withName:_lblName.text];
    
    _dataFiller = [[_db getAllCustomers] mutableCopy];
    [_tbBuyer reloadData];
    
    _viewUpdate.hidden = YES;
    
    
}

- (IBAction)CancelUpdateView:(id)sender {
    _viewUpdate.hidden = YES;
}
@end
