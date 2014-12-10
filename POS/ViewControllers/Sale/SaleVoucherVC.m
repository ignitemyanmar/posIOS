//
//  SaleVoucherVC.m
//  POS
//
//  Created by Macbook Pro on 5/6/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "SaleVoucherVC.h"
#import "SaleVoucherCell.h"
#import "Item.h"

@interface SaleVoucherVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblVnumber;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UITableView *tvVoucher;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblVoucherTotal;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tvVoucherHeightConstrait;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bkgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstrait;


- (IBAction)done:(id)sender;

@end

@implementation SaleVoucherVC

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
    
//    self.view.opaque = YES;
//    self.view.backgroundColor = [UIColor clearColor];
    
//    self.view.backgroundColor = [UIColor clearColor];
//    UIView* backView = [[UIView alloc] initWithFrame:self.view.frame];
//    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//    [self.view addSubview:backView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    double tempTotal = 0.0;
    for (NSDictionary* dict in _buyingList) {
        Item* itemObj = dict[@"item"];
        int itemqty = [dict[@"quantity"] intValue];
        tempTotal += itemObj.itemPrice * itemqty;
    }
    
    _lblVoucherTotal.text = [NSString stringWithFormat:@"%.2f", tempTotal];
    _lblVnumber.text = [NSString stringWithFormat:@"# %@",_voucherNo];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    _lblDate.text = [dateFormat stringFromDate:[NSDate date]];
    
    _scrollView.backgroundColor = [UIColor redColor];
    _bkgView.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeInvoiceTVHeight
{
    int count;
    if (_buyingList.count == 0) count = 0;
    else count = _buyingList.count - 1;

    _tvVoucherHeightConstrait.constant = 30+(29*count);
    _scrollViewHeightConstrait.constant = 80 + _tvVoucherHeightConstrait.constant;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _buyingList.count;
}

//voucherCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"voucherCell";
    SaleVoucherCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    Item* itemObj = _buyingList[indexPath.row][@"item"];
    int qty = [_buyingList[indexPath.row][@"quantity"] intValue];
    double totalcost = itemObj.itemPrice * qty;
    
    cell.cellItemName.text = itemObj.itemName;
    cell.cellItemQty.text = [NSString stringWithFormat:@"%d",qty];
    cell.cellItemTotal.text = [NSString stringWithFormat:@"%.2f",totalcost];
    [self changeInvoiceTVHeight];
    return cell;
}

@end
