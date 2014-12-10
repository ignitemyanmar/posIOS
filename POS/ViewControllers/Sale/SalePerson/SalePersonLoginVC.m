//
//  SalePersonLoginVC.m
//  POS
//
//  Created by Macbook Pro on 4/29/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "SalePersonLoginVC.h"
#import "SalePerson.h"
#import "ZMFMDBSQLiteHelper.h"
#import "ZMKeypad.h"

@interface SalePersonLoginVC () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;

- (IBAction)login:(id)sender;

@end

@implementation SalePersonLoginVC

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
    [keypad setTextView:_txtUsername];
    _txtUsername.delegate = self;
    
    ZMKeypad *keypad1 = [ZMKeypad new];
    [keypad1 setTextView:_txtPassword];
    _txtPassword.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    [_db createSalePersonTable];
    SalePerson* saleperson = [_db getSalePersonWithName:_txtUsername.text withPassword:_txtPassword.text];
    if (saleperson) {
        //set login btn with sale person's name
        //dismiss login popover
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSaleperson" object:_txtUsername.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didTap" object:nil];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Can't log in." message:@"Please check your username & password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
@end
