//
//  AddNewSubCategoryVC.m
//  POS
//
//  Created by Macbook Pro on 8/14/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AddNewSubCategoryVC.h"
#import "ZMKeypad.h"
#import "ZMFMDBSQLiteHelper.h"
#import "JDStatusBarNotification.h"
#import "AllCategoryListVC.h"

@interface AddNewSubCategoryVC () <UITextFieldDelegate>

@property (strong, nonatomic) UIPopoverController* myPopoverController;
@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseCategory;
@property (weak, nonatomic) IBOutlet UITextField *txtSubcat;
- (IBAction)SaveNewSubCat:(id)sender;
- (IBAction)Cancel:(id)sender;


@end

@implementation AddNewSubCategoryVC

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
    ZMKeypad *keypad = [ZMKeypad new];
    [keypad setTextView:_txtSubcat];
    _txtSubcat.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCategory:) name:@"didSelectCategory" object:nil];
    _btnChooseCategory.layer.borderColor = [[UIColor grayColor] CGColor];
    _btnChooseCategory.layer.borderWidth = 1.7f;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _myPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    
    AllCategoryListVC* catvc = [(UIStoryboardPopoverSegue *)segue destinationViewController];
    catvc.isCategoryLoad = YES;
    
}



- (void)didSelectCategory:(NSNotification*)noti
{
    NSString* strcat = (NSString*)noti.object;
    [_btnChooseCategory setTitle:strcat forState:UIControlStateNormal];
    [_myPopoverController dismissPopoverAnimated:YES];
}

- (IBAction)SaveNewSubCat:(id)sender {
    
    if ((_txtSubcat.text.length > 0) && (![_btnChooseCategory.titleLabel.text isEqualToString:@"Choose Category"])) {
        [_db createSubcategoryTable];
        BOOL isSubcatInthere = [_db getSubcategory:_txtSubcat.text];
        if (!isSubcatInthere) {
            Subcategory* subcatobj = [[Subcategory alloc] initWithDictionary:@{@"subcategory": _txtSubcat.text, @"category": _btnChooseCategory.titleLabel.text} error:nil];
            [_db insertSubcategory:subcatobj];
            [self JDStatusBarHidden:NO status:@"Successfully inserted!" duration:3.0f];
            _txtSubcat.text = @"";
        }
        else {
            [self JDStatusBarHidden:NO status:@"Already added!" duration:3.0f];
            _txtSubcat.text = @"";
        }
    }
    else [self JDStatusBarHidden:NO status:@"Add Category & Subcategory to save!" duration:3.0f];
}

- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) JDStatusBarHidden:(BOOL)hidden status:(NSString *)status duration:(NSTimeInterval)interval
{
    if(hidden) {
        [JDStatusBarNotification dismiss];
    } else {
        [JDStatusBarNotification addStyleNamed:@"StatusBarStyle" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:251.0/255.0 green:143.0/255.0 blue:27.0/255.0 alpha:1.0];
            style.textColor = [UIColor whiteColor];
            return style;
        }];
        if(interval != 0) {
            [JDStatusBarNotification showWithStatus:status dismissAfter:interval styleName:@"StatusBarStyle"];
        } else {
            [JDStatusBarNotification showWithStatus:status styleName:@"StatusBarStyle"];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
}

@end
