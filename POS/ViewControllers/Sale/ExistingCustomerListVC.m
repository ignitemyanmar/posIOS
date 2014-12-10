//
//  ExistingCustomerListVC.m
//  POS
//
//  Created by Macbook Pro on 4/28/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "ExistingCustomerListVC.h"
#import "ZMFMDBSQLiteHelper.h"

@interface ExistingCustomerListVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *customerListTV;
@property (strong, nonatomic) NSArray* customerList;

@end

@implementation ExistingCustomerListVC

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
    
    ZMFMDBSQLiteHelper* db = [ZMFMDBSQLiteHelper new];
    _customerList = [db getAllCustomers];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadViewHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) reloadViewHeight
{
    float currentTotal = 0;
    
    //Need to total each section
    for (int i = 0; i < [self.customerListTV numberOfSections]; i++)
    {
        CGRect sectionRect = [self.customerListTV rectForSection:i];
        currentTotal += sectionRect.size.height;
    }
    
    if (currentTotal > 528.0f)
    {
        currentTotal = 528.0f;
    }
    //Set the contentSizeForViewInPopover
    self.preferredContentSize = CGSizeMake(self.customerListTV.frame.size.width, currentTotal);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _customerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"CustomerCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    Customer* customer = _customerList[indexPath.row];
    cell.textLabel.text = customer.cusName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate didTap];
    Customer *cus = _customerList[indexPath.row];
    _selectedCustomer = cus;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didTap" object:self];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
