//
//  AddNewCustomerInfoVC.m
//  POS
//
//  Created by Zune Moe on 3/19/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AddNewCustomerInfoVC.h"

#import "ZMFMDBSQLiteHelper.h"
#import "ZMKeypad.h"

@interface AddNewCustomerInfoVC () <UITextFieldDelegate>

@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;

@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;

- (IBAction)saveCustomerInfoOnClicked:(id)sender;

@end

@implementation AddNewCustomerInfoVC

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
    
    ZMKeypad *keypad = [[ZMKeypad alloc] init];
    [keypad setTextView:self.txtName];
    self.txtName.delegate = self;
    
    ZMKeypad *keypad1 = [[ZMKeypad alloc] init];
    [keypad1 setTextView:self.txtCity];
    self.txtCity.delegate = self;
    
    ZMKeypad *keypad2 = [[ZMKeypad alloc] init];
    [keypad2 setTextView:self.txtPhone];
    self.txtPhone.delegate = self;
    
    ZMKeypad *keypad3 = [[ZMKeypad alloc] init];
    [keypad3 setTextView:self.txtAddress];
    self.txtAddress.delegate = self;
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

- (IBAction)saveCustomerInfoOnClicked:(id)sender {
    
    
    if (_txtName.text.length > 0 && _txtCity.text.length > 0 && _txtPhone.text.length > 0 && _txtPhone.text.length > 0) {
        
        //Check same customer name already exist
        Customer* resultCustomer = [self.db getCustomer:_txtName.text];
        if (resultCustomer) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Customer name already exist" message:@"Please use another name for new customer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else {
            
            self.db = [ZMFMDBSQLiteHelper new];
            
            NSDictionary *cusDictionary = @{@"cusName": _txtName.text,
                                            @"cusCity": _txtCity.text,
                                            @"cusPh": _txtPhone.text,
                                            @"cusAddress": _txtAddress.text,
                                            @"cusCredit": @(0)
                                            };
            
            Customer *customer = [[Customer alloc] initWithDictionary:cusDictionary error:nil];
            
            [self.db createCustomerTable];
            [self.db insertCustomer:customer];
            
            _txtName.text = @"";
            _txtCity.text = @"";
            _txtPhone.text = @"";
            _txtAddress.text = @"";
            
            [_txtName becomeFirstResponder];
            
        }
        
        
        
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"All fields are required" message:@"All customer information are required to add a new customer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end
