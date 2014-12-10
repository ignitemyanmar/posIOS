//
//  AddNewSalePersonVC.m
//  POS
//
//  Created by Macbook Pro on 4/29/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AddNewSalePersonVC.h"
#import "ZMFMDBSQLiteHelper.h"
#import "ZMKeypad.h"
#import "JDStatusBarNotification.h"

@interface AddNewSalePersonVC () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)signup:(id)sender;

@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;




@end

@implementation AddNewSalePersonVC

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

- (IBAction)signup:(id)sender {
    
    if (_txtUsername.text.length > 0 && _txtPassword.text.length > 0) {
        [_db createSalePersonTable];
        SalePerson* saleperson = [_db getAllSaleperson:_txtUsername.text];
        if (!saleperson) {
            NSDictionary* dict = @{@"spusername": _txtUsername.text,
                                   @"sppassword": _txtPassword.text};
            SalePerson* spObj = [[SalePerson alloc] initWithDictionary:dict error:nil];
            [_db createSalePersonTable];
            [_db insertSalePerson:spObj];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSaleperson" object:_txtUsername.text];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didTap" object:nil];
            
         }
        else {
            [self JDStatusBarHidden:NO status:@"Username is already taken." duration:3.0f];
        }
        _txtUsername.text = @"";
        _txtPassword.text = @"";
    }
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
