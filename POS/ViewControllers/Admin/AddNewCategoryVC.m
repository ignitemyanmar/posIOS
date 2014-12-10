//
//  AddNewCategoryVC.m
//  POS
//
//  Created by Macbook Pro on 8/13/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//

#import "AddNewCategoryVC.h"
#import "ZMFMDBSQLiteHelper.h"
#import "ZMKeypad.h"
#import "JDStatusBarNotification.h"

@interface AddNewCategoryVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (strong, nonatomic) ZMFMDBSQLiteHelper* db;

- (IBAction)SaveCategory:(id)sender;

@end

@implementation AddNewCategoryVC

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
    [keypad setTextView:_txtCategory];
    _txtCategory.delegate = self;

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

- (IBAction)SaveCategory:(id)sender {
    if (_txtCategory.text.length > 0) {
        [_db createCategoryTable];
        BOOL isCatinThere = [_db getCategory:_txtCategory.text];
        if (!isCatinThere) {
            ItemCategory* catobj = [[ItemCategory alloc] initWithDictionary:@{@"category": _txtCategory.text} error:nil];
            [_db insertCategory:catobj];
            [self JDStatusBarHidden:NO status:@"Successfully inserted!" duration:3.0f];
            _txtCategory.text = @"";
        }
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
