//
//  AllCategoryListVC.m
//  POS
//
//  Created by Macbook Pro on 8/14/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AllCategoryListVC.h"
#import "ZMFMDBSQLiteHelper.h"
#import "AllCategoryListVC.h"

@interface AllCategoryListVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tvSalePerson;
@property (strong, nonatomic) NSArray* categorylist;
@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;
@property (strong, nonatomic) NSString* strReport;



@end

@implementation AllCategoryListVC

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
    if (_isCategoryLoad) {
        [_db createCategoryTable];
        _categorylist = [_db getAllCategory];
    }
    else {
        [_db createSubcategoryTable];
        _categorylist = [_db getAllSubcategory];
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
    return _categorylist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellID = @"categorylistCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (_isCategoryLoad) {
        ItemCategory* catobj = _categorylist[indexPath.row];
        cell.textLabel.text = catobj.category;

    }
    else {
        Subcategory* subobj = _categorylist[indexPath.row];
        cell.textLabel.text = subobj.subcategory;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isCategoryLoad) {
        ItemCategory* catobj = _categorylist[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectCategory" object:catobj.category];
    }
    else {
        Subcategory* subcatobj = _categorylist[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectSubCat" object:subcatobj.subcategory];
    }
    
}


@end
