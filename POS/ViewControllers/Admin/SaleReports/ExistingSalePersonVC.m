//
//  ExistingSalePersonVC.m
//  POS
//
//  Created by Macbook Pro on 4/30/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "ExistingSalePersonVC.h"
#import "ZMFMDBSQLiteHelper.h"

@interface ExistingSalePersonVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tvSalePerson;
@property (strong, nonatomic) NSMutableArray* salepersons;
@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;
@property (strong, nonatomic) NSString* strReport;

@end

@implementation ExistingSalePersonVC

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
    NSArray *tempArr;
    _strReport = [[NSUserDefaults standardUserDefaults] objectForKey:@"salereport"];
    if ([_strReport isEqualToString:@"person"]) {
        tempArr = [_db getAllSalepersonNames];

    }
    else if ([_strReport isEqualToString:@"buyer"] || [_strReport isEqualToString:@"credit"])
    {
        tempArr = [_db getAllCustomers];
    }
    
    _salepersons = [[NSMutableArray alloc] initWithCapacity:tempArr.count+1];
    if (![_strReport isEqualToString:@"credit"]) {
        [_salepersons addObject:@"All"];
    }
    
    if ([_strReport isEqualToString:@"buyer"] || [_strReport isEqualToString:@"credit"]) {
        for (Customer* cusObj in tempArr) {
            [_salepersons addObject:cusObj.cusName];
        }
        
    }
    else if ([_strReport isEqualToString:@"person"]) {
        for (NSString* name in tempArr) {
            [_salepersons addObject:name];
        }
    }
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
    for (int i = 0; i < [self.tvSalePerson numberOfSections]; i++)
    {
        CGRect sectionRect = [self.tvSalePerson rectForSection:i];
        currentTotal += sectionRect.size.height;
    }
    
    if (currentTotal > 528.0f)
    {
        currentTotal = 528.0f;
    }
    //Set the contentSizeForViewInPopover
    self.preferredContentSize = CGSizeMake(self.tvSalePerson.frame.size.width, currentTotal);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _salepersons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellID = @"salepersonCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = _salepersons[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelect" object:_salepersons[indexPath.row]];
    
    if ([_strReport isEqualToString:@"credit"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectBuyerFromCredit" object:_salepersons[indexPath.row]];
    }
}

@end
