//
//  UpdateAdminAccountVC.m
//  POS
//
//  Created by Macbook Pro on 5/2/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "UpdateAdminAccountVC.h"
#import "Admin.h"
#import "ZMFMDBSQLiteHelper.h"
#import "ZMKeypad.h"

@interface UpdateAdminAccountVC () <UITextFieldDelegate>

@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;

@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtNewUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPassword;
- (IBAction)updateAdminInfo:(id)sender;

@end

@implementation UpdateAdminAccountVC

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
//    _db = [ZMFMDBSQLiteHelper new];
//    Admin* admin = [_db getAdminInfo];
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"Admin"];
    Admin* admin = [[Admin alloc] initWithDictionary:dict error:nil];
    _lblUsername.text = admin.username;
    
    ZMKeypad *keypad = [[ZMKeypad alloc] init];
    [keypad setTextView:self.txtPassword];
    self.txtPassword.delegate = self;
    
    ZMKeypad *keypad1 = [[ZMKeypad alloc] init];
    [keypad1 setTextView:self.txtNewUsername];
    self.txtNewUsername.delegate = self;
    
    ZMKeypad *keypad2 = [[ZMKeypad alloc] init];
    [keypad2 setTextView:self.txtNewPassword];
    self.txtNewPassword.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateAdminInfo:(id)sender {
    
    if (_lblUsername.text.length > 0) {
        NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"Admin"];
        Admin* admin = [[Admin alloc] initWithDictionary:dict error:nil];
        if ([admin.password isEqualToString:_txtPassword.text]) {
            if (_txtNewUsername.text.length > 0 && _txtNewPassword.text.length > 0) {
                NSDictionary* dict = @{@"username": _txtNewUsername.text,
                                       @"password": _txtNewPassword.text};
                //    Admin* admin = [[Admin alloc] initWithDictionary:dict error:nil];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"Admin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
           
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Can't Save!" message:@"Current password is wrong." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    else {
        NSDictionary* dict = @{@"username": _txtNewUsername.text,
                               @"password": _txtNewPassword.text};
        //    Admin* admin = [[Admin alloc] initWithDictionary:dict error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"Admin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //    [_db createAdminTable];
        //    [_db insertAdmin:admin];
    }
}
@end
